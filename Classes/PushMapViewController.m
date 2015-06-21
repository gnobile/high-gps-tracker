//
//  PushMapViewController.m
//  highest
//
//  Created by Giorgio Nobile on 06/02/12.
//  Copyright (c) 2012 ZeroNetAPP. All rights reserved.
//

#import "PushMapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "CSMapAnnotation.h"
#import "CSRouteAnnotation.h"
#import "CSRouteView.h"
#import "HLPath.h"
#import "XMLDictionary.h"


@implementation PushMapViewController

NSString *titolo;
@synthesize mapView   = _mapView;
UISegmentedControl *segmentedControl;
NSString *data;

static PushMapViewController *shAcc = nil;

+ (PushMapViewController *) shared {
    if (!shAcc) {
        shAcc = [[PushMapViewController alloc] init];
    }
    return shAcc;
}
-(IBAction)nomeTraccia:(NSString *)det {
    titolo = det;
}

-(void)generaMappa {
    NSArray *segmentTextContent = [NSArray arrayWithObjects: @"Standard", @"Satellite", @"Hybrid", nil];
	segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
	segmentedControl.frame = CGRectMake(0, 0, 320, 35);
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar ;
	segmentedControl.selectedSegmentIndex = 0;
	segmentedControl.alpha = 0.7;
	segmentedControl.enabled = true;	
	[segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];    
	_routeViews = [[NSMutableDictionary alloc] init];
	// load the points from our local resource
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *temp = [documentsDirectory stringByAppendingPathComponent:@"PushTrack"];
    NSString *fullPathToFile = [temp stringByAppendingPathComponent:titolo];
    NSString *temp1 = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", titolo]];
    NSString *fullPathToFileKml = [temp1 stringByAppendingPathExtension:@"kml"];
    NSString *fileTranslate = [fullPathToFile stringByAppendingString:@"_mv"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:fullPathToFile]) {
        if (![[NSFileManager defaultManager] fileExistsAtPath:fileTranslate]) {
            [[NSFileManager defaultManager] createFileAtPath:fileTranslate contents:nil attributes:nil];        
            NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLFile:fullPathToFileKml];
            NSString *coordi = [xmlDoc valueForKeyPath:@"Document.Placemark.MultiGeometry.LineString.coordinates"];
            if (![coordi isKindOfClass:[NSString class]]) {
                coordi=@"9.4443,9.1234\n9.5443,9.2234";
            }
            coordi = [coordi stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *fileContents2 = [coordi stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            NSString *fileContents3 = [fileContents2 stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
            [fileContents3 writeToFile:fileTranslate atomically:YES];
        }
    } 
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileTranslate]) {
        NSString *fileContent = [NSString stringWithContentsOfFile:fileTranslate];
        NSArray *pointStrings = [fileContent componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSMutableArray *points = [[NSMutableArray alloc] initWithCapacity:pointStrings.count];	
        if (pointStrings.count <=2){
            MKMapView *fly = [[[MKMapView alloc] init  ] autorelease];
            [fly setShowsUserLocation:YES];
            MKCoordinateRegion region;
            region.center = _mapView.userLocation.coordinate;  
            MKCoordinateSpan span; 
            span.latitudeDelta  = 5; // Change these values to change the zoom
            span.longitudeDelta = 5; 
            region.span = span;
            [_mapView setRegion:region animated:TRUE];
            [_mapView regionThatFits:region];
            [self setView:fly];
        }else {
            for(int idx = 0; idx < (pointStrings.count-1); idx++)
            {
                NSString* currentPointString = [pointStrings objectAtIndex:idx];
                if (![currentPointString isEqualToString:@""]){
                    NSArray* latLonArr = [currentPointString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
                    CLLocationDegrees latitude = [[latLonArr objectAtIndex:0] doubleValue];
                    CLLocationDegrees longitude = [[latLonArr objectAtIndex:1] doubleValue];
                    CLLocation* currentLocation = [[[CLLocation alloc] initWithLatitude:longitude longitude:latitude ] autorelease];
                    [points addObject:currentLocation];
                }
            }
            _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            [self.view addSubview:_mapView];
            [_mapView setDelegate:self];
            CSRouteAnnotation* routeAnnotation = [[[CSRouteAnnotation alloc] initWithPoints:points] autorelease];
            [_mapView addAnnotation:routeAnnotation];
            CSMapAnnotation* annotation = nil;
            annotation = [[[CSMapAnnotation alloc] initWithCoordinate:[[points objectAtIndex:0] coordinate] annotationType:CSMapAnnotationTypeStart title:@"Start Point"] autorelease];
            [_mapView addAnnotation:annotation];
            annotation = [[[CSMapAnnotation alloc] initWithCoordinate:[[points objectAtIndex:points.count - 1] coordinate] annotationType:CSMapAnnotationTypeEnd title:@"End Point"] autorelease];
            [_mapView addAnnotation:annotation];
            [points release];
            [_mapView setRegion:routeAnnotation.region];
            [_mapView addSubview:segmentedControl];
        }
    } else {
        NSString *fileContent = [NSString stringWithContentsOfFile:fullPathToFile];
        NSArray *pointStrings = [fileContent componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSMutableArray *points = [[NSMutableArray alloc] initWithCapacity:pointStrings.count];	
        if (pointStrings.count <=2){
            MKMapView *fly = [[[MKMapView alloc] init  ] autorelease];
            [fly setShowsUserLocation:YES];
            MKCoordinateRegion region;
            region.center = _mapView.userLocation.coordinate;  
            MKCoordinateSpan span; 
            span.latitudeDelta  = 5; // Change these values to change the zoom
            span.longitudeDelta = 5; 
            region.span = span;
            [_mapView setRegion:region animated:TRUE];
            [_mapView regionThatFits:region];
            [self setView:fly];
        }else {
            for(int idx = 0; idx < (pointStrings.count-1); idx++)
            {
                NSString* currentPointString = [pointStrings objectAtIndex:idx];
                NSArray* latLonArr = [currentPointString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
                CLLocationDegrees latitude = [[latLonArr objectAtIndex:0] doubleValue];
                CLLocationDegrees longitude = [[latLonArr objectAtIndex:1] doubleValue];
                CLLocation* currentLocation = [[[CLLocation alloc] initWithLatitude:latitude longitude:longitude ] autorelease];
                [points addObject:currentLocation];
            }
            _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            [self.view addSubview:_mapView];
            [_mapView setDelegate:self];
            CSRouteAnnotation* routeAnnotation = [[[CSRouteAnnotation alloc] initWithPoints:points] autorelease];
            [_mapView addAnnotation:routeAnnotation];
            CSMapAnnotation* annotation = nil;
            annotation = [[[CSMapAnnotation alloc] initWithCoordinate:[[points objectAtIndex:0] coordinate] annotationType:CSMapAnnotationTypeStart title:@"Start Point"] autorelease];
            [_mapView addAnnotation:annotation];
            annotation = [[[CSMapAnnotation alloc] initWithCoordinate:[[points objectAtIndex:points.count - 1] coordinate] annotationType:CSMapAnnotationTypeEnd title:@"End Point"] autorelease];
            [_mapView addAnnotation:annotation];
            [points release];
            [_mapView setRegion:routeAnnotation.region];
            [_mapView addSubview:segmentedControl];
        }

    }
}


 - (void)viewDidLoad 
 {
 
 [super viewDidLoad];
     self.navigationItem.title =titolo;
 
 }
 /*
 - (void)viewDidUnload {
 self.mapView   = nil;
 }*/

-(void) viewWillAppear:(BOOL)animated{
    [self generaMappa];
    [super viewWillAppear:animated];
    
    
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
