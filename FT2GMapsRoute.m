//
//  FT2GMapRoute.m
//  Mercedes Map Test
//
//  Created by Baldoph Pourprix on 10/04/2013.
//  Copyright (c) 2013 Fuerte Int. All rights reserved.
//

#import "FT2GMapsRoute.h"
#import "FT2GMapsHelper.h"
#import "FT2GMapsLeg.h"

@class GMSPath;
@class GMSCoordinateBounds;

@interface FT2GMapsRoute ()

@property (nonatomic, readwrite) NSArray *polylineLocations;

@end

@implementation FT2GMapsRoute

- (id)initWithDictionary:(NSDictionary *)dict
{
	self = [super init];
	if (self) {
		
		_summary = dict[@"summary"];
		_copyrights = dict[@"copyrights"];
		_waypointOrder = dict[@"waypoint_order"];
		_northEastBound = coordinatesForDictionary(dict[@"bounds"][@"northeast"]);
		_southWestBound = coordinatesForDictionary(dict[@"bounds"][@"southwest"]);
		_warnings = dict[@"warnings"];
		_overviewPolylineEncoded = dict[@"overview_polyline"][@"points"];
		
		NSMutableArray *legs = [NSMutableArray new];
		NSArray *legsArray = dict[@"legs"];
		[legsArray enumerateObjectsUsingBlock:^(NSDictionary *legDict, NSUInteger idx, BOOL *stop) {
			FT2GMapsLeg *leg = [[FT2GMapsLeg alloc] initWithDictionary:legDict];
			[legs addObject:leg];
		}];
		_legs = legs.copy;
	}
	return self;
}

- (FT2GMapsLeg *)leg
{
	return _legs.count > 0 ? _legs[0] : nil;
}

- (NSArray *)polylineLocations
{
	if (_polylineLocations == nil) {
		_polylineLocations = [FT2GMapsHelper decodePolyline:_overviewPolylineEncoded];
	}
	return _polylineLocations;
}

@end
