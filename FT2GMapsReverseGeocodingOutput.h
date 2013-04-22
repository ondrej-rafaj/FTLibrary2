//
//  FT2GMapsReverseGeocodingOutput.h
//  FTLibrary2
//
//  Created by Baldoph Pourprix on 16/04/2013.
//  Copyright (c) 2013 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FT2GMapsLocation;

@interface FT2GMapsReverseGeocodingOutput : NSObject

- (id)initWithDictionary:(NSDictionary *)dict;

@property (nonatomic, readonly) FT2GMapsLocation *location;

@end
