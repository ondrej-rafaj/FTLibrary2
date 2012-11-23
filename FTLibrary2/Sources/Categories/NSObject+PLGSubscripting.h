//
//  NSObject+PLGSubscripting.h
//  polligraf
//
//  Created by Matthew Wilkinson on 31/07/2012.
//  Copyright (c) 2012 fuerte international. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 60000
@interface NSObject (PLGSubscripting)

- (id)objectAtIndexedSubscript:(NSUInteger)idx;
- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx;
- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key;
- (id)objectForKeyedSubscript:(id)key;

@end
#endif