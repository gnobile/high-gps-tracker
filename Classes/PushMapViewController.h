//
//  PushMapViewController.h
//  highest
//
//  Created by Giorgio Nobile on 06/02/12.
//  Copyright (c) 2012 ZeroNetAPP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface PushMapViewController : UIViewController <MKMapViewDelegate> {
    
	
	// the map view. 
	MKMapView* _mapView;
	
	
	// dictionary of route views indexed by annotation
	NSMutableDictionary* _routeViews;
}
+ (PushMapViewController *)shared;
-(IBAction)nomeTraccia:(NSString *)det;


- (void)generaMappa;
@property (nonatomic, retain) MKMapView* mapView;

@end

