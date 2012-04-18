//
//  UIImage+Tint.h
//  FT2Library
//
//  Created by Simon Lee on 15/08/2009.
//  Copyright 2009 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface UIImage (Tint)

- (UIImage *) tintWithColor:(UIColor *)color andMask:(UIImage *)imageMask;

@end
