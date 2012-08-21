//
//  FT2MessagerView.m
//  FTLibrary2
//
//  Created by Baldoph on 21/08/2012.
//
//

#import "FT2MessagerView.h"

@implementation FT2MessagerView

@synthesize recipientView = _recipientView;

- (void)setRecipientView:(UIView *)recipientView
{
	[_recipientView removeFromSuperview];
	_recipientView = recipientView;
	[self addSubview:_recipientView];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
	CGPoint recipientConvertTouch = [self convertPoint:point toView:_recipientView];
	UIView *v = [_recipientView hitTest:recipientConvertTouch withEvent:event];
	if (v) {
		return v;
	}
	return _recipientView;
}

@end
