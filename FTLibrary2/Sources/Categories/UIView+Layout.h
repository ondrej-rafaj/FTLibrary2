//
//  UIView+Layout.h
//  FT2Library
//
//  Created by Simon Lee on 21/12/2009.
//  Copyright 2009 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define UIViewAutoresizingFlexibleAllMargins UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin

#define UIViewAutoresizingFlexibleVerticalMargins UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin

#define UIViewAutoresizingFlexibleHorizontalMargins UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin

@interface UIView (Layout)

- (void)addSubviews:(NSArray *)views;

- (CGFloat)width;
- (void)setWidth:(CGFloat)width;

- (CGFloat)height;
- (void)setHeight:(CGFloat)height;

- (CGFloat)xOrigin;
- (void)setXOrigin:(CGFloat)xOrigin;

- (CGFloat)yOrigin;
- (void)setYOrigin:(CGFloat)yOrigin;

- (CGPoint)origin;
- (void)setOrigin:(CGPoint)origin;

- (CGSize)size;
- (void)setSize:(CGSize)size;
- (void)setWidth:(CGFloat)width andHeight:(CGFloat)height;

- (CGFloat)bottom;
- (void)setBottom:(CGFloat)bottom;

- (CGFloat)right;
- (void)setRight:(CGFloat)right;

//returns the center of the view in the view's coordinates system
- (CGPoint)boundsCenter;

- (void)setCenterIntegral:(CGPoint)center;

//set the anchorPoint without moving the view
- (void)setAnchorPoint:(CGPoint)anchorPoint;
- (CGPoint)anchorPoint;

//superview related

- (void)centerInSuperview;
- (void)centerVertically;
- (void)centerHorizontally;

- (CGFloat)bottomMargin;
- (void)setBottomMargin:(CGFloat)bottomMargin;
- (CGFloat)rightMargin;
- (void)setRightMargin:(CGFloat)rightMargin;

//autoresizing

- (void)setAutoresizingNone;
- (void)setAutoresizingBottomLeft;
- (void)setAutoresizingBottomRight;
- (void)setAutoresizingTopLeft;
- (void)setAutoresizingTopRight;
- (void)setAutoresizingTopCenter;
- (void)setAutoresizingCenter;
- (void)setAutoresizingBottomCenter;
- (void)setAutoresizingWidthAndHeight;


// DON'T ANYONE DARE CHANGING THE DEPRECATIONS BELOW
// CHANGE YOUR CODE INSTEAD
// THE RIGHT METHODS TO USE ARE ABOVE BECAUSE WE CAN USE THE OBJECTIVE-C 2.0 DOT SYNTAX WITH THEM
// AND WE DON'T WANT DUPLICATE METHODS THAT DO THE SAME THINGS

- (CGFloat)baselinePosition __deprecated; //use -bottom method instead

- (void)positionAtX:(CGFloat)xValue __deprecated; //use -setXOrigin: instead
- (void)positionAtY:(CGFloat)yValue __deprecated; //use -setYOrigin: instead
- (void)positionAtX:(CGFloat)xValue andY:(CGFloat)yValue __deprecated; //use -positionAtX:andY: instead

- (void)positionAtX:(CGFloat)xValue andY:(CGFloat)yValue withWidth:(CGFloat)width __deprecated; //cos it's useless?
- (void)positionAtX:(CGFloat)xValue andY:(CGFloat)yValue withHeight:(CGFloat)height __deprecated; //same

- (void)positionAtX:(CGFloat)xValue withHeight:(CGFloat)height __deprecated; //same

@end
