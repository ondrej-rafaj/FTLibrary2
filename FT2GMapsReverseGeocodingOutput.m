//
//  FT2GMapsReverseGeocodingOutput.m
//  FTLibrary2
//
//  Created by Baldoph Pourprix on 16/04/2013.
//  Copyright (c) 2013 Fuerte International. All rights reserved.
//

#import "FT2GMapsReverseGeocodingOutput.h"
#import "FT2GMapsLocation.h"
#import "FT2GMapsHelper.h"

@implementation FT2GMapsReverseGeocodingOutput

- (id)initWithDictionary:(NSDictionary *)dict
{
	self = [super init];
	if (self) {
		NSDictionary *mostSpecificResult = dict[@"results"][0];
		
		FT2GMapsLocation *location = [[FT2GMapsLocation alloc] init];
		location.address = mostSpecificResult[@"formatted_address"];
		location.coordinates = coordinatesForDictionary(dict[@"geometry"][@"location"]);

		NSArray *addressComponents = mostSpecificResult[@"address_components"];
		
		[addressComponents enumerateObjectsUsingBlock:^(NSDictionary *component, NSUInteger idx, BOOL *stop) {
			
			NSArray *type = component[@"types"];
			if ([type containsObject:@"street_number"]) {
				location.streetNumber = component[@"long_name"];
			} else if ([type containsObject:@"routes"]) {
				location.streetName = component[@"long_name"];
			} else if ([type containsObject:@"locality"]) {
				location.city = component[@"long_name"];
			} else if ([type containsObject:@"country"]) {
				location.country = component[@"long_name"];
			} else if ([type containsObject:@"postal_code"]) {
				location.postalCode = component[@"long_name"];
			}
		}];
		
		_location = location;
	}
	return self;
}

@end
