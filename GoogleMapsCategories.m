//
//  GoogleMapsCategories.m
//  FTLibrary2
//
//  Created by Baldoph Pourprix on 11/04/2013.
//  Copyright (c) 2013 Fuerte International. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>
#import <MapKit/MapKit.h>
#import "FT2GMapsRoute.h"

@implementation GMSMapView (Additions)

- (void)zoomToCoordinateBounds:(GMSCoordinateBounds *)coordinateBounds animated:(BOOL)animated
{
	MKMapPoint northEastMapPoint = MKMapPointForCoordinate(coordinateBounds.northEast); // top right
	MKMapPoint southWestMapPoint = MKMapPointForCoordinate(coordinateBounds.southWest); // bottom left
	
	float mapViewWidth = self.frame.size.width;
	float mapViewHeight = self.frame.size.height;
	
	MKMapPoint centrePoint = MKMapPointMake(
											(northEastMapPoint.x + southWestMapPoint.x) / 2,
											(northEastMapPoint.y + southWestMapPoint.y) / 2);
	CLLocationCoordinate2D centreLocation = MKCoordinateForMapPoint(centrePoint);
	
	double mapScaleWidth = mapViewWidth / fabs(southWestMapPoint.x - northEastMapPoint.x);
	double mapScaleHeight = mapViewHeight / fabs(southWestMapPoint.y - northEastMapPoint.y);
	double mapScale = MIN(mapScaleWidth, mapScaleHeight);
	
	double zoomLevel = 20 + log2(mapScale);
	
	GMSCameraPosition *cameraPosition = [GMSCameraPosition
										 cameraWithLatitude: centreLocation.latitude
										 longitude: centreLocation.longitude
										 zoom: zoomLevel];
	if (animated) {
		[self animateToCameraPosition:cameraPosition];
	} else {
		self.camera = cameraPosition;
	}
}

@end


@implementation FT2GMapsRoute (GoogleMap)

- (GMSPath *)path
{
	if (_path == nil) {
		GMSMutablePath *path = [[GMSMutablePath alloc] init];
		
		NSArray *locations = self.polylineLocations;
		[locations enumerateObjectsUsingBlock:^(CLLocation *location, NSUInteger idx, BOOL *stop) {
			[path addCoordinate:location.coordinate];
		}];
		_path = path.copy;
	}
	return _path;
}

- (GMSCoordinateBounds *)bounds
{
	if (_bounds == nil) {
		_bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:self.northEastBound andCoordinate:self.southWestBound];
	}
	return _bounds;
}

@end