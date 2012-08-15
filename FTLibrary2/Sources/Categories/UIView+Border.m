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
//#import <objc/runtime.h>
static const NSString *shapeLayers = @"UIView+Border-ShapeLayer-Dictionary";
@interface UIView (BorderPrivate)

@end
@implementation UIView (Border)
#pragma mark - 
#pragma mark Category Getters/Setters
//- (void)setShapeLayers:(NSMutableDictionary *)shapeLayersDict
//{
//	objc_setAssociatedObject(self, &shapeLayers, shapeLayersDict
//							 , OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//- (NSMutableDictionary *)shapeLayers
//{
//	return objc_getAssociatedObject(self, &shapeLayers);
//}
//
//- (void)startBorder
//{
//	[self setShapeLayers:[[NSMutableDictionary alloc]init]];
//	
//}

- (void)setBorderWidth:(CGFloat)width andColor:(UIColor *)color andRadius:(CGFloat)rad ofType:(UIViewBorderType)type
{
#pragma mark TODO:Implement the rest
	if (type == UIViewBorderTypeNone)
	{
		self.layer.borderColor = [UIColor clearColor].CGColor;
		self.layer.borderWidth = 0.0f;
		self.layer.cornerRadius = 0.0f;
		return;
	}
		
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
		if (type >= UIViewBorderTypeLeft && type <= UIViewBorderTypeBottom)//Left Right Top Bottom
		{
			[self addBorderOfType:type toPath:path];
		}
		else if (type == UIViewBorderTypeTopLeft)//top - left
		{
			[self addBorderOfType:UIViewBorderTypeTop toPath:path];
			[self addBorderOfType:UIViewBorderTypeLeft toPath:path];
		}
		else if (type == UIViewBorderTypeTopRight)//top - right
		{
			[self addBorderOfType:UIViewBorderTypeTop toPath:path];
			[self addBorderOfType:UIViewBorderTypeRight toPath:path];
		}
		else if (type == UIViewBorderTypeBottomLeft)// bottom-left
		{
			[self addBorderOfType:UIViewBorderTypeBottom toPath:path];
			[self addBorderOfType:UIViewBorderTypeLeft toPath:path];
		}
		else if (type == UIViewBorderTypeBottomRight)
		{
			[self addBorderOfType:UIViewBorderTypeBottom toPath:path];
			[self addBorderOfType:UIViewBorderTypeRight toPath:path];
		}
		else if (type == UIViewBorderTypeTopBottom)
		{
			[self addBorderOfType:UIViewBorderTypeTop toPath:path];
			[self addBorderOfType:UIViewBorderTypeBottom toPath:path];

		}
		else if (type == UIViewBorderTypeLeftRight)
		{
			[self addBorderOfType:UIViewBorderTypeLeft toPath:path];
			[self addBorderOfType:UIViewBorderTypeRight toPath:path];
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

- (void)addBorderOfType:(UIViewBorderType)type toPath:(CGMutablePathRef)path
{
	CGMutablePathRef path2 = CGPathCreateMutable();
	if (type == UIViewBorderTypeLeft)//left
	{
		CGPathMoveToPoint(path2, NULL, 0, 0);
		CGPathAddLineToPoint(path2, NULL, 0, self.height);
	}
	else if (type == UIViewBorderTypeRight)//right
	{
		CGPathMoveToPoint(path2, NULL, self.width, 0);
		CGPathAddLineToPoint(path2, NULL, self.width, self.height);
	}
	else if (type == UIViewBorderTypeTop)//top
	{
		CGPathMoveToPoint(path2, NULL, 0, 0);
		CGPathAddLineToPoint(path2, NULL, self.width, 0);
	}
	else if (type == UIViewBorderTypeBottom)//bottom
	{
		CGPathMoveToPoint(path2, NULL, self.width, self.height);
		CGPathAddLineToPoint(path2, NULL, 0, self.height);
	}
	CGPathAddPath(path, NULL, path2);
	CGPathRelease(path2);

}

@end
