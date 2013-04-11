//
//  FT2GMapsDirectionOutput.h
//  Mercedes Map Test
//
//  Created by Baldoph Pourprix on 10/04/2013.
//  Copyright (c) 2013 Fuerte Int. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Object representation of a GMapDirectionRequest response
 */

enum {
	FT2GMapsNotFound, //at least one of the locations specified in the requests's origin, destination, or waypoints could not be geocoded.
	FT2GMapsZeroResults, //no route could be found between the origin and destination.
	FT2GMapsMaxWaypointExceeded, //too many waypointss were provided in the request
	FT2GMapsInvalideRequest, //the provided request was invalid. Common causes of this status include an invalid parameter or parameter value.
	FT2GMapsOverQueryLimit, //the service has received too many requests from your application within the allowed time period.
	FT2GMapsRequestDenied, //the service denied use of the directions service by your application.
	FT2GMapsUnkownError // a directions request could not be processed due to a server error. The request may succeed if you try again.
};

@class FT2GMapsRoute;

@interface FT2GMapsDirectionOutput : NSObject

- (id)initWithDictionary:(NSDictionary *)dict;

@property (nonatomic, readonly) NSError *error;

@property (nonatomic, readonly) FT2GMapsRoute *route; //return the first object of |routes|
@property (nonatomic, readonly) NSArray *routes;

@end
