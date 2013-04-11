//
//  GoogleMapsCategories.h
//  FTLibrary2
//
//  Created by Baldoph Pourprix on 11/04/2013.
//  Copyright (c) 2013 Fuerte International. All rights reserved.
//


@class GMSMapView;
@class GMSCoordinateBounds;

@interface GMSMapView (Additions)

- (void)zoomToCoordinateBounds:(GMSCoordinateBounds *)coordinateBounds animated:(BOOL)animated;

@end

@interface FT2GMapsRoute (GoogleMap)

- (GMSPath *)path;
- (GMSCoordinateBounds *)bounds;

@end
