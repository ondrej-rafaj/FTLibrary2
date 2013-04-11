//
//  FT2GMapsHelper.h
//  Mercedes Map Test
//
//  Created by Baldoph Pourprix on 10/04/2013.
//  Copyright (c) 2013 Fuerte Int. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface FT2GMapsHelper : NSObject

CLLocationCoordinate2D coordinatesForDictionary(NSDictionary *dict);

+ (NSMutableArray *)decodePolyline:(NSString *)encodedStr;

@end
