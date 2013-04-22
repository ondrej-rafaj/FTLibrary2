//
//  FT2GMapDirectionRequest.m
//  Mercedes Map Test
//
//  Created by Baldoph Pourprix on 09/04/2013.
//  Copyright (c) 2013 Fuerte Int. All rights reserved.
//

#import "FT2GMapsDirectionRequest.h"
#import "FT2GMapsLocation.h"

@implementation FT2GMapsDirectionRequest

- (id)init
{
	self = [super init];
	if (self) {
		_directionMode = FT2GMapDirectionModeDriving;
		_avoidOptions = 0;
		_unit = FT2GMapDirectionUnitDefault;
	}
	return self;
}

- (id)initWithStart:(FT2GMapsLocation *)startLocation end:(FT2GMapsLocation *)endLocation
{
	self = [self init];
	if (self) {
		_startLocation = startLocation;
		_endLocation = endLocation;
	}
	return self;
}

+ (FT2GMapsDirectionRequest *)requestWithStart:(FT2GMapsLocation *)startLocation end:(FT2GMapsLocation *)endLocation
{
	FT2GMapsDirectionRequest *request = [[FT2GMapsDirectionRequest alloc] initWithStart:startLocation
																				  end:endLocation];
	return request;
}

+ (FT2GMapsDirectionRequest *)requestWithStartCoordinates:(CLLocationCoordinate2D)start endCoordinates:(CLLocationCoordinate2D)end
{
	FT2GMapsLocation *startLocation = [[FT2GMapsLocation alloc] init];
	startLocation.coordinates = start;
	FT2GMapsLocation *endLocation = [[FT2GMapsLocation alloc] init];
	endLocation.coordinates = end;
	return [FT2GMapsDirectionRequest requestWithStart:startLocation end:endLocation];
}

+ (FT2GMapsDirectionRequest *)requestWithStartAddress:(NSString *)start endAddress:(NSString *)end
{
	FT2GMapsLocation *startLocation = [[FT2GMapsLocation alloc] init];
	startLocation.address = start;
	FT2GMapsLocation *endLocation = [[FT2GMapsLocation alloc] init];
	endLocation.address = end;
	return [FT2GMapsDirectionRequest requestWithStart:startLocation end:endLocation];
}

- (NSString *)argumentsString
{
	NSMutableString *arguments = [NSMutableString new];
	NSAssert(_startLocation.locationArgumentString && _endLocation.locationArgumentString, @"Required parameter are missing");
	NSAssert(_directionMode != FT2GMapDirectionModePublicTransport || (_departureDate != nil || _arrivalDate != nil), @"You must set a departure or arrival date when requesting public transport directions");

	[arguments appendFormat:@"origin=%@&destination=%@&sensor=true", _startLocation.locationArgumentString, _endLocation.locationArgumentString];
	
	switch (_directionMode) {
		case FT2GMapDirectionModeWalking:
			[arguments appendFormat:@"&mode=walking"];
			break;
		case FT2GMapDirectionModeBicycling:
			[arguments appendFormat:@"&mode=bicycling"];
			break;
		case FT2GMapDirectionModePublicTransport:
			[arguments appendFormat:@"&mode=transit"];			
			break;
		default:
			//driving is the default
			break;
	}
	
	if (_avoidOptions) {
		NSMutableString *avoidOptions = [NSMutableString new];
		if (_avoidOptions & FT2GMapDirectionAvoidHighway) [avoidOptions appendString:@"highways"];
		if (_avoidOptions & FT2GMapDirectionAvoidTolls) {
			if (avoidOptions.length > 0) [avoidOptions appendString:@"|"];
			[avoidOptions appendString:@"tolls"];
		}
		if (avoidOptions.length > 0) [arguments appendFormat:@"&avoid=%@", avoidOptions];
	}

	switch (_unit) {
		case FT2GMapDirectionUnitImperial:
			[arguments appendFormat:@"&units=imperial"];
			break;
		case FT2GMapDirectionUnitMetric:
			[arguments appendFormat:@"&units=metric"];
			break;
		default:
			break;
	}
	
	if (_region.length > 0) {
		[arguments appendFormat:@"&departure_time=%@", _region];
	}
	
	if (_departureDate) {
		[arguments appendFormat:@"&departure_time=%.0f", [_departureDate timeIntervalSince1970]];
	} else if (_arrivalDate) {
		[arguments appendFormat:@"&arrival_time=%.0f", [_arrivalDate timeIntervalSince1970]];
	}
	
	return arguments;
}

@end
