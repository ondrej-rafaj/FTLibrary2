//
//  FT2GMapsStep.m
//  Mercedes Map Test
//
//  Created by Baldoph Pourprix on 10/04/2013.
//  Copyright (c) 2013 Fuerte Int. All rights reserved.
//

#import "FT2GMapsStep.h"
#import "FT2GMapsHelper.h"

@implementation FT2GMapsStep

- (id)initWithDictionary:(NSDictionary *)dict
{
	self = [super init];
	if (self) {
		_HTMLInstructions = dict[@"html_instructions"];
		_distanceString = dict[@"distance"][@"text"];
		_distanceMeters = [dict[@"distance"][@"value"] integerValue];
		_durationString = dict[@"duration"][@"text"];
		_durationSeconds = [dict[@"duration"][@"value"] integerValue];
		_startCoordinates = coordinatesForDictionary(dict[@"start_location"]);
		_endCoordinates = coordinatesForDictionary(dict[@"end_location"]);
	}
	return self;
}

@end
