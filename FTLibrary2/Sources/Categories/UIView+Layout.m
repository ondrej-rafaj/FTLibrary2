//
//  UIView+Layout.m
//  FT2Library
//
//  Created by Simon Lee on 21/12/2009.
//  Copyright 2009 Fuerte International. All rights reserved.
//

#import "UIView+Layout.h"


@implementation UIView (Layout)

- (void)setWidth:(CGFloat)width
{
	CGRect frame = self.frame;
	frame.size.width = width;
	self.frame = frame;
}

- (void)setHeight:(CGFloat)height
{
	CGRect frame = self.frame;
	frame.size.height = height;
	self.frame = frame;
}

- (void)setXOrigin:(CGFloat)xOrigin
{
	CGRect frame = self.frame;
	frame.origin.x = xOrigin;
	self.frame = frame;
}

- (void)setYOrigin:(CGFloat)yOrigin
{
	CGRect frame = self.frame;
	frame.origin.y = yOrigin;
	self.frame = frame;
}

- (void)setOrigin:(CGPoint)origin
{
	CGRect frame = self.frame;
	frame.origin = origin;
	self.frame = frame;
}

- (void)positionAtX:(CGFloat)xOrigin andY:(CGFloat)yOrigin
{
	CGRect frame = self.frame;
	frame.origin.x = xOrigin;
	frame.origin.y = yOrigin;
	self.frame = frame;
}

- (void)setSize:(CGSize)size
{
	CGRect frame = self.frame;
	frame.size = size;
	self.frame = frame;
}

- (void)setWidth:(CGFloat)width andHeight:(CGFloat)height
{
	CGRect frame = self.frame;
	frame.size.height = height;
	frame.size.width = width;
	self.frame = frame;
}

- (CGFloat)width
{
	return CGRectGetWidth(self.frame);
}

- (CGFloat)height
{
	return CGRectGetHeight(self.frame);
}

- (CGFloat)xOrigin
{
	return CGRectGetMinX(self.frame);
}

- (CGFloat)yOrigin
{
	return CGRectGetMinY(self.frame);
}

- (CGFloat)bottom
{
	return CGRectGetMaxY(self.frame);
}

- (void)setBottom:(CGFloat)bottom
{
	CGRect frame = self.frame;
	frame.origin.y = bottom - frame.size.height;
	self.frame = frame;
}

- (CGFloat)right
{
	return CGRectGetMaxY(self.frame);
}

- (void)setRight:(CGFloat)right
{
	CGRect frame = self.frame;
	frame.origin.x = right - frame.size.width;
	self.frame = frame;
}

- (CGPoint)boundsCenter
{
	CGRect frame = self.frame;
	return CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
}

- (void)setCenterIntegral:(CGPoint)center
{
	self.center = center;
	self.frame = CGRectIntegral(self.frame);
}

//superview related
- (void)centerInSuperview
{
	if (self.superview) {
		CGRect frame = self.frame;
		frame.origin.x = roundf((self.superview.width - self.width) / 2.f);
		frame.origin.y = roundf((self.superview.height - self.height) / 2.f);
		self.frame = frame;
	}
}

- (CGFloat)bottomMargin
{
	if (self.superview) {
		return self.superview.height - self.bottom;	
	}
	return 0;
}

- (void)setBottomMargin:(CGFloat)bottomMargin
{
	if (self.superview) {
		CGRect frame = self.frame;
		frame.origin.y = self.superview.height - bottomMargin - self.height;
		self.frame = frame;
	}
}

- (CGFloat)rightMargin
{
	if (self.superview) {
		return self.superview.width - self.right;	
	}
	return 0;
}

- (void)setRightMargin:(CGFloat)rightMargin
{
	if (self.superview) {
		CGRect frame = self.frame;
		frame.origin.x = self.superview.width - rightMargin - self.width;
		self.frame = frame;
	}
}

@end
