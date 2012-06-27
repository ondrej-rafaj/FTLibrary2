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

@end
