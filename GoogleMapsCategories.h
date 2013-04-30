//
//  GoogleMapsCategories.h
//  FTLibrary2
//
//  Created by Baldoph Pourprix on 11/04/2013.
//  Copyright (c) 2013 Fuerte International. All rights reserved.
//


@class GMSMapView;
@class GMSCoordinateBounds;

@interface FT2GMapsRoute (GoogleMap)

- (GMSPath *)path;
- (GMSCoordinateBounds *)bounds;

@end

@interface NSArray (GoogleMap)

/* return a path for the array if all the objects are NSValues of CLLocationCoordinate2D */
- (GMSPath *)path;

@end
