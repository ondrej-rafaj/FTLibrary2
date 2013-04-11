//
//  FT2GMapsDirectionOutput.m
//  Mercedes Map Test
//
//  Created by Baldoph Pourprix on 10/04/2013.
//  Copyright (c) 2013 Fuerte Int. All rights reserved.
//

#import "FT2GMapsDirectionOutput.h"
#import "FT2GMapsRoute.h"

@interface FT2GMapsDirectionOutput ()

@property (nonatomic, readwrite) NSError *error;

@property (nonatomic, readwrite) FT2GMapsRoute *route; //return the first object of |routes|
@property (nonatomic, readwrite) NSArray *routes;

- (NSError *)_parseError:(NSDictionary *)dict;

@end

@implementation FT2GMapsDirectionOutput

#pragma mark - Object lifecycle

- (id)initWithDictionary:(NSDictionary *)dict
{
	self = [super init];
	if (self) {

		_error = [self _parseError:dict];
		
		NSMutableArray *routes = [NSMutableArray new];
		NSArray *routesArray = dict[@"routes"];
		[routesArray enumerateObjectsUsingBlock:^(NSDictionary *routeDict, NSUInteger idx, BOOL *stop) {
			FT2GMapsRoute *route = [[FT2GMapsRoute alloc] initWithDictionary:routeDict];
			[routes addObject:route];
		}];
		_routes = routes.copy;
	}
	return self;
}

#pragma mark - Getters

- (FT2GMapsRoute *)route
{
	return _routes.count > 0 ? _routes[0] : nil;
}

#pragma mark - Private

- (NSError *)_parseError:(NSDictionary *)dict
{
	if (dict[@"status"] && ![dict[@"status"] isEqualToString:@"OK"]) {
		NSString *status = dict[@"status"];
		NSInteger errorCode = FT2GMapsUnkownError;
		if ([status isEqualToString:@"NOT_FOUND"]) errorCode = FT2GMapsNotFound;
		else if ([status isEqualToString:@"ZERO_RESULTS"]) errorCode = FT2GMapsZeroResults;
		else if ([status isEqualToString:@"MAX_WAYPOINTS_EXCEEDED"]) errorCode = FT2GMapsMaxWaypointExceeded;
		else if ([status isEqualToString:@"INVALID_REQUEST"]) errorCode = FT2GMapsInvalideRequest;
		else if ([status isEqualToString:@"OVER_QUERY_LIMIT"]) errorCode = FT2GMapsOverQueryLimit;
		else if ([status isEqualToString:@"REQUEST_DENIED"]) errorCode = FT2GMapsRequestDenied;
		
		NSString *errorMessage = nil;
		switch (errorCode) {
			case FT2GMapsInvalideRequest:
				errorMessage = @"The provided request was invalid.";
				break;
			case FT2GMapsMaxWaypointExceeded:
				errorMessage = @"Too many waypoints were provided.";
				break;
			case FT2GMapsNotFound:
				errorMessage = @"One of the location couldn't be geocoded.";
				break;
			case FT2GMapsOverQueryLimit:
				errorMessage = @"The service cannot receive any more requests for now.";
				break;
			case FT2GMapsRequestDenied:
				errorMessage = @"The service denied the client request.";
				break;
			case FT2GMapsUnkownError:
				errorMessage = @"Unknown error.";
				break;
			case FT2GMapsZeroResults:
				errorMessage = @"No route could be found between the origin and destination";
				break;
		}
				
		NSError *error = [NSError errorWithDomain:@"com.fuerteint.gmaps"
											 code:errorCode
										 userInfo:@{ NSLocalizedDescriptionKey: @"Google Maps Direction error", NSLocalizedFailureReasonErrorKey: errorMessage}];
		return error;
	}
	return nil;
}

@end
