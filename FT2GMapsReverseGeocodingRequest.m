//
//  FT2GMapsReverseGeocoding.m
//  FTLibrary2
//
//  Created by Baldoph Pourprix on 15/04/2013.
//  Copyright (c) 2013 Fuerte International. All rights reserved.
//

#import "FT2GMapsReverseGeocodingRequest.h"

@implementation FT2GMapsReverseGeocodingRequest

- (NSString *)argumentsString
{
	NSMutableString *arguments = [NSMutableString new];
	NSAssert(CLLocationCoordinate2DIsValid(_coordinates), @"coordinates are not valid");
	
	[arguments appendFormat:@"latlng=%f,%f&sensor=true", _coordinates.latitude, _coordinates.longitude];
	
	return arguments;
}

@end
