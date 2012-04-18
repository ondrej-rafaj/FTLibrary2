//
//  CGAffineTransformAdditions.h
//  FT2Library
//
//  Created by Baldoph Pourprix on 02/04/2012.
//  Copyright (c) 2012 Fuerte International. All rights reserved.
//

#ifndef __MCP_AFFINE_TRANSFORM_ADDITIONS__
#define __MCP_AFFINE_TRANSFORM_ADDITIONS__

#import <CoreGraphics/CoreGraphics.h>

#ifdef __cplusplus
extern "C" {
#endif
	
#define degreesToRadian(x) (M_PI * x / 180.0)
#define radiansToDegrees(x) (180.0 * x / M_PI)
	
	static inline CGAffineTransform CGAffineTransformMakeShear(CGFloat shearX, CGFloat shearY)
	{
		return CGAffineTransformMake(1.f, shearY, shearX, 1.f, 0.f, 0.f);
	}
	static inline CGAffineTransform CGAffineTransformShear(CGAffineTransform transform, CGFloat shearX, CGFloat shearY)
	{
		CGAffineTransform sheared = CGAffineTransformMakeShear(shearX, shearY);
		return CGAffineTransformConcat(transform, sheared);
	}
	static inline CGFloat CGAffineTransformGetDeltaX(CGAffineTransform transform) {return transform.tx;};
	static inline CGFloat CGAffineTransformGetDeltaY(CGAffineTransform transform) {return transform.ty;};
	static inline CGFloat CGAffineTransformGetScaleX(CGAffineTransform transform) {return sqrtf( (transform.a * transform.a) + (transform.c * transform.c) );};
	static inline CGFloat CGAffineTransformGetScaleY(CGAffineTransform transform) {return sqrtf( (transform.b * transform.b) + (transform.d * transform.d) );};
	static inline CGFloat CGAffineTransformGetShearX(CGAffineTransform transform) {return transform.b;};
	static inline CGFloat CGAffineTransformGetShearY(CGAffineTransform transform) {return transform.c;};
	static inline CGFloat CGPointAngleBetweenPoints(CGPoint first, CGPoint second) 
	{
		CGFloat dy = second.y - first.y;
		CGFloat dx = second.x - first.x;
		return atan2f(dy, dx);
	}
	static inline CGFloat CGAffineTransformGetRotation(CGAffineTransform transform)
	{
		// No exact way to get rotation out without knowing order of all previous operations
		// So, we'll cheat. We'll apply the transformation to two points and then determine the
		// angle betwen those two points
		
		CGPoint testPoint1 = CGPointMake(-100.f, 0.f);
		CGPoint testPoint2 = CGPointMake(100.f, 0.f);
		CGPoint transformed1 = CGPointApplyAffineTransform(testPoint1, transform);
		CGPoint transformed2 = CGPointApplyAffineTransform(testPoint2, transform);
		return CGPointAngleBetweenPoints(transformed1, transformed2);
	}
    
#ifdef __cplusplus
}
#endif

#endif