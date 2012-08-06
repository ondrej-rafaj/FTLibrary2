//
//  UIView+Border.h
//  FTLibrary2
//
//  Created by A.Papadakis on 02/08/2012.
//
//

#import <UIKit/UIKit.h>
typedef enum
{
	UIViewBorderTypeAll,
	UIViewBorderTypeNone,
	UIViewBorderTypeLeft,
	UIViewBorderTypeTop,
	UIViewBorderTypeRight,
	UIViewBorderTypeBottom,
	UIViewBorderTypeBottomLeft,
	UIViewBorderTypeBottomRight,
	UIViewBorderTypeTopLeft,
	UIViewBorderTypeTopRight,
	UIViewBorderTypeTopBottom,
	UIViewBorderTypeLeftRight,
}UIViewBorderType;
@interface UIView (Border)
- (void)setBorderWidth:(CGFloat)width andColor:(UIColor *)color andRadius:(CGFloat)rad ofType:(UIViewBorderType)type;

@end
