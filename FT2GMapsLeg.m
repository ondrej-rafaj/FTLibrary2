//
//  FT2GMapsLeg.m
//  Mercedes Map Test
//
//  Created by Baldoph Pourprix on 10/04/2013.
//  Copyright (c) 2013 Fuerte Int. All rights reserved.
//

#import "FT2GMapsLeg.h"
#import "FT2GMapsLocation.h"
#import "FT2GMapsHelper.h"
#import "FT2GMapsStep.h"

@implementation FT2GMapsLeg

- (id)initWithDictionary:(NSDictionary *)dict
{
	self = [super init];
	if (self) {
		_distanceString = dict[@"distance"][@"text"];
		_distanceMeters = [dict[@"distance"][@"value"] integerValue];
		
		_durationString = dict[@"duration"][@"text"];
		_durationSeconds = [dict[@"duration"][@"value"] integerValue];
		
		_startLocation = [[FT2GMapsLocation alloc] init];
		_startLocation.address = dict[@"start_address"];
		_startLocation.coordinates = coordinatesForDictionary(dict[@"start_location"]);
		
		_endLocation = [[FT2GMapsLocation alloc] init];
		_endLocation.address = dict[@"end_address"];
		_endLocation.coordinates = coordinatesForDictionary(dict[@"end_location"]);
		
		NSMutableArray *steps = [NSMutableArray new];
		NSArray *stepsArray = dict[@"steps"];
		[stepsArray enumerateObjectsUsingBlock:^(NSDictionary *stepDict, NSUInteger idx, BOOL *stop) {
			FT2GMapsStep *step = [[FT2GMapsStep alloc] initWithDictionary:stepDict];
			[steps addObject:step];
		}];
		_steps = steps.copy;
	}
	return self;
}

@end
