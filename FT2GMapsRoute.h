//
//  FT2GMapRoute.h
//  Mercedes Map Test
//
//  Created by Baldoph Pourprix on 10/04/2013.
//  Copyright (c) 2013 Fuerte Int. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/**
 * Represent a route returned by the Direction API as an Obj-C object.
 */

@class FT2GMapsLeg;
@class GMSPath;
@class GMSCoordinateBounds;

@interface FT2GMapsRoute : NSObject {
	
	GMSPath *_path;
	GMSCoordinateBounds *_bounds;
}

- (id)initWithDictionary:(NSDictionary *)dict;

/** A short textual description for the route, suitable for naming and disambiguating the route from alternatives. */
@property (nonatomic, readonly) NSString *summary;

/** The copyrights text to be displayed for this route. */
@property (nonatomic, readonly) NSString *copyrights;

@property (nonatomic, readonly) CLLocationCoordinate2D northEastBound;

@property (nonatomic, readonly) CLLocationCoordinate2D southWestBound;

@property (nonatomic, readonly) FT2GMapsLeg *leg; // the first leg of the |legs| array

/** An array which contains information about a leg of the route, between two locations within the given route. A separate leg will be
 present for each waypoint or destination specified. (A route with no waypoints will contain exactly one leg within the legs array.) */
@property (nonatomic, readonly) NSArray *legs;

/** An array indicating the order of any waypoints in the calculated route. This waypoints may be reordered if the request was passed
 optimize:true within its waypoints parameter. */
@property (nonatomic, readonly) NSArray *waypointOrder;

/** An array of warnings to be displayed when showing these directions. */
@property (nonatomic, readonly) NSArray *warnings;

/** An array of CLLocation objects that form a smooth polyline of the route */
@property (nonatomic, readonly) NSArray *polylineLocations;

@property (nonatomic) NSString *overviewPolylineEncoded;

@end
