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

@class FT2GMapsRoute;

@interface FT2GMapsDirectionOutput : NSObject

- (id)initWithDictionary:(NSDictionary *)dict;

@property (nonatomic, readonly) FT2GMapsRoute *route; //return the first object of |routes|
@property (nonatomic, readonly) NSArray *routes;

@end
