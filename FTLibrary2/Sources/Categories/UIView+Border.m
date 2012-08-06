//
//  UIView+Border.m
//  FTLibrary2
//
//  Created by A.Papadakis on 02/08/2012.
//
//

#import "UIView+Border.h"
#import "UIView+Layout.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (Border)
- (void)setBorderWidth:(CGFloat)width andColor:(UIColor *)color andRadius:(CGFloat)rad ofType:(UIViewBorderType)type
{
#pragma mark TODO:Implement the rest
	if (type == UIViewBorderTypeNone)
		return;
	else if (type == UIViewBorderTypeAll)
	{
		[self.layer setBorderColor:color.CGColor];
		[self.layer setBorderWidth:width];
		[self.layer setCornerRadius:rad];
		return;
	}
	else
	{
		
		CAShapeLayer *_shapeLayer = [CAShapeLayer layer];
		
		//creating a path
		CGMutablePathRef path = CGPathCreateMutable();
		CGMutablePathRef path2;
		path2 = NULL;
		if (type == UIViewBorderTypeLeft)//left
		{
			CGPathMoveToPoint(path, NULL, 0, 0);
			CGPathAddLineToPoint(path, NULL, 0, self.height);
		}
		else if (type == UIViewBorderTypeRight)//right
		{
			CGPathMoveToPoint(path, NULL, self.width, 0);
			CGPathAddLineToPoint(path, NULL, self.width, self.height);
		}
		else if (type == UIViewBorderTypeTop)//top
		{
			CGPathMoveToPoint(path, NULL, 0, 0);
			CGPathAddLineToPoint(path, NULL, self.width, 0);
		}
		else if (type == UIViewBorderTypeBottom)//bottom
		{
			CGPathMoveToPoint(path, NULL, self.width, self.height);
			CGPathAddLineToPoint(path, NULL, 0, self.height);
		}
		else if (type == UIViewBorderTypeTopLeft)//top - left
		{
			CGPathMoveToPoint(path, NULL, self.width, 0);
			CGPathAddLineToPoint(path, NULL, 0, 0);
			CGPathAddLineToPoint(path, NULL, 0, self.height);
		}
		else if (type == UIViewBorderTypeTopRight)//top - right
		{
			CGPathMoveToPoint(path, NULL, 0, 0);
			CGPathAddLineToPoint(path, NULL, self.width, 0);
			CGPathAddLineToPoint(path, NULL, self.width, self.height);
		}
		else if (type == UIViewBorderTypeBottomLeft)// bottom-left
		{
			CGPathMoveToPoint(path, NULL, 0, 0);
			CGPathAddLineToPoint(path, NULL, 0, self.height);
			CGPathAddLineToPoint(path, NULL, self.width, self.height);
		}
		else if (type == UIViewBorderTypeBottomRight)
		{
			CGPathMoveToPoint(path, NULL, 0, self.height);
			CGPathAddLineToPoint(path, NULL, self.width, self.height);
			CGPathAddLineToPoint(path, NULL, self.width, 0);
		}
		else if (type == UIViewBorderTypeTopBottom)
		{
			CGPathMoveToPoint(path, NULL, 0, 0);
			CGPathAddLineToPoint(path, NULL, self.width, 0);
			path2 = CGPathCreateMutable();
			CGPathMoveToPoint(path2, NULL, self.width, self.height);
			CGPathAddLineToPoint(path2, NULL, 0, self.height);
			CGPathAddPath(path, NULL, path2);
		}
		else if (type == UIViewBorderTypeLeftRight)
		{
			
			CGPathMoveToPoint(path, NULL, 0, 0);
			CGPathAddLineToPoint(path, NULL, 0, self.height);
			path2 = CGPathCreateMutable();
			CGPathMoveToPoint(path2, NULL, self.width, 0);
			CGPathAddLineToPoint(path2, NULL, self.width, self.height);
			CGPathAddPath(path, NULL, path2);
		}
		
		[_shapeLayer setPath:path];
		if (path2 != NULL)
			CGPathRelease(path2);
		CGPathRelease(path);
		
		_shapeLayer.backgroundColor = [[UIColor clearColor] CGColor];
		_shapeLayer.masksToBounds = NO;
		[_shapeLayer setValue:[NSNumber numberWithBool:NO] forKey:@"isCircle"];
		_shapeLayer.fillColor = [[UIColor clearColor] CGColor];
		_shapeLayer.strokeColor = [color CGColor];
		_shapeLayer.lineWidth = width;
		_shapeLayer.lineCap = kCALineCapRound;
		[self.layer addSublayer:_shapeLayer];

		
	}    
    //_shapeLayer is added as a sublayer of the view, the border is visible
}
@end
