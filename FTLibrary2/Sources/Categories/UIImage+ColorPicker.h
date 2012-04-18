//
//  NSObject+UIImage_ColorPicker.h
//  FT2Library
//
//  Created by Francesco on 16/12/2011.
//  Copyright (c) 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImage (ColorPicker)

- (UIColor *)colorAtPoint:(CGPoint)point;
- (float)alphaAtPoint:(CGPoint)point;

+ (UIColor *)colorFromImage:(UIImage *)image atPoint:(CGPoint)point;
+ (float)alphaFromImage:(UIImage *)image atPoint:(CGPoint)point;

@end
