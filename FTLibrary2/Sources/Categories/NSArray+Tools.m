//
//  NSArray+Tools.m
//  FT2Library
//
//  Created by Ondrej Rafaj on 14/02/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "NSArray+Tools.h"


@implementation NSArray (Tools)

- (NSArray *)reversedArray {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
    NSEnumerator *enumerator = [self reverseObjectEnumerator];
    for (id element in enumerator) {
        [array addObject:element];
    }
    return array;
}

+ (id)arrayByOrderingSet:(NSSet *)set byKey:(NSString *)key ascending:(BOOL)ascending {
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:[set count]];
    for (id oneObject in set)
        [ret addObject:oneObject];
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:key
															   ascending:ascending];
    [ret sortUsingDescriptors:[NSArray arrayWithObject:descriptor]];
    return ret;
}

@end
