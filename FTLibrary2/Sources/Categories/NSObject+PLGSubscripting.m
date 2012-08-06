//
//  NSObject+PLGSubscripting.m
//  FTLibrary2
//
//  Created by A.Papadakis on 03/08/2012.
//
//

#import "NSObject+PLGSubscripting.h"

@implementation NSObject (PLGSubscripting)

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 60000

- (id)objectAtIndexedSubscript:(NSUInteger)idx
{
	return nil;
}

- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx
{
	
}

- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key
{
	
}

- (id)objectForKeyedSubscript:(id)key
{
	return nil;
}

#endif
@end
