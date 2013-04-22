//
//  FT2GoogleMapsServicesManager.h
//  Mercedes Map Test
//
//  Created by Baldoph Pourprix on 09/04/2013.
//  Copyright (c) 2013 Fuerte Int. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FT2GMapsDirectionRequest;
@class FT2GMapsDirectionOutput;
@class FT2GMapsReverseGeocodingRequest;
@class FT2GMapsReverseGeocodingOutput;

enum {
	FT2GMapsNotFound, //at least one of the locations specified in the requests's origin, destination, or waypoints could not be geocoded.
	FT2GMapsZeroResults, //no route could be found between the origin and destination.
	FT2GMapsMaxWaypointExceeded, //too many waypoints were provided in the request
	FT2GMapsInvalideRequest, //the provided request was invalid. Common causes of this status include an invalid parameter or parameter value.
	FT2GMapsOverQueryLimit, //the service has received too many requests from your application within the allowed time period.
	FT2GMapsRequestDenied, //the service denied use of the directions service by your application.
	FT2GMapsUnkownError // a directions request could not be processed due to a server error. The request may succeed if you try again.
};

@interface FT2GMapsServices : NSObject

/**
 @return An opaque object that you pass as the argument to cancelRequest: to stop the request.
 */
- (id)executeDirectionRequest:(FT2GMapsDirectionRequest *)request
				   completion:(void (^)(FT2GMapsDirectionOutput *directionOutput, NSError *error))completionBlock;

- (id)executeReverseGeocodingRequest:(FT2GMapsReverseGeocodingRequest *)request
						  completion:(void (^)(FT2GMapsReverseGeocodingOutput *reverseGeocodingOutput, NSError *error))completionBlock;

- (void)cancelRequest:(id)object;


@end
