//
//  NSIndexPath+Tools.m
//  FT2Library
//
//  Created by Baldoph Pourprix on 27/02/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "NSIndexPath+Tools.h"

@implementation NSIndexPath (Tools)

- (BOOL)isParentOfIndexPath:(NSIndexPath *)indexPath
{
	if ([self length] > [indexPath length]) return NO;
	else {
		NSUInteger length = [self length];
		for (int i = 0; i < length; i++) {
			if ([self indexAtPosition:i] != [indexPath indexAtPosition:i]) return NO;
		}
	}
	return YES;
}

- (NSIndexPath *)indexPathByRemovingFirstIndex
{
	if ([self length] > 1) {
		NSUInteger componentsNumber = self.length - 1;
		NSUInteger indexes[componentsNumber];
		for (int i = 1; i < self.length; i++) {
			indexes[i-1] = [self indexAtPosition:i];
		}
		return [NSIndexPath indexPathWithIndexes:indexes length:componentsNumber];
	}
	else {
		return [NSIndexPath new];
	}
}

- (NSIndexPath *)indexPathByPrefixingWithIndex:(NSInteger)prefixIndex
{
	NSUInteger componentsNumber = self.length + 1;
	NSUInteger indexes[componentsNumber];
	indexes[0] = prefixIndex;
	for (int i = 0; i < self.length; i++) {
		indexes[i + 1] = [self indexAtPosition:i];
	}
	return [NSIndexPath indexPathWithIndexes:indexes length:componentsNumber];
}

- (NSInteger)lastIndex
{
	return [self indexAtPosition:[self length] - 1];
}

@end
