//
//  SecondViewController.m
//  highest
//
//  Created by Giorgio Nobile on 06/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SecondViewController.h"
#import <CoreLocation/CoreLocation.h> 
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import <MapKit/MKReverseGeocoder.h>
#import "FirstViewController.h"




@implementation SecondViewController
UISegmentedControl *segmentedControl;
MKMapView *map;
UIWebView *webview;
BOOL setSpeed;
BOOL setLock;
BOOL setUnit;



/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
 // Custom initialization
 }
 return self;
 }
 */


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	//self.title = @"mappa";
 	/*NSArray *segmentTextContent = [NSArray arrayWithObjects: @"Standard", @"Satellite", @"Hybrid", nil];
	segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
	segmentedControl.frame = CGRectMake(0, 0, 320, 35);
	//[segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar ;
	segmentedControl.selectedSegmentIndex = 0;
	segmentedControl.alpha = 0.7;
	segmentedControl.enabled = true;	
	map = [[[MKMapView alloc] initWithFrame:CGRectMake(0,0,320,230)] autorelease ];
	[segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];    
	[map setZoomEnabled:YES];
    [map setScrollEnabled:YES];
	[map setShowsUserLocation:YES];
	[map setDelegate:self];
	[self setView:map];
	[self.view addSubview:segmentedControl];
	[segmentedControl release];*/
	
	webview = [[[UIWebView alloc] init] autorelease];
	NSString *path = [[NSBundle mainBundle] pathForResource:@"mapjs" ofType:@"html"];
    NSFileHandle *readHandle = [NSFileHandle fileHandleForReadingAtPath:path];
	
    NSString *htmlString = [[NSString alloc] initWithData: 
							[readHandle readDataToEndOfFile] encoding:NSUTF8StringEncoding];
	[webview loadHTMLString:htmlString baseURL:nil];
    [htmlString release];
	[self setView:webview];
	
}





// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
    [super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated { 
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
//	setSpeed = [defaults boolForKey:kSpeed];
	setLock = [defaults boolForKey:kAutolock];
	setUnit = [defaults boolForKey:kUnit];
	if (setLock == YES) {
		UIApplication *lockStat = [UIApplication sharedApplication];
		lockStat.idleTimerDisabled = NO;
		NSLog(@"Autolock Abilitato");
	}
	else { 
		UIApplication *lockStat = [UIApplication sharedApplication];
		lockStat.idleTimerDisabled = YES;
		NSLog(@"Autolock Disabilitato");
	}
	
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

#pragma mark zoom

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    for (MKAnnotationView *annotationView in views) {
        if (annotationView.annotation == mapView.userLocation) {
            MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.02);
            MKCoordinateRegion region = MKCoordinateRegionMake(mapView.userLocation.coordinate, span);
            [mapView setRegion:region animated:YES];
			[mapView regionThatFits:region];

        }
    }
}

- (void)segmentAction:(id)sender
{
    if (segmentedControl.selectedSegmentIndex ==0) {
		[map setMapType:MKMapTypeStandard];
	}
	if (segmentedControl.selectedSegmentIndex ==1) {
		[map setMapType:MKMapTypeSatellite];
	}
	if (segmentedControl.selectedSegmentIndex ==2) {
		[map setMapType:MKMapTypeHybrid];
	}
	
}


@end
