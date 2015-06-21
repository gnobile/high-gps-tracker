//
//  Test2.h
//  highest
//
//  Created by Giorgio Nobile on 29/03/11.
//  Copyright 2011 ZeroNetAPP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface Test2 : UIViewController <MKMapViewDelegate> {
	
	
	// the map view. 
	MKMapView* _mapView;
	
	
	// dictionary of route views indexed by annotation
	NSMutableDictionary* _routeViews;
}


@property (nonatomic, retain) MKMapView* mapView;

@end

