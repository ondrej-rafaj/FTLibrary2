//
//  FT2GMapLocationInput.h
//  Mercedes Map Test
//
//  Created by Baldoph Pourprix on 09/04/2013.
//  Copyright (c) 2013 Fuerte Int. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/**
 * Represents a location that is going to be used for input and output of the googlemaps api
 */

@interface FT2GMapsLocation : NSObject

@property (nonatomic) CLLocationCoordinate2D coordinates;

/**
 * Describe the place. It can be a post code, address, anything you would type in the Google Maps search field
 */
@property (nonatomic) NSString *address;

- (NSString *)locationString;

@end
