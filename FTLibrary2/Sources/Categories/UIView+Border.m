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
#import <objc/runtime.h>
static const NSString *shapeLayers = @"UIView+Border-ShapeLayer-Dictionary";
static const NSString *borderStyle = @"UIView+Border-BorderStyle-NSNumber";
static const NSString *borderLayer = @"UIView+Border-BorderLayer-CAShapeLayer";

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
- (void)setBorderLayer:(CAShapeLayer *)shapeLayer
{
	objc_setAssociatedObject(self, &borderLayer, [CAShapeLayer layer], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CAShapeLayer *)borderLayer
{
	return objc_getAssociatedObject(self, &borderLayer);
}

- (void)setBorderStyle:(UIViewBorderStyle)style
{
	objc_setAssociatedObject(self, &borderStyle, [NSNumber numberWithInt:style], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIViewBorderStyle)borderStyle
{
	return [(NSNumber *)objc_getAssociatedObject(self, &borderStyle) intValue];
}

- (void)refreshBorder
{
	
}
- (void)setBorderWidth:(CGFloat)width andColor:(UIColor *)color andRadius:(CGFloat)rad ofType:(UIViewBorderType)type withStyle:(UIViewBorderStyle)style
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
			[self addBorderOfType:type toPath:path withStyle:style];
		}
		else if (type == UIViewBorderTypeTopLeft)//top - left
		{
			[self addBorderOfType:UIViewBorderTypeTop toPath:path withStyle:style];
			[self addBorderOfType:UIViewBorderTypeLeft toPath:path withStyle:style];
		}
		else if (type == UIViewBorderTypeTopRight)//top - right
		{
			[self addBorderOfType:UIViewBorderTypeTop toPath:path withStyle:style];
			[self addBorderOfType:UIViewBorderTypeRight toPath:path withStyle:style];
		}
		else if (type == UIViewBorderTypeBottomLeft)// bottom-left
		{
			[self addBorderOfType:UIViewBorderTypeBottom toPath:path withStyle:style];
			[self addBorderOfType:UIViewBorderTypeLeft toPath:path withStyle:style];
		}
		else if (type == UIViewBorderTypeBottomRight)
		{
			[self addBorderOfType:UIViewBorderTypeBottom toPath:path withStyle:style];
			[self addBorderOfType:UIViewBorderTypeRight toPath:path withStyle:style];
		}
		else if (type == UIViewBorderTypeTopBottom)
		{
			[self addBorderOfType:UIViewBorderTypeTop toPath:path withStyle:style];
			[self addBorderOfType:UIViewBorderTypeBottom toPath:path withStyle:style];
			
		}
		else if (type == UIViewBorderTypeLeftRight)
		{
			[self addBorderOfType:UIViewBorderTypeLeft toPath:path withStyle:style];
			[self addBorderOfType:UIViewBorderTypeRight toPath:path withStyle:style];
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
- (void)setBorderWidth:(CGFloat)width andColor:(UIColor *)color andRadius:(CGFloat)rad ofType:(UIViewBorderType)type
{
	[self setBorderWidth:width andColor:color andRadius:rad ofType:type withStyle:UIViewBorderStyleDefault];
}

- (void)addBorderOfType:(UIViewBorderType)type toPath:(CGMutablePathRef)path withStyle:(UIViewBorderStyle)style
{
	CGPoint startPoint = CGPointZero;
	CGPoint endPoint = CGPointZero;
	switch (type) {
		case UIViewBorderTypeLeft:
			startPoint = CGPointMake(0, 0);
			endPoint = CGPointMake(0, self.height);
			break;
		case UIViewBorderTypeRight:
			startPoint = CGPointMake(self.width, 0);
			endPoint = CGPointMake(self.width, self.height);
			break;
		case UIViewBorderTypeTop:
			startPoint = CGPointMake(0, 0);
			endPoint = CGPointMake(self.width, 0);
			break;
		case UIViewBorderTypeBottom:
			startPoint = CGPointMake(self.width, self.height);
			endPoint = CGPointMake(0, self.height);
			break;
		default:
			break;
	}
	
	CGMutablePathRef path2 = CGPathCreateMutable();

	switch (style) {
		case UIViewBorderStyleDefault:
		{
			CGPathMoveToPoint(path2, NULL, startPoint.x, startPoint.y);
			CGPathAddLineToPoint(path2, NULL, endPoint.x, endPoint.y);
		}
		break;
		default:
			break;
	}
	CGPathAddPath(path, NULL, path2);
	CGPathRelease(path2);
}
@end
