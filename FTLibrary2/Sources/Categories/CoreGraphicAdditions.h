//
//  CoreGraphicAdditions.h
//  FTLibrary2
//
//  Created by Baldoph Pourprix on 02/01/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>

CG_INLINE CGRect
CGRectMakeWithCenter(CGFloat centerX, CGFloat centerY, CGFloat width, CGFloat height)
{
	CGRect rect;
	rect.origin.x = centerX - width / 2.0;
	rect.origin.y = centerY - height / 2.0;
	rect.size.width = width; rect.size.height = height;
	return rect;
}

CG_INLINE CGPoint
CGPointCenterOfRect(CGRect rect)
{
	CGPoint point;
	point.x = rect.origin.x + rect.size.width / 2.0;
	point.y = rect.origin.y + rect.size.height / 2.0;
	return point;
}

CG_INLINE CGRect
CGRectWithSize(CGSize size)
{
	CGRect rect;
	rect.origin = CGPointZero;
	rect.size = size;
	return rect;
}

CG_INLINE CGPoint
CGPointIntegral(CGPoint p)
{
	CGPoint point;
	point.x = round(p.x);
	point.y = round(p.y);
	return point;
}