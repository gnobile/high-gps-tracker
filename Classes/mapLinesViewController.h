//
//  mapLinesViewController.h
//  mapLines
//
//  Created by Craig on 4/12/09.
//  Copyright Craig Spitzkoff 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface mapLinesViewController : UIViewController <MKMapViewDelegate> {

	
	// the map view. 
	MKMapView* _mapView;
	
	
	// dictionary of route views indexed by annotation
	NSMutableDictionary* _routeViews;
}
+ (mapLinesViewController *)shared;

- (void)generaMappa;
@property (nonatomic, retain) MKMapView* mapView;

@end

