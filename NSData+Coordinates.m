//
//  NSData+Coordinates.m
//  Mercedes
//
//  Created by Baldoph Pourprix on 30/04/2013.
//  Copyright (c) 2013 Fuerte Int. All rights reserved.
//

#import "NSData+Coordinates.h"

@implementation NSData (Coordinates)

+ (NSData *)dataWithCoordinates:(CLLocationCoordinate2D)coordinates
{
	return [NSData dataWithBytes:&coordinates length:sizeof(coordinates)];
}

- (CLLocationCoordinate2D)coordinatesFromData
{
	CLLocationCoordinate2D coordinates;
	[self getBytes:&coordinates length:sizeof(coordinates)];
	return coordinates;
}

@end
