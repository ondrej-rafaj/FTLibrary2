//
//  FT2GoogleMapsServicesManager.h
//  Mercedes Map Test
//
//  Created by Baldoph Pourprix on 09/04/2013.
//  Copyright (c) 2013 Fuerte Int. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FT2GMapsDirectionRequest;
@class FT2GMapsDirectionOutput;

@interface FT2GMapsServices : NSObject

/**
 @return An opaque object that you pass as the argument to cancelRequest: to stop the request.
 */
- (id)executeDirectionRequest:(FT2GMapsDirectionRequest *)request completion:(void (^)(FT2GMapsDirectionOutput *directionOutput, NSError *error))completionBlock;

- (void)cancelRequest:(id)object;


@end
