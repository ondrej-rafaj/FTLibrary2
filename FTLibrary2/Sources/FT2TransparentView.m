//
//  FT2TransparentView.m
//  FTLibrary2
//
//  Created by Baldoph Pourprix on 06/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FT2TransparentView.h"

@implementation FT2TransparentView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
	UIView *v = [super hitTest:point withEvent:event];
	if (v == self) return nil;
	return v;
}

@end
