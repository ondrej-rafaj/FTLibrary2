//
//  GMSMapView+_Additions_.h
//  Mercedes Map Test
//
//  Created by Baldoph Pourprix on 10/04/2013.
//  Copyright (c) 2013 Fuerte Int. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>

@class GMSMapView;

@interface GMSMapView (Additions)

- (void)zoomToCoordinateBounds:(GMSCoordinateBounds *)coordinateBounds animated:(BOOL)animated;

@end
