//
//  Test2.m
//  highest
//
//  Created by Giorgio Nobile on 29/03/11.
//  Copyright 2011 ZeroNetAPP. All rights reserved.
//

#import "Test2.h"
#import <CoreLocation/CoreLocation.h>
#import "CSMapAnnotation.h"
#import "CSRouteAnnotation.h"
#import "CSRouteView.h"



@implementation Test2
@synthesize mapView   = _mapView;
UISegmentedControl *segmentedControl;


/*
 - (void)viewDidLoad 
 {
 
 [super viewDidLoad];
 
 // dictionary to keep track of route views that get generated. 
 _routeViews = [[NSMutableDictionary alloc] init];
 
 //
 // load the points from our local resource
 //
 NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
 NSString *documentsDirectory = [paths objectAtIndex:0];
 
 NSString *filename =@"route.csv"; //nome del file su disco, possiamo anche chiamarlo in altro modo
 NSString *fullPathToFile = [documentsDirectory stringByAppendingPathComponent:filename];
 
 //NSString* filePath = [[NSBundle mainBundle] pathForResource:@"route" ofType:@"csv"];
 NSString* fileContents = [NSString stringWithContentsOfFile:fullPathToFile];
 NSArray* pointStrings = [fileContents  componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
 
 NSMutableArray* points = [[NSMutableArray alloc] initWithCapacity:pointStrings.count];
 
 for(int idx = 0; idx < pointStrings.count; idx++)
 {
 // break the string down even further to latitude and longitude fields. 
 NSString* currentPointString = [pointStrings objectAtIndex:idx];
 NSArray* latLonArr = [currentPointString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
 
 CLLocationDegrees latitude = [[latLonArr objectAtIndex:0] doubleValue];
 CLLocationDegrees longitude = [[latLonArr objectAtIndex:1] doubleValue];
 
 
 
 CLLocation* currentLocation = [[[CLLocation alloc] initWithLatitude:latitude longitude:longitude ] autorelease];
 [points addObject:currentLocation];
 }
 
 
 //
 // Create our map view and add it as as subview. 
 //
 _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
 [self.view addSubview:_mapView ];
 [_mapView setDelegate:self];
 
 
 // CREATE THE ANNOTATIONS AND ADD THEM TO THE MAP
 
 // first create the route annotation, so it does not draw on top of the other annotations. 
 CSRouteAnnotation* routeAnnotation = [[[CSRouteAnnotation alloc] initWithPoints:points] autorelease];
 [_mapView addAnnotation:routeAnnotation ];
 
 
 // create the rest of the annotations
 CSMapAnnotation* annotation = nil;
 
 // create the start annotation and add it to the array
 annotation = [[[CSMapAnnotation alloc] initWithCoordinate:[[points objectAtIndex:0] coordinate]
 annotationType:CSMapAnnotationTypeStart
 title:@"Start Point"] autorelease];
 [_mapView addAnnotation:annotation];
 
 
 // create the end annotation and add it to the array
 annotation = [[[CSMapAnnotation alloc] initWithCoordinate:[[points objectAtIndex:points.count - 1] coordinate]
 annotationType:CSMapAnnotationTypeEnd
 title:@"End Point"] autorelease];
 [_mapView addAnnotation:annotation];
 
 
 
 [points release];
 
 // center and size the map view on the region computed by our route annotation. 
 [_mapView setRegion:routeAnnotation.region];
 
 
 }
 
 - (void)viewDidUnload {
 self.mapView   = nil;
 }*/

-(void) viewWillAppear:(BOOL)animated{
	NSArray *segmentTextContent = [NSArray arrayWithObjects: @"Standard", @"Satellite", @"Hybrid", nil];
	segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
	segmentedControl.frame = CGRectMake(0, 0, 320, 35);
	//[segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar ;
	segmentedControl.selectedSegmentIndex = 0;
	segmentedControl.alpha = 0.7;
	segmentedControl.enabled = true;	
	[segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];    
	
	_routeViews = [[NSMutableDictionary alloc] init];
	
	//
	// load the points from our local resource
	//
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	//NSString *filename =@"route.csv"; //nome del file su disco, possiamo anche chiamarlo in altro modo
	NSString *fullPathToFile = [documentsDirectory stringByAppendingPathComponent:@"rottina.csv"];
	
	//NSString* filePath = [[NSBundle mainBundle] pathForResource:@"route" ofType:@"csv"];
	NSString* fileContents = [NSString stringWithContentsOfFile:fullPathToFile];
	NSArray* pointStrings = [fileContents  componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	NSMutableArray* points = [[NSMutableArray alloc] initWithCapacity:pointStrings.count];
	
	if (pointStrings.count <2)
	{
		MKMapView *fly = [[[MKMapView alloc] init  ] autorelease];
		[fly setShowsUserLocation:YES];
		MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.02);
		MKCoordinateRegion region = MKCoordinateRegionMake(_mapView.userLocation.coordinate, span);
		[_mapView setRegion:region animated:YES];
		[_mapView regionThatFits:region];
		[self setView:fly];
		
	}else 
	{
		for(int idx = 0; idx < pointStrings.count; idx++)
		{
			// break the string down even further to latitude and longitude fields. 
			NSString* currentPointString = [pointStrings objectAtIndex:idx];
			NSArray* latLonArr = [currentPointString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
			
			CLLocationDegrees latitude = [[latLonArr objectAtIndex:0] doubleValue];
			CLLocationDegrees longitude = [[latLonArr objectAtIndex:1] doubleValue];
			
			
			
			CLLocation* currentLocation = [[[CLLocation alloc] initWithLatitude:latitude longitude:longitude ] autorelease];
			[points addObject:currentLocation];
		}
		
		
		//
		// Create our map view and add it as as subview. 
		//
		_mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
		[self.view addSubview:_mapView];
		[_mapView setDelegate:self];
		
		
		// CREATE THE ANNOTATIONS AND ADD THEM TO THE MAP
		
		// first create the route annotation, so it does not draw on top of the other annotations. 
		CSRouteAnnotation* routeAnnotation = [[[CSRouteAnnotation alloc] initWithPoints:points] autorelease];
		[_mapView addAnnotation:routeAnnotation];
		
		
		// create the rest of the annotations
		CSMapAnnotation* annotation = nil;
		
		// create the start annotation and add it to the array
		annotation = [[[CSMapAnnotation alloc] initWithCoordinate:[[points objectAtIndex:0] coordinate]
												   annotationType:CSMapAnnotationTypeStart
															title:@"Start Point"] autorelease];
		[_mapView addAnnotation:annotation];
		
		
		// create the end annotation and add it to the array
		annotation = [[[CSMapAnnotation alloc] initWithCoordinate:[[points objectAtIndex:points.count - 1] coordinate]
												   annotationType:CSMapAnnotationTypeEnd
															title:@"End Point"] autorelease];
		[_mapView addAnnotation:annotation];
		
		
		
		[points release];
		
		// center and size the map view on the region computed by our route annotation. 
		[_mapView setRegion:routeAnnotation.region];
		[_mapView addSubview:segmentedControl];
		
		[super viewWillAppear:animated];
	}
	
	
}

-(void)viewWillDisappear:(BOOL)animated {
	
	self.mapView   = nil;
	[super viewWillDisappear:animated];
	
	
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (NSString *)theFile {
	NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
	NSString *datas = [dateFormatter stringFromDate:[NSDate date]];
	NSString *tempfile = [datas stringByAppendingString:@"rottina.csv"];
	return tempfile;
	
}

- (void)segmentAction:(id)sender
{
    if (segmentedControl.selectedSegmentIndex ==0) {
		[_mapView setMapType:MKMapTypeStandard];
	}
	if (segmentedControl.selectedSegmentIndex ==1) {
		[_mapView setMapType:MKMapTypeSatellite];
	}
	if (segmentedControl.selectedSegmentIndex ==2) {
		[_mapView setMapType:MKMapTypeHybrid];
	}
	
}



#pragma mark mapView delegate functions
- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
	// turn off the view of the route as the map is chaning regions. This prevents
	// the line from being displayed at an incorrect positoin on the map during the
	// transition. 
	for(NSObject* key in [_routeViews allKeys])
	{
		CSRouteView* routeView = [_routeViews objectForKey:key];
		routeView.hidden = YES;
	}
	
}
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
	// re-enable and re-poosition the route display. 
	for(NSObject* key in [_routeViews allKeys])
	{
		CSRouteView* routeView = [_routeViews objectForKey:key];
		routeView.hidden = NO;
		[routeView regionChanged];
	}
	
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
	MKAnnotationView* annotationView = nil;
	
	
	if([annotation isKindOfClass:[CSMapAnnotation class]])
	{
		// determine the type of annotation, and produce the correct type of annotation view for it.
		CSMapAnnotation* csAnnotation = (CSMapAnnotation*)annotation;
		if(csAnnotation.annotationType == CSMapAnnotationTypeStart || 
		   csAnnotation.annotationType == CSMapAnnotationTypeEnd)
		{
			NSString* identifier = @"Pin";
			MKPinAnnotationView* pin = (MKPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
			
			if(nil == pin)
			{
				pin = [[[MKPinAnnotationView alloc] initWithAnnotation:csAnnotation reuseIdentifier:identifier] autorelease];
			}
			
			[pin setPinColor:(csAnnotation.annotationType == CSMapAnnotationTypeEnd) ? MKPinAnnotationColorRed : MKPinAnnotationColorGreen];
			
			annotationView = pin;
		}
		
		[annotationView setEnabled:YES];
		[annotationView setCanShowCallout:YES];
	}
	
	else if([annotation isKindOfClass:[CSRouteAnnotation class]])
	{
		CSRouteAnnotation* routeAnnotation = (CSRouteAnnotation*) annotation;
		
		annotationView = [_routeViews objectForKey:routeAnnotation.routeID];
		
		if(nil == annotationView)
		{
			CSRouteView* routeView = [[[CSRouteView alloc] initWithFrame:CGRectMake(0, 0, _mapView.frame.size.width, _mapView.frame.size.height)] autorelease];
			
			routeView.annotation = routeAnnotation;
			routeView.mapView = _mapView;
			
			[_routeViews setObject:routeView forKey:routeAnnotation.routeID];
			
			annotationView = routeView;
		}
	}
	
	return annotationView;
}



- (void)dealloc {	
    
	[_mapView release];
	[_routeViews release];
	
	[super dealloc];
	
}

@end
