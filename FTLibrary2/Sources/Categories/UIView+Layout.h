//
//  UIView+Layout.h
//  FT2Library
//
//  Created by Simon Lee on 21/12/2009.
//  Copyright 2009 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface UIView (Layout)

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
- (void)positionAtX:(CGFloat)xOrigin andY:(CGFloat)yOrigin;

- (CGSize)size;
- (void)setSize:(CGSize)size;
- (void)setWidth:(CGFloat)width andHeight:(CGFloat)height;

- (CGFloat)bottom;
- (void)setBottom:(CGFloat)bottom;

- (CGFloat)right;
- (void)setRight:(CGFloat)right;

- (CGPoint)boundsCenter;

- (void)setCenterIntegral:(CGPoint)center;

//superview related

- (void)centerInSuperview;
- (void)centerVertically;
- (void)centerHorizontally;

- (CGFloat)bottomMargin;
- (void)setBottomMargin:(CGFloat)bottomMargin;
- (CGFloat)rightMargin;
- (void)setRightMargin:(CGFloat)rightMargin;

- (void)setAutoresizingNone;
- (void)setAutoresizingBottomLeft;
- (void)setAutoresizingBottomRight;
- (void)setAutoresizingTopLeft;
- (void)setAutoresizingTopRight;
- (void)setAutoresizingTopCenter;
- (void)setAutoresizingCenter;
- (void)setAutoresizingBottomCenter;
- (void)setAutoresizingWidthAndHeight;


- (CGFloat)baselinePosition;

- (void)positionAtX:(CGFloat)xValue;
- (void)positionAtY:(CGFloat)yValue;
- (void)positionAtX:(CGFloat)xValue andY:(CGFloat)yValue;

- (void)positionAtX:(CGFloat)xValue andY:(CGFloat)yValue withWidth:(CGFloat)width;
- (void)positionAtX:(CGFloat)xValue andY:(CGFloat)yValue withHeight:(CGFloat)height;

- (void)positionAtX:(CGFloat)xValue withHeight:(CGFloat)height;





@end
