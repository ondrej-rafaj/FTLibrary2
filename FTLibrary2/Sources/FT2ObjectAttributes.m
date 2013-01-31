//
//  FT2ObjectAttributes.m
//  FTLibrary2
//
//  Created by Francesco on 19/04/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "FT2ObjectAttributes.h"
#import <CoreData/CoreData.h>
#import <objc/runtime.h>


@implementation FT2ObjectAttributes

+ (void)attributes:(NSMutableDictionary **)attributes forClass:(Class)class {    
    NSString *search = @"^T@\"([\\w]*)\"";
    NSError *error;
    NSRegularExpression *regEx = [NSRegularExpression regularExpressionWithPattern:search options:0 error:&error];
    
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList(class, &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        NSString *name = [NSString stringWithUTF8String:property_getName(property)];
        NSString *types = [NSString stringWithUTF8String:property_getAttributes(property)];
        __block NSString *type;
        // __block NSMutableArray *others;
        
        [regEx enumerateMatchesInString:types options:0 range:NSMakeRange(0, types.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            type = [types substringWithRange:[result rangeAtIndex:1]];
        }];
        
        [*attributes setValue:type forKey:name];
    }
    
    free(properties);
    
    if (class == [NSManagedObject class]) return;
    
    Class parent = class_getSuperclass(class);
    [self attributes:attributes forClass:parent];
    
}

+ (NSDictionary *)propertiesOfClass:(id)obj {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary]; 
    [self attributes:&dict forClass:[obj class]];
    
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
