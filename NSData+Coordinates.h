//
//  NSData+Coordinates.h
//  Mercedes
//
//  Created by Baldoph Pourprix on 30/04/2013.
//  Copyright (c) 2013 Fuerte Int. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface NSData (Coordinates)

+ (NSData *)dataWithCoordinates:(CLLocationCoordinate2D)coordinates;
- (CLLocationCoordinate2D)coordinatesFromData;

@end
