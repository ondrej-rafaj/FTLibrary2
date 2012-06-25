//
//  NSArray+Tools.m
//  FT2Library
//
//  Created by Ondrej Rafaj on 14/02/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "NSArray+Tools.h"


@implementation NSArray (Tools)

- (NSArray *)reversedArray
{
    return self.reverseObjectEnumerator.allObjects;
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

- (NSArray *)safeSubarrayWithRange:(NSRange)range newRange:(NSRange *)returnedRange
{
	NSRange newRange = range;
	NSInteger count = [self count];
	if (range.location > count) {
		newRange.location = 0;
		newRange.length = 0;
		if (returnedRange) *returnedRange = newRange;
		return nil;
	} else {
		NSInteger remainingItemsNumber = count - range.location;
		if (remainingItemsNumber > range.length) {
			if (returnedRange) *returnedRange = newRange;
			return [self subarrayWithRange:range];
		}
		else {
			NSRange newRange = range;
			newRange.length = remainingItemsNumber;
			if (returnedRange) *returnedRange = newRange;
			return [self subarrayWithRange:newRange];
		}
	}
}

- (NSArray *)safeSubarrayWithRange:(NSRange)range
{
	return [self safeSubarrayWithRange:range newRange:NULL];
}

@end
