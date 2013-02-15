//
//  UIView+Layout.m
//  FT2Library
//
//  Created by Simon Lee on 21/12/2009.
//  Copyright 2009 Fuerte International. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UIView+Layout.h"

@implementation UIView (Layout)

- (void)addSubviews:(NSArray *)views
{
	[views enumerateObjectsUsingBlock:^(UIView *v, NSUInteger idx, BOOL *stop) { [self addSubview:v]; }];
}

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

- (CGPoint)origin
{
	return self.frame.origin;
}

- (CGSize)size
{
	return self.frame.size;
}

- (void)setBottom:(CGFloat)bottom
{
	CGRect frame = self.frame;
	frame.origin.y = bottom - frame.size.height;
	self.frame = frame;
}

- (CGFloat)right
{
	return CGRectGetMaxX(self.frame);
}

- (void)setRight:(CGFloat)right
{
	CGRect frame = self.frame;
	frame.origin.x = right - frame.size.width;
	self.frame = frame;
}

- (void)setMargins:(UIEdgeInsets)margins
{
	if (self.superview) {
		CGRect newFrame = CGRectMake(margins.left, margins.top, self.superview.width - margins.left - margins. right, self.superview.height - margins.top - margins.bottom);
		self.frame = newFrame;
	}
}

- (CGPoint)boundsCenter
{
	CGRect frame = self.bounds;
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

- (void)centerVertically
{
	if (self.superview) {
		CGRect frame = self.frame;
		frame.origin.y = roundf((self.superview.height - self.height) / 2.f);
		self.frame = frame;
	}	
}

- (void)centerHorizontally
{
	if (self.superview) {
		CGRect frame = self.frame;
		frame.origin.x = roundf((self.superview.width - self.width) / 2.f);
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

- (CGPoint)anchorPoint
{
	return self.layer.anchorPoint;
}

- (void)setAnchorPoint:(CGPoint)anchorPoint
{
    CGPoint newPoint = CGPointMake(self.bounds.size.width * anchorPoint.x, self.bounds.size.height * anchorPoint.y);
    CGPoint oldPoint = CGPointMake(self.bounds.size.width * self.layer.anchorPoint.x, self.bounds.size.height * self.layer.anchorPoint.y);
	
    newPoint = CGPointApplyAffineTransform(newPoint, self.transform);
    oldPoint = CGPointApplyAffineTransform(oldPoint, self.transform);
	
    CGPoint position = self.layer.position;
	
    position.x -= oldPoint.x;
    position.x += newPoint.x;
	
    position.y -= oldPoint.y;
    position.y += newPoint.y;
	
    self.layer.position = position;
    self.layer.anchorPoint = anchorPoint;
}

- (void)setAutoresizingNone {
	[self setAutoresizingMask:UIViewAutoresizingNone];
}

- (void)setAutoresizingBottomLeft {
	[self setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin];
}

- (void)setAutoresizingBottomRight {
	[self setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin];
}

- (void)setAutoresizingTopLeft {
	[self setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin];
}

- (void)setAutoresizingTopRight {
	[self setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin];
}

- (void)setAutoresizingTopCenter {
	[self setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
}

- (void)setAutoresizingCenter {
	[self setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
}

- (void)setAutoresizingBottomCenter {
	[self setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
}

- (void)setAutoresizingWidthAndHeight {
	[self setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
}


- (CGFloat)baselinePosition {
	return CGRectGetMaxX(self.frame);
}

- (void)positionAtX:(CGFloat)xValue {
	CGRect frame = [self frame];
	frame.origin.x = roundf(xValue);
	[self setFrame:frame];
}

- (void)positionAtY:(CGFloat)yValue {
	CGRect frame = [self frame];
	frame.origin.y = roundf(yValue);
	[self setFrame:frame];
}

- (void)positionAtX:(CGFloat)xValue andY:(CGFloat)yValue withWidth:(CGFloat)width {
	CGRect frame = [self frame];
	frame.origin.x = roundf(xValue);
	frame.origin.y = roundf(yValue);
	frame.size.width = width;
	[self setFrame:frame];	
}

- (void)positionAtX:(CGFloat)xValue andY:(CGFloat)yValue withHeight:(CGFloat)height {
	CGRect frame = [self frame];
	frame.origin.x = roundf(xValue);
	frame.origin.y = roundf(yValue);
	frame.size.height = height;
	[self setFrame:frame];	
}

- (void)positionAtX:(CGFloat)xValue withHeight:(CGFloat)height {
	CGRect frame = [self frame];
	frame.origin.x = roundf(xValue);
	frame.size.height = height;
	[self setFrame:frame];	
}



@end
