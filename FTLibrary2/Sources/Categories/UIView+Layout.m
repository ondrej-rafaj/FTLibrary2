//
//  UIView+Layout.m
//  FT2Library
//
//  Created by Simon Lee on 21/12/2009.
//  Copyright 2009 Fuerte International. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UIView+Layout.h"
#import <objc/runtime.h>

static char EDITED_FRAME;

@implementation UIView (Layout)

- (CGRect)actualFrame
{
	if (self.isEditingFrame) return self.editedFrame;
	else return self.frame;
}

- (void)setActualFrame:(CGRect)frame
{
	if (self.isEditingFrame) self.editedFrame = frame;
	else self.frame = frame;
}

- (BOOL)isEditingFrame
{
	return objc_getAssociatedObject(self, &EDITED_FRAME) != nil;
}

- (CGRect)editedFrame;
{
	NSString *string = objc_getAssociatedObject(self, &EDITED_FRAME);
	if (string) {
		return CGRectFromString(string);
	}
	return CGRectZero;
}

- (void)setEditedFrame:(CGRect)frame
{
	NSString *string = NSStringFromCGRect(frame);
	objc_setAssociatedObject(self, &EDITED_FRAME, string, OBJC_ASSOCIATION_RETAIN);
}

- (void)beginEditingFrame
{
	if (self.isEditingFrame) {
		NSLog(@"Already editing frame for view %@", self);
	} else {
		self.editedFrame = self.frame;
	}
}

- (void)endEditingFrame
{
	if (self.isEditingFrame) {
		if (!CGRectEqualToRect(self.frame, self.editedFrame)) self.frame = self.editedFrame;
		objc_setAssociatedObject(self, &EDITED_FRAME, nil, OBJC_ASSOCIATION_RETAIN);
	} else {
		NSLog(@"Wasn't editing frame for view: %@", self);
	}
}

- (void)addSubviews:(NSArray *)views
{
	[views enumerateObjectsUsingBlock:^(UIView *v, NSUInteger idx, BOOL *stop) { [self addSubview:v]; }];
}

- (void)setWidth:(CGFloat)width
{
	CGRect frame = self.actualFrame;
	frame.size.width = width;
	self.actualFrame = frame;
}

- (void)setHeight:(CGFloat)height
{
	CGRect frame = self.actualFrame;
	frame.size.height = height;
	self.actualFrame = frame;
}

- (void)setXOrigin:(CGFloat)xOrigin
{
	CGRect frame = self.actualFrame;
	frame.origin.x = xOrigin;
	self.actualFrame = frame;
}

- (void)setYOrigin:(CGFloat)yOrigin
{
	CGRect frame = self.actualFrame;
	frame.origin.y = yOrigin;
	self.actualFrame = frame;
}

- (void)setOrigin:(CGPoint)origin
{
	CGRect frame = self.actualFrame;
	frame.origin = origin;
	self.actualFrame = frame;
}

- (void)positionAtX:(CGFloat)xOrigin andY:(CGFloat)yOrigin
{
	CGRect frame = self.actualFrame;
	frame.origin.x = xOrigin;
	frame.origin.y = yOrigin;
	self.actualFrame = frame;
}

- (void)setSize:(CGSize)size
{
	CGRect frame = self.actualFrame;
	frame.size = size;
	self.actualFrame = frame;
}

- (void)setWidth:(CGFloat)width andHeight:(CGFloat)height
{
	CGRect frame = self.actualFrame;
	frame.size.height = height;
	frame.size.width = width;
	self.actualFrame = frame;
}

- (CGFloat)width
{
	return CGRectGetWidth(self.actualFrame);
}

- (CGFloat)height
{
	return CGRectGetHeight(self.actualFrame);
}

- (CGFloat)xOrigin
{
	return CGRectGetMinX(self.actualFrame);
}

- (CGFloat)yOrigin
{
	return CGRectGetMinY(self.actualFrame);
}

- (CGFloat)bottom
{
	return CGRectGetMaxY(self.actualFrame);
}

- (CGPoint)origin
{
	return self.actualFrame.origin;
}

- (CGSize)size
{
	return self.actualFrame.size;
}

- (void)setBottom:(CGFloat)bottom
{
	CGRect frame = self.actualFrame;
	frame.origin.y = bottom - frame.size.height;
	self.actualFrame = frame;
}

- (CGFloat)right
{
	return CGRectGetMaxX(self.actualFrame);
}

- (void)setRight:(CGFloat)right
{
	CGRect frame = self.actualFrame;
	frame.origin.x = right - frame.size.width;
	self.actualFrame = frame;
}

- (void)setMargins:(UIEdgeInsets)margins
{
	if (self.superview) {
		CGRect newFrame = CGRectMake(margins.left, margins.top, self.superview.width - margins.left - margins. right, self.superview.height - margins.top - margins.bottom);
		self.actualFrame = newFrame;
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
	CGRect frame = self.frame;
	self.frame = (CGRect) { CGPointMake(round(frame.origin.x), round(frame.origin.y)), frame.size };
}

//superview related
- (void)centerInSuperview
{
	if (self.superview) {
		CGRect frame = self.actualFrame;
		frame.origin.x = roundf((self.superview.width - self.width) / 2.f);
		frame.origin.y = roundf((self.superview.height - self.height) / 2.f);
		self.actualFrame = frame;
	}
}

- (void)centerVertically
{
	if (self.superview) {
		CGRect frame = self.actualFrame;
		frame.origin.y = roundf((self.superview.height - self.height) / 2.f);
		self.actualFrame = frame;
	}	
}

- (void)centerHorizontally
{
	if (self.superview) {
		CGRect frame = self.actualFrame;
		frame.origin.x = roundf((self.superview.width - self.width) / 2.f);
		self.actualFrame = frame;
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
		CGRect frame = self.actualFrame;
		frame.origin.y = self.superview.height - bottomMargin - self.height;
		self.actualFrame = frame;
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
		CGRect frame = self.actualFrame;
		frame.origin.x = self.superview.width - rightMargin - self.width;
		self.actualFrame = frame;
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
	return CGRectGetMaxX(self.actualFrame);
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
