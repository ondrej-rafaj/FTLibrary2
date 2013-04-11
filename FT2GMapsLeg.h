//
//  FT2GMapsLeg.h
//  Mercedes Map Test
//
//  Created by Baldoph Pourprix on 10/04/2013.
//  Copyright (c) 2013 Fuerte Int. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FT2GMapsLocation;

@interface FT2GMapsLeg : NSObject

/** An array of FT2GMapsStep objects denoting information about each separate step of the leg of the journey. */
@property (nonatomic, readonly) NSArray *steps;

@property (nonatomic, readonly) NSString *distanceString;
@property (nonatomic, readonly) NSInteger distanceMeters;

@property (nonatomic, readonly) NSString *durationString;
@property (nonatomic, readonly) NSInteger durationSeconds;

@property (nonatomic, readonly) FT2GMapsLocation *startLocation;
@property (nonatomic, readonly) FT2GMapsLocation *endLocation;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
