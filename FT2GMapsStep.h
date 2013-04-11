//
//  FT2GMapsStep.h
//  Mercedes Map Test
//
//  Created by Baldoph Pourprix on 10/04/2013.
//  Copyright (c) 2013 Fuerte Int. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface FT2GMapsStep : NSObject

@property (nonatomic, readonly) NSString *HTMLInstructions;
@property (nonatomic, readonly) NSString *distanceString;
@property (nonatomic, readonly) NSInteger distanceMeters;
@property (nonatomic, readonly) NSString *durationString;
@property (nonatomic, readonly) NSInteger durationSeconds;
@property (nonatomic, readonly) CLLocationCoordinate2D startCoordinates;
@property (nonatomic, readonly) CLLocationCoordinate2D endCoordinates;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
