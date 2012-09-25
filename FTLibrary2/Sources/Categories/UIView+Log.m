//
//  UIView+Log.m
//  FTLibrary2
//
//  Created by A.Papadakis on 13/09/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "UIView+Log.h"
#import "UIView+Layout.h"
@interface UIView (LogPrivate)
- (NSString *)logPrefix:(NSString *)prefix;
@end
@implementation UIView (Log)
//public methods
- (void)logFrameWithPrefix:(NSString *)prefix
{
	NSLog(@"%@ --frame = %@",[self logPrefix:prefix],NSStringFromCGRect(self.frame));
}
- (void)logSizeWithPrefix:(NSString *)prefix
{
	NSLog(@"%@ --size = %@",[self logPrefix:prefix],NSStringFromCGSize(self.frame.size));
}
- (void)logOriginWithPrefix:(NSString *)prefix
{
	NSLog(@"%@ --origin = %@",[self logPrefix:prefix],NSStringFromCGPoint(self.frame.origin));
}
- (void)logBottomWithPrefix:(NSString *)prefix
{
	NSLog(@"%@ --bottom = %0.2f",[self logPrefix:prefix],self.bottom);
}

//Private methods
- (NSString       *)logPrefix:(NSString *)prefix
{
	return (prefix)?prefix:@"";
}
@end
