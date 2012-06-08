//
//  UILabel+DynamicHeight.h
//
//  Created by Simon Lee on 22/10/2009.
//  Copyright 2009 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface UILabel (DynamicHeight)

+ (double) getSizeWithText:(NSString *)text andWidth:(double)width forFont:(UIFont *)font;
- (double) setText:(NSString *)text withWidth:(double)width;
- (void) setTextAndShrink:(NSString *)text;
- (void) alignTop;
- (void) alignBottom;

- (void)fitToSuggestedHeight;

@end
