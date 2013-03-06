//
//  FTShadowView.m
//  FTLibrary2
//
//  Created by Baldoph on 22/08/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import "FT2ShadowView.h"

@implementation FT2ShadowView

@synthesize shadowRadius = _shadowRadius;
@synthesize shadowColor = _shadowColor;
@synthesize shadowStrength = _shadowStrength;

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		self.clipsToBounds = YES;
		
		_shadowRadius = 5;
		_shadowColor = [UIColor blackColor];
		_shadowStrength = 1;
		self.opaque = NO;
	}
	return self;
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	CGFloat usableRadius = _shadowRadius;
	
	if (_shadowRadius * 2 > CGRectGetWidth(rect)) {
		usableRadius = (CGRectGetWidth(rect) - 1 ) / 2.0;
	}
	if (_shadowRadius * 2 > CGRectGetHeight(rect)) {
		usableRadius = MIN(usableRadius, (CGRectGetHeight(rect) - 1 ) / 2.0);
	}
	
	CGRect shapeRect = CGRectInset(rect, usableRadius, usableRadius);
	
	CGContextSetShadowWithColor(ctx, CGSizeMake(rect.size.width, 0), _shadowRadius, _shadowColor.CGColor);
	
	[[UIColor blackColor] setFill];
	
	shapeRect = CGRectApplyAffineTransform(shapeRect, CGAffineTransformMakeTranslation(- CGRectGetWidth(rect), 0));
	for (int i = 0; i < _shadowStrength; i++) {
		CGContextFillRect(ctx, shapeRect);
	}
}

@end
