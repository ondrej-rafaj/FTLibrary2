//
//  NSString_Tools.h
//  FTLibrary2
//
//  Created by Baldoph Pourprix on 19/02/2013.
//  Copyright (c) 2013 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>

@implementation NSString (Tools)

- (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding {
	return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
															   (CFStringRef)self,
															   NULL,
															   (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
															   CFStringConvertNSStringEncodingToEncoding(encoding)));
}

+ (NSString *)randomString
{
	return [self randomStringOfLength:10];
}

+ (NSString *)randomStringOfLength:(int)length
{
	char data[length];
	for (int x=0;x<length;data[x++] = (char)('A' + (arc4random_uniform(26))));
	return [[NSString alloc] initWithBytes:data length:length encoding:NSUTF8StringEncoding];
}

@end
