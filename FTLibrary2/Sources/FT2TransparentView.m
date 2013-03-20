//
//  FT2TransparentView.m
//  FTLibrary2
//
//  Created by Baldoph Pourprix on 06/07/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "FT2TransparentView.h"

@implementation FT2TransparentView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
	UITouch *touch = event.allTouches.anyObject;
	UIView *v = [super hitTest:point withEvent:event];
	if (v == self || v == nil) {
		if (touch.phase == UITouchPhaseBegan) [_didTouchVoid invoke];
		return nil;
	} else {
		if (touch.phase == UITouchPhaseBegan) [_didTouchContent invoke];
	}
	return v;
}

@end
