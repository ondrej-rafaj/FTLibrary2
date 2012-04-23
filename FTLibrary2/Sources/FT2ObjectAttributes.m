//
//  FT2ObjectAttributes.m
//  FTLibrary2
//
//  Created by Francesco on 19/04/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "FT2ObjectAttributes.h"
#import <objc/runtime.h>


@implementation FT2ObjectAttributes

+ (NSDictionary *)propertiesOfClass:(id)obj {
    NSString *search = @"^T@\"([\\w]*)\"";
    NSError *error;
    NSRegularExpression *regEx = [NSRegularExpression regularExpressionWithPattern:search options:NSRegularExpressionSearch error:&error];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary]; 
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList(obj, &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        NSString *name = [NSString stringWithUTF8String:property_getName(property)];
        NSString *attributes = [NSString stringWithUTF8String:property_getAttributes(property)];
        __block NSString *type;
        // __block NSMutableArray *others;
        
        [regEx enumerateMatchesInString:attributes options:NSMatchingHitEnd range:NSMakeRange(0, attributes.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            type = [attributes substringWithRange:[result rangeAtIndex:1]];
        }];
        
        [dict setValue:type forKey:name];
    }
    
    Class parent = class_getSuperclass(obj);
    properties = class_copyPropertyList(parent, &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        NSString *name = [NSString stringWithUTF8String:property_getName(property)];
        NSString *attributes = [NSString stringWithUTF8String:property_getAttributes(property)];
        __block NSString *type;
        // __block NSMutableArray *others;
        
        [regEx enumerateMatchesInString:attributes options:NSMatchingHitEnd range:NSMakeRange(0, attributes.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            type = [attributes substringWithRange:[result rangeAtIndex:1]];
        }];
        
        [dict setValue:type forKey:name];
    }
    
    
    return (NSDictionary *)dict;
}

+ (BOOL)testValue:(id)value againstType:(NSString *)type {
    BOOL isValid;
    if ([type isEqualToString:@"NSSet"]) {
        isValid = [value isKindOfClass:[NSArray class]];
    }
    else {
        isValid = [value isKindOfClass:NSClassFromString(type)];
    }
    return isValid;
}

+ (BOOL)isDictionary:(NSDictionary *)dictionary complaintWithClass:(id)obj {
    NSDictionary *attributes = [FT2ObjectAttributes propertiesOfClass:obj];
    NSArray *attrKeys = [attributes allKeys];
    BOOL isCompliant = YES;
    for (NSString *key in attrKeys) {
        BOOL keyExists = [[dictionary allKeys] containsObject:key];
        if (!keyExists) isCompliant = NO;
        else {
            id value = [dictionary objectForKey:key];
            BOOL valueIsValid = [FT2ObjectAttributes testValue:value againstType:[attributes objectForKey:key]];
            if (!valueIsValid) isCompliant = NO;
        }
    }
    
    return isCompliant;
}

@end
