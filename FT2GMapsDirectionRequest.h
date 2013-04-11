//
//  FT2GMapDirectionRequest.h
//  Mercedes Map Test
//
//  Created by Baldoph Pourprix on 09/04/2013.
//  Copyright (c) 2013 Fuerte Int. All rights reserved.
//

#import "FT2GMapsRequest.h"
#import <CoreLocation/CoreLocation.h>

/* Not supported
 * • waypoints
 * • language
 */

typedef enum {
	FT2GMapDirectionModeDriving = 0,
	FT2GMapDirectionModeWalking,
	FT2GMapDirectionModeBicycling,
	FT2GMapDirectionModePublicTransport
} FT2GMapDirectionMode;

enum {
	FT2GMapDirectionAvoidTolls		= 1 << 0,
	FT2GMapDirectionAvoidHighway	= 2 << 0,
};
typedef NSUInteger FT2GMapDirectionAvoidOptions;

typedef enum {
	FT2GMapDirectionUnitDefault = 0, //take the default unit of the start location
	FT2GMapDirectionUnitMetric,
	FT2GMapDirectionUnitImperial
} FT2GMapDirectionUnit;

@class FT2GMapsLocation;

@interface FT2GMapsDirectionRequest : FT2GMapsRequest

- (id)initWithStart:(FT2GMapsLocation *)startLocation end:(FT2GMapsLocation *)endLocation;

+ (FT2GMapsDirectionRequest *)requestWithStart:(FT2GMapsLocation *)startLocation end:(FT2GMapsLocation *)endLocation;
+ (FT2GMapsDirectionRequest *)requestWithStartCoordinates:(CLLocationCoordinate2D)start endCoordinates:(CLLocationCoordinate2D)end;
+ (FT2GMapsDirectionRequest *)requestWithStartAddress:(NSString *)start endAddress:(NSString *)end;

@property (nonatomic) FT2GMapsLocation *startLocation;
@property (nonatomic) FT2GMapsLocation *endLocation;

@property (nonatomic) FT2GMapDirectionMode directionMode; //default to FT2GMapDirectionModeDriving
@property (nonatomic) FT2GMapDirectionAvoidOptions avoidOptions; //bitmask
@property (nonatomic) FT2GMapDirectionUnit unit;
@property (nonatomic) NSString *region; //specified as ccTLD 2-character value. Default is nil

@property (nonatomic) NSDate *departureDate;
@property (nonatomic) NSDate *arrivalDate;

@end
