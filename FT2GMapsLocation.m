//
//  FT2GMapLocationInput.m
//  Mercedes Map Test
//
//  Created by Baldoph Pourprix on 09/04/2013.
//  Copyright (c) 2013 Fuerte Int. All rights reserved.
//

#import "FT2GMapsLocation.h"

@implementation FT2GMapsLocation

- (id)init
{
	self = [super init];
	if (self) {
		_coordinates = kCLLocationCoordinate2DInvalid;
	}
	return self;
}

- (NSString *)locationArgumentString
{
	if (CLLocationCoordinate2DIsValid(_coordinates)) {
		return [NSString stringWithFormat:@"%f,%f", _coordinates.latitude, _coordinates.longitude];
	} else {
		return _address;
	}
}

@end
