//
//  FT2GMapsReverseGeocoding.h
//  FTLibrary2
//
//  Created by Baldoph Pourprix on 15/04/2013.
//  Copyright (c) 2013 Fuerte International. All rights reserved.
//

#import "FT2GMapsRequest.h"
#import <CoreLocation/CoreLocation.h>

@interface FT2GMapsReverseGeocodingRequest : FT2GMapsRequest

@property (nonatomic) CLLocationCoordinate2D coordinates;

@end
