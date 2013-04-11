//
//  GMSMapView+_Additions_.m
//  Mercedes Map Test
//
//  Created by Baldoph Pourprix on 10/04/2013.
//  Copyright (c) 2013 Fuerte Int. All rights reserved.
//

#import "GMSMapView+Additions.h"
#import <MapKit/MapKit.h>
#import <Foundation/Foundation.h>

#define MERCATOR_OFFSET 268435456
#define MERCATOR_RADIUS 85445659.44705395

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
