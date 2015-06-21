//
//  FirstViewController.m
//  highss
//
//  Created by Giorgio Nobile on 08/06/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import "FirstViewController.h"
#import "highestAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "HLPath.h"

@implementation FirstViewController
@synthesize locManager;
@synthesize startingPoint;
@synthesize altitudineFeet;
@synthesize altitudineWeb;
@synthesize altitudine;
@synthesize latitudine;
@synthesize longitudine; 
@synthesize latitudineExt;
@synthesize longitudineExt; 
@synthesize citta;
@synthesize mp;
@synthesize geoCoder;
@synthesize dir;
@synthesize totaldistance;
@synthesize play;
@synthesize stop;
@synthesize actView;
@synthesize accu1;
@synthesize accu2;
@synthesize accu3;
@synthesize accu4;
@synthesize accu5;
@synthesize locationz;
@synthesize degreeLat;
@synthesize degreeLon;
NSString *firstt;
NSString *lastt;
NSString *latitudineString;
NSString *longitudineString;
NSString *filePath;
NSString *myoldlatitude;
NSString *myoldlongitude;
//NSString *datax;
//NSString *giornox;
NSString *myLastAltitude;
//NSDateFormatter *datex;
//NSDateFormatter *giornex;
NSTimer *myTimer;
int oldCourse;
int counter = 0;
int checkThreeData = 0;
int firstRecord = 0;
int firstAltitude = 0;
int altitudeRecord = 0;
int contaAlt = 0;
int myDistInt = 0;
int countSpeed = 0;
int myIntAlt;
BOOL ismagne = NO;
BOOL setLock;
BOOL setUnit;
BOOL setCoord;
BOOL FTime;
BOOL locationChanged;
BOOL locationOffline;
float setGps;
CLLocationDistance totalDistanceTraveled;
int number_total;
int min = 0;
int max = 0;
int altmin = 0;
int altmedia = 0;
int altmediaFeet = 0;
int forzacheck = 0;





//FB Var
@synthesize session = _session;
@synthesize postGradesButton = _postGradesButton;
@synthesize logoutButton = _logoutButton;
@synthesize loginDialog = _loginDialog;
@synthesize facebookName = _facebookName;
@synthesize posting = _posting;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
#pragma mark -

- (void)viewDidLoad {	
    [super viewDidLoad];

    locationOffline = YES;
	degreeLat.text =@"°";
	degreeLon.text =@"°";
	//setto data e giorno per salvataggi
	/*datex = [[[NSDateFormatter alloc] init] autorelease];
	[datex setDateFormat:@"dd_MM_yyyy_HH_mm_"];
	datax = [datex stringFromDate:[NSDate date]];
	
	giornex = [[[NSDateFormatter alloc]init] autorelease];
	[giornex setDateFormat:@"ddMMyyyy"];
	giornox = [giornex stringFromDate:[NSDate date]];
	*/
	//Setto fonts applicazione
	UIFont *altFont = [UIFont fontWithName:@"DBLCDTempBlack" size:45.0];
	UIFont *coordinateFont = [UIFont fontWithName:@"DBLCDTempBlack" size:15.0];
	latitudine.font = coordinateFont;
	longitudine.font = coordinateFont;
	latitudineExt.font = coordinateFont;
	longitudineExt.font = coordinateFont;
	altitudine.font = altFont;
	altitudineFeet.font = altFont;
	altitudine.text =@"";
	altitudineFeet.text =@"";
  //  [stop setHidden:YES];	
	//starto e schedulo reverse geocode
	[self reversing];
    //TESTFILE
	//myTimer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(testStop) userInfo:NULL repeats:YES];
	//FB COnnect
	static NSString* kApiKey = @"<FB_API_KEY>";
	static NSString* kApiSecret = @"<FB_SECRET_KEY>";
	_session = [[FBSession sessionForApplication:kApiKey secret:kApiSecret delegate:self] retain];
	// Load a previous session from disk if available.  Note this will call session:didLogin if a valid session exists.
	[_session resume];
    number_total = [[NSUserDefaults standardUserDefaults] integerForKey:@"track_total"];
	[self initSpinner];
    self.locationz = [[NSMutableArray alloc] init];
}


- (void)viewDidAppear :(BOOL)animated { 
    NSLog(@"Access to viewDidAppear");
	//acceto al plist dei settaggi e lo leggo
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
	setGps  = [defaults floatForKey:kGps] ;
	setLock = [defaults boolForKey:kAutolock];
	setUnit = [defaults boolForKey:kUnit];
	setCoord = [defaults boolForKey:kCoord];
	//setto sensibilità gps
    if (locationOffline == NO) {
	if ((setGps >= 0) && (setGps < 5))
	{
		//locManager.distanceFilter = 5.0f;
		locManager.desiredAccuracy = kCLLocationAccuracyBest;
	} else if ((setGps >= 3) && (setGps <7))
	{
		locManager.distanceFilter = 20.0f;
		locManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
	}else if ((setGps >= 7) && (setGps <=10))
	{
		locManager.distanceFilter = 50.0f;
		locManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
	}
    }
	//setto autolock
	if (setLock == YES) {
		UIApplication *lockStat = [UIApplication sharedApplication];
		lockStat.idleTimerDisabled = NO;
	}
	else { 
		UIApplication *lockStat = [UIApplication sharedApplication];
		lockStat.idleTimerDisabled = YES;
	}
	if (setUnit == YES ) {
	//	mp.text =@"meter";
		mp.text = [NSString stringWithFormat:@"%@" , NSLocalizedString(@"mkey", @"")];
		[altitudineFeet setHidden:YES];
		[altitudine setHidden:NO];
	} else {
		//mp.text =@"feet";
		mp.text =[NSString stringWithFormat:@"%@" , NSLocalizedString(@"fkey", @"")];
		[altitudineFeet setHidden:NO];
		[altitudine setHidden:YES];
	}
	if (setCoord == YES ) {
		[degreeLat setHidden:NO];
		[degreeLon setHidden:NO];
		[latitudine setHidden:NO];
		[longitudine setHidden:NO];
		[latitudineExt setHidden:YES];
		[longitudineExt setHidden:YES];
	} else {
		[degreeLat setHidden:YES];
		[degreeLon setHidden:YES];
		[latitudine setHidden:YES];
		[longitudine setHidden:YES];
		[latitudineExt setHidden:NO];
		[longitudineExt setHidden:NO];
	}
	[super viewDidAppear:animated];
}
	
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	self.session =nil;
	self.postGradesButton = nil;
	self.logoutButton = nil;
	self.loginDialog =nil;
	self.facebookName = nil;
	latitudineString = nil;
	longitudineString = nil;
	self.latitudine = nil;
	self.longitudine = nil;
	self.latitudineExt = nil;
	self.longitudineExt = nil;
	self.startingPoint = nil;
	self.altitudine = nil;
	self.altitudineFeet = nil;
	self.totaldistance = nil;
	self.citta = nil;
	self.dir = nil;
	[locManager stopUpdatingLocation];
	[locManager stopUpdatingHeading];
	self.locManager = nil;
	self.startingPoint = nil;
	filePath = nil;
	myoldlatitude = nil;
	myoldlongitude = nil;
	myLastAltitude = nil;
	self.play = nil;
    self.stop = nil;
	self.totaldistance = nil;
	self.actView = nil;
	self.accu1 = nil;
	self.accu2 = nil;
	self.accu3 = nil;
	self.accu4 = nil;
	self.accu5 = nil;
	self.locationz = nil;
	[super viewDidUnload];	

}

- (void)dealloc {
	//FB
	[_postGradesButton release];
	[_logoutButton release];
	[_loginDialog release];
	[_facebookName release];
	[_session release];
	//
    [stop release];
	[play release];
	[filePath release];
	[myoldlatitude release];
	[myoldlongitude release];
	[myLastAltitude release];
	[latitudineString release];
	[longitudineString release];
	[locManager release];
	[altitudine release];
	[longitudine release];
	[latitudine release];
	[longitudineExt release];
	[latitudineExt release];
	[altitudineFeet release];
	[totaldistance release];
	[citta		release];
	[dir release];
	[geoCoder release];
	[myTimer invalidate];
	[myTimer release];
	[startingPoint release];
	[totaldistance release];
	[actView release];
	[accu1 release];
	[accu2 release];
	[accu3 release];
	[accu4 release];
	[accu5 release];
	[locationz release];
	[lastt release];
	[firstt release];
    [super dealloc];

}

#pragma mark -
#pragma mark CLLocationManagerDelegate Methods

- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation
			fromLocation:(CLLocation *)oldLocation {
	NSDate* newLocationEventTime = newLocation.timestamp;
    NSTimeInterval howRecentNewLocation = [newLocationEventTime timeIntervalSinceNow];
	//controllo se la localizzazione è cambiata
	if((newLocation.coordinate.latitude != oldLocation.coordinate.latitude) && 
	   (newLocation.coordinate.longitude != oldLocation.coordinate.longitude)) {
		locationChanged = YES;
	}
	if ((!startingPoint || startingPoint.horizontalAccuracy >= newLocation.horizontalAccuracy) && 
		(howRecentNewLocation < -0.0 && howRecentNewLocation > -15.0) && 
		((newLocation.horizontalAccuracy < (oldLocation.horizontalAccuracy -10.0)) || (newLocation.horizontalAccuracy < 50.0) ) 
		&& locationChanged)  {
		//da fare
		//visualizzo nuovo pulsante stop
        [play setHidden:YES];
        [play setEnabled:YES];
		[stop setHidden:NO];
		//salvo dati in array per ricavare tempi
		//test accuracy grafica
		if (newLocation.horizontalAccuracy <= 18) {
			[accu1 setImage:[UIImage imageNamed:@"green.png"]];
			[accu2 setImage:[UIImage imageNamed:@"green.png"]];
			[accu3 setImage:[UIImage imageNamed:@"green.png"]];
			[accu4 setImage:[UIImage imageNamed:@"green.png"]];
			[accu5 setImage:[UIImage imageNamed:@"green.png"]];
		}
		else if (newLocation.horizontalAccuracy <= 29){
			[accu1 setImage:[UIImage imageNamed:@"green.png"]];
			[accu2 setImage:[UIImage imageNamed:@"green.png"]];
			[accu3 setImage:[UIImage imageNamed:@"green.png"]];
			[accu4 setImage:[UIImage imageNamed:@"green.png"]];
			[accu5 setImage:[UIImage imageNamed:@""]];
		}
		else if (newLocation.horizontalAccuracy <= 48){
			[accu1 setImage:[UIImage imageNamed:@"yellow.png"]];
			[accu2 setImage:[UIImage imageNamed:@"yellow.png"]];
			[accu3 setImage:[UIImage imageNamed:@"yellow.png"]];
			[accu4 setImage:[UIImage imageNamed:@""]];
			[accu5 setImage:[UIImage imageNamed:@""]];
		}
		else if (newLocation.horizontalAccuracy <= 140){
			[accu1 setImage:[UIImage imageNamed:@"red.png"]];
			[accu2 setImage:[UIImage imageNamed:@"red.png"]];
			[accu3 setImage:[UIImage imageNamed:@""]];
			[accu4 setImage:[UIImage imageNamed:@""]];
			[accu5 setImage:[UIImage imageNamed:@""]];			
		}else if (newLocation.horizontalAccuracy < 163){
			[accu1 setImage:[UIImage imageNamed:@"red.png"]];
			[accu2 setImage:[UIImage imageNamed:@""]];
			[accu3 setImage:[UIImage imageNamed:@""]];
			[accu4 setImage:[UIImage imageNamed:@""]];
			[accu5 setImage:[UIImage imageNamed:@""]];	
		}
		//fine test accuracy
		if (startingPoint == nil) {
			self.startingPoint = newLocation;
		}
        //test
        if (checkThreeData > 2){
            if (myDistInt > 0) {
                //calcolo distanza percorsa
                if ([newLocation respondsToSelector:@selector(distanceFromLocation:)]){
                    totalDistanceTraveled += fabs([newLocation distanceFromLocation:oldLocation]);
                } else if ([newLocation respondsToSelector:@selector(getDistanceFrom:)]){
                    totalDistanceTraveled += fabs([newLocation getDistanceFrom:oldLocation]);
                }
                myDistInt ++;
            } 
        }
		myDistInt ++;		
		totaldistance.text = [NSString stringWithFormat:@"%5.2fkm", totalDistanceTraveled / 1000] ;
		
		latitudineString = [[NSString alloc] initWithFormat:@"%g", newLocation.coordinate.latitude];
		latitudine.text = latitudineString;
		[latitudineString release];
		longitudineString = [[NSString alloc] initWithFormat:@"%g", newLocation.coordinate.longitude];
		longitudine.text = longitudineString;	
		[longitudineString release];
		
		//calcolo e visualizzo coordinate in gradi-minuti-secondi
		int degrees = newLocation.coordinate.latitude;
		double decimal = fabs(newLocation.coordinate.latitude - degrees);
		int minutes = decimal * 60;
		double seconds = decimal * 3600 - minutes * 60;
		NSString *latExt = [NSString stringWithFormat:@"%d°%d'%1.4f\"", 
						 degrees, minutes, seconds];
		latitudineExt.text = latExt;
		degrees = newLocation.coordinate.longitude;
		decimal = fabs(newLocation.coordinate.longitude - degrees);
		minutes = decimal * 60;
		seconds = decimal * 3600 - minutes * 60;
		NSString *longExt = [NSString stringWithFormat:@"%d°%d'%1.4f\"", 
						   degrees, minutes, seconds];
		longitudineExt.text = longExt;
		
		
		if (checkThreeData >2) {
            [[NSFileManager defaultManager] removeItemAtPath: [[HLPath shared] emptyFilePath] error:nil];
            [self.locationz addObject:newLocation];
			NSString *file;
            NSString *file3;
			NSString *file1;
            NSString *file2;
			//test scrittura realtime kml
			NSString *kml1;
            NSString *gpx1;
            NSString *csv1;
			if (firstRecord == 0) {
				//test scrittura realtime kml
				kml1 = [NSString stringWithFormat:@"%@,%@\n\t\t", longitudine.text, latitudine.text];
				NSData *klmData = [kml1 dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
                NSFileHandle *writeKlm = [NSFileHandle fileHandleForWritingAtPath:[[HLPath shared] moveKmlPath]];
				[writeKlm truncateFileAtOffset:[writeKlm seekToEndOfFile]];
				[writeKlm writeData:klmData];
				[writeKlm closeFile];
				csv1 = [NSString stringWithString:@"Longitude;Latitude\n"];
				NSData *csvData = [csv1 dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
                NSFileHandle *writeCsv = [NSFileHandle fileHandleForWritingAtPath:[[HLPath shared] moveCsvPath]];
				[writeCsv truncateFileAtOffset:[writeCsv seekToEndOfFile]];
				[writeCsv writeData:csvData];
				[writeCsv closeFile];
                gpx1 = [NSString stringWithFormat:@"\t\t\t<trkpt lat=\"%@\" lon=\"%@\">\t\t\t</trkpt>\n",latitudine.text,longitudine.text];
				NSData *gpxData = [gpx1 dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
                NSFileHandle *writeGpx = [NSFileHandle fileHandleForWritingAtPath:[[HLPath shared] moveGpxPath]];
				[writeGpx truncateFileAtOffset:[writeGpx seekToEndOfFile]];
				[writeGpx writeData:gpxData];
				[writeGpx closeFile];
				file = [NSString stringWithFormat:@"%@,%@", latitudine.text, longitudine.text];
                file3 = [NSString stringWithFormat:@"%@,%@", latitudine.text, longitudine.text];
				file1 = [NSString stringWithFormat:@"%@,%@",latitudine.text,longitudine.text];
                file2 = [NSString stringWithFormat:@"%@,%@",latitudine.text,longitudine.text];
				firstRecord++;
				myoldlatitude = latitudine.text;
				myoldlongitude = longitudine.text;
				NSData *data = [file dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
                NSData *data3 = [file3 dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
				NSData *data1 = [file1 dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
                NSData *data2 = [file2 dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
				NSFileHandle *handle;
                NSFileHandle *handle3;
				NSFileHandle *handle1;
                NSFileHandle *handle2;
				handle = [NSFileHandle fileHandleForWritingAtPath:[[HLPath shared] dataFilePath]];
                handle3 = [NSFileHandle fileHandleForWritingAtPath:[[HLPath shared] moveTrackPath]];
				handle1 = [NSFileHandle fileHandleForWritingAtPath:[[HLPath shared] dataGpxFilePath]];
                handle2 = [NSFileHandle fileHandleForWritingAtPath:[[HLPath shared] dataCsvFilePath]];
				[handle truncateFileAtOffset:[handle seekToEndOfFile]];
                [handle3 truncateFileAtOffset:[handle3 seekToEndOfFile]];
				[handle1 truncateFileAtOffset:[handle1 seekToEndOfFile]];
                [handle2 truncateFileAtOffset:[handle2 seekToEndOfFile]];
				[handle writeData:data];	
                [handle3 writeData:data3];	
				[handle1 writeData:data1];	
                [handle2 writeData:data2];	
				[handle closeFile];
                [handle3 closeFile];
				[handle1 closeFile];
                [handle2 closeFile];
			}
			if ((myoldlatitude != latitudine.text) || (myoldlongitude != longitudine.text)) {
				//aggiungere controllo x scartare valori pessimi
				kml1 = [NSString stringWithFormat:@"\r%@,%@\n\t\t", longitudine.text, latitudine.text];
				NSData *klmData = [kml1 dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
				//NSFileHandle *writeKlm = [NSFileHandle fileHandleForWritingAtPath:[[HLPath shared] kmlFilePath]];
                NSFileHandle *writeKlm = [NSFileHandle fileHandleForWritingAtPath:[[HLPath shared] moveKmlPath]];
				[writeKlm truncateFileAtOffset:[writeKlm seekToEndOfFile]];
				[writeKlm writeData:klmData];
				[writeKlm closeFile];
				csv1 = [NSString stringWithFormat:@"%@;%@\n", longitudine.text, latitudine.text];
				NSData *csvData = [csv1 dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
				//NSFileHandle *writeCsv = [NSFileHandle fileHandleForWritingAtPath:[[HLPath shared] csvFilePath]];
                NSFileHandle *writeCsv = [NSFileHandle fileHandleForWritingAtPath:[[HLPath shared] moveCsvPath]];
				[writeCsv truncateFileAtOffset:[writeCsv seekToEndOfFile]];
				[writeCsv writeData:csvData];
				[writeCsv closeFile];
                gpx1 = [NSString stringWithFormat:@"\r\t\t\t<trkpt lat=\"%@\" lon=\"%@\">\t\t\t</trkpt>\n",latitudine.text,longitudine.text];
				NSData *gpxData = [gpx1 dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
				//NSFileHandle *writeGpx = [NSFileHandle fileHandleForWritingAtPath:[[HLPath shared] gpxFilePath]];
                NSFileHandle *writeGpx = [NSFileHandle fileHandleForWritingAtPath:[[HLPath shared] moveGpxPath]];
				[writeGpx truncateFileAtOffset:[writeGpx seekToEndOfFile]];
				[writeGpx writeData:gpxData];
				[writeGpx closeFile];
				file = [NSString stringWithFormat:@"\r%@,%@", latitudine.text, longitudine.text];
                file3 = [NSString stringWithFormat:@"\r%@,%@", latitudine.text, longitudine.text];
				file1 = [NSString stringWithFormat:@"\r%@,%@", latitudine.text, longitudine.text];
                file2 = [NSString stringWithFormat:@"\n%@,%@", latitudine.text, longitudine.text];
				NSData *data = [file dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
                NSData *data3 = [file3 dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
				NSData *data1 = [file1 dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
                NSData *data2 = [file2 dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
				NSFileHandle *handle;
                NSFileHandle *handle3;
				NSFileHandle *handle1;
                NSFileHandle *handle2;
				handle = [NSFileHandle fileHandleForWritingAtPath:[[HLPath shared] dataFilePath]];
                handle3 = [NSFileHandle fileHandleForWritingAtPath:[[HLPath shared] moveTrackPath]];
				handle1 = [NSFileHandle fileHandleForWritingAtPath:[[HLPath shared] dataGpxFilePath]];
                handle2 = [NSFileHandle fileHandleForWritingAtPath:[[HLPath shared] dataCsvFilePath]];
				[handle truncateFileAtOffset:[handle seekToEndOfFile]];
                [handle3 truncateFileAtOffset:[handle3 seekToEndOfFile]];
				[handle1 truncateFileAtOffset:[handle1 seekToEndOfFile]];
                [handle2 truncateFileAtOffset:[handle2 seekToEndOfFile]];
				[handle writeData:data];
                [handle3 writeData:data3];	
				[handle1 writeData:data1];	
                [handle2 writeData:data2];	
				[handle closeFile];
                [handle3 closeFile];
				[handle1 closeFile];
                [handle2 closeFile];
				myoldlatitude = latitudine.text;
				myoldlongitude = longitudine.text;
			}
			else {
				//NSLog(@"Latitudine precedente %@ uguale a nuova latitudine %@", myoldlatitude, latitudine.text);
				//NSLog(@"Longitudine precedente %@ uguale a nuova longitudine %@", myoldlongitude, longitudine.text);
			}

		}else {
				//NSLog(@" Coordinate: Scarto il %d record", checkThreeData);
		}
		checkThreeData++;
		//codice per iphone 3g senza magnetometro --> OK
		if (ismagne == NO) {
			NSString *courseString = [[NSString alloc] initWithFormat:@"%3.0f", newLocation.course];
			NSString *oldCourseString = [[NSString alloc] initWithFormat:@"%3.0f", oldLocation.course];
			int myLastCourse = [oldCourseString intValue];
			int myIntCourse = [courseString intValue];
			oldCourse = myLastCourse;
			if (myIntCourse <0 && oldCourse >=0) {
				[dir setImage:[UIImage imageNamed:@"no.png"]];
				[dir setTransform:CGAffineTransformMakeRotation(oldCourse * 3.14159/180)];
			}
			if (myIntCourse >= 0) {
				[dir setImage:[UIImage imageNamed:@"no.png"]];
				[dir setTransform:CGAffineTransformMakeRotation(myIntCourse * 3.14159/180)];
			}
		[courseString release];
		[oldCourseString release];
		}
		//Altitudine e scrittura su file dei dati ricevuti
		NSString *altitudineString = [[NSString alloc] initWithFormat:@"%5.0f", newLocation.altitude];
		NSString *noSpacesMeter = [altitudineString stringByTrimmingCharactersInSet:
							   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
		NSString *altitudineStringF = [[NSString alloc] initWithFormat:@"%5.0f", newLocation.altitude*3.82];
		altitudine.text = noSpacesMeter;
		altitudineFeet.text = altitudineStringF;
		myIntAlt = [noSpacesMeter intValue];
		//animazione segnale se alt < 0
		if (myIntAlt <= 0) {
			//[self spinBegin];
			}
		else { 
			[self spinEnd];
			}
		[altitudineString release];
		[altitudineStringF release];
        if (checkThreeData > 3) {
            if (myIntAlt >1) {
                if (altitudeRecord == 0) {
                    NSString* file = [NSString stringWithFormat:@"%@", altitudine.text];
                    NSString* file_bis = [NSString stringWithFormat:@"%@", altitudine.text];
                    altitudeRecord++;
                    NSData *data = [file dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
                    NSData *data_bis = [file_bis dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
                    NSFileHandle *handle;
                    NSFileHandle *handle_bis;                
                    handle = [NSFileHandle fileHandleForWritingAtPath:[[HLPath shared] meterFilePath]];
                    handle_bis = [NSFileHandle fileHandleForWritingAtPath:[[HLPath shared] moveAltPath]];
                    [handle truncateFileAtOffset:[handle seekToEndOfFile]];
                    [handle_bis truncateFileAtOffset:[handle_bis seekToEndOfFile]];
                    [handle writeData:data];
                    [handle_bis writeData:data_bis];
                    [handle closeFile];
                    [handle_bis closeFile];
                    myLastAltitude = altitudine.text;
                    //myIntLastAltitude = [myLastAltitude intValue];
                } 
                if (myLastAltitude != altitudine.text){
                    NSString* file = [NSString stringWithFormat:@"\r%@", altitudine.text];
                    NSString* file1 = [NSString stringWithFormat:@"\r%@", altitudine.text];
                    altmin = [altitudine.text intValue];
                    if (forzacheck == 0) {
                        min = altmin;
                        max = altmin;
                        forzacheck ++;
                    }
                    if (altmin <= min) {
                           min = altmin;
                       }
                    if (altmin >= max) {
                          max = altmin;
                       }

                    NSData *data = [file dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];	
                    NSData *data1 = [file1 dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];				
                    NSFileHandle *handle;
                    NSFileHandle *handle1;
                    handle = [NSFileHandle fileHandleForWritingAtPath:[[HLPath shared] meterFilePath]];
                    handle1 = [NSFileHandle fileHandleForWritingAtPath:[[HLPath shared] moveAltPath]];
                    [handle truncateFileAtOffset:[handle seekToEndOfFile]];
                    [handle1 truncateFileAtOffset:[handle1 seekToEndOfFile]];
                    [handle writeData:data];
                    [handle1 writeData:data1];
                    [handle closeFile];
                    [handle1 closeFile];
                    myLastAltitude = altitudine.text;
				} 
                else 
                { 
                    myLastAltitude = altitudine.text;
                }
            }
        }
			else 
			{
				//NSLog(@"valore nullo o zero lo scarto");
			}
	}

}

- (void)locationManager: (CLLocationManager *)manager
	   didFailWithError: (NSError *)error {
	[self spinBegin];
	switch([error code])
	{
		case kCLErrorNetwork: // general, network-related error
		{
			NSLog(@"NTWK error");
		}
			break;
		case kCLErrorDenied:{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@" , NSLocalizedString(@"errkey", @"")] message:[NSString stringWithFormat:@"%@" , NSLocalizedString(@"denykey", @"")] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
			[alert show];
			[alert release];
		}
			break;
		default:
		{
			NSLog(@"Unkown Error");
		}
			break;
	}
}

#pragma mark
#pragma mark magne
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading 
{
	NSString *courseString = [[NSString alloc] initWithFormat:@"%3.0f", newHeading.trueHeading];
	int myIntCourse = [courseString intValue];
	[dir setImage:[UIImage imageNamed:@"no.png"]];
	[dir setTransform:CGAffineTransformMakeRotation(myIntCourse * 3.14159/180)];
	[courseString release];	
}

-(BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager{
	return YES;
}

#pragma mark
#pragma mark reverseGeocoder

- (void)reversing {
	geoCoder=[[MKReverseGeocoder alloc] initWithCoordinate:locManager.location.coordinate];
	geoCoder.delegate=self;
	[geoCoder start];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error{
	citta.text = [NSString stringWithFormat:@"%@" , NSLocalizedString(@"citikey", @"")];
	[_postGradesButton setEnabled:NO];
	[geoCoder cancel];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark {
	citta.text = [placemark locality];
	[geoCoder cancel];
	[_postGradesButton setEnabled:YES];	
}


#pragma mark actionsheetExport
//v3.0

-(IBAction)showActionSheet:(id)sender {
	
	UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"uiasTitle", @"")
								delegate:self 
								cancelButtonTitle:NSLocalizedString(@"uiasCancel", @"")
                                destructiveButtonTitle:nil
								otherButtonTitles:NSLocalizedString(@"uiasKML", @""), NSLocalizedString(@"uiasGPX", @""), NSLocalizedString(@"uiasCSV", @""), nil];
	popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	//[popupQuery showInView:self.view];
    popupQuery.tag = 1;
    [popupQuery showInView:self.view];
	[popupQuery release];
}
//end v3.0

-(void)stopTrack{    
	UIActionSheet *popupQuery = [[UIActionSheet alloc] 
                                 initWithTitle:NSLocalizedString(@"stopTitle", @"")
                                 //initWithTitle:@"Vuoi salvare la traccia corrente ed iniziarne una nuova?"
                                 delegate:self 
                                 cancelButtonTitle:NSLocalizedString(@"uiasCancel", @"")
                                 //cancelButtonTitle:@"Cancella"
                                 
                                 destructiveButtonTitle:nil
                                 otherButtonTitles:NSLocalizedString(@"stopOk", @""),  nil];
                                 //otherButtonTitles:@"Si", nil];
    
	popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    popupQuery.tag = 2;
    [popupQuery showInView:self.view];
	[popupQuery release];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    //v3.0
   if (actionSheet.tag == 1) {
        if (buttonIndex == 0) {
          //  [self generateKmlToShare];
          //  [self displayComposerSheetKml];
        } else if (buttonIndex == 1) {
         //   [self generateGpxToShare];
         //   [self displayComposerSheetGpx];
        } else if (buttonIndex == 2) {
            //   [self generateGpxToShare];
          //  [self displayComposerSheetCsv];
        }
    } else if (actionSheet.tag == 2) {
        if (buttonIndex == 0) {
          if (![[NSFileManager defaultManager] fileExistsAtPath:[[HLPath shared] emptyFilePath]]) {  
              NSError *er;
            [[NSFileManager defaultManager] removeItemAtPath: [[HLPath shared] lockFilePath] error:&er];
            [[HLPath shared] generateKmlToShare];
            [[HLPath shared] generateGpxToShare];
            [[HLPath shared] generateCsvToShare];
              //test write attributes
            [[NSFileManager defaultManager] createFileAtPath:[[HLPath shared] logArray] contents:nil attributes:nil];
             NSDate *first = [(CLLocation *)[self.locationz objectAtIndex:0] timestamp];
             NSDate *last = [(CLLocation *)[self.locationz lastObject] timestamp];
             NSTimeInterval time = [last timeIntervalSinceDate:first];
              NSInteger ti = (NSInteger)time;
              NSInteger seconds = ti % 60;
              NSInteger minutes = (ti / 60) % 60;
              NSInteger hours = (ti / 3600);
              NSString *duration = [NSString stringWithFormat:@"%02i:%02i:%02i", hours, minutes, seconds];
             NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];    
             [dateFormatter setLocale: [NSLocale currentLocale]];    
             [dateFormatter setDateFormat:@"dd/MM/yyyy"]; // or whichever style...
             //[dateFormatter setTimeStyle:kCFDateFormatterNoStyle];   
             NSString* dateString = [dateFormatter stringFromDate:first];
             NSDateFormatter *dateFormatter2 = [[[NSDateFormatter alloc] init] autorelease];    
             [dateFormatter2 setLocale: [NSLocale currentLocale]];    
             [dateFormatter2 setDateFormat:@"HH:mm:ss"];
             altmedia = max-min;
             altmediaFeet = altmedia * 3.82;
             NSString* timeStart = [dateFormatter2 stringFromDate:first];
             NSString* timeEnd = [dateFormatter2 stringFromDate:last];
              NSString *alta = [NSString stringWithFormat:@"%d", altmedia];
              NSString *altaFeet = [NSString stringWithFormat:@"%d", altmediaFeet];
              NSString *distanceReplace = [totaldistance.text stringByReplacingOccurrencesOfString:@"km" withString:@" km"];
              NSString *dislivelloReplace = [alta stringByReplacingOccurrencesOfString:@" " withString:@""];
              NSString *dislivelloReplaceFeet = [altaFeet stringByReplacingOccurrencesOfString:@" " withString:@""];
              //NSDictionary *write = [[[NSDictionary alloc] init] autorelease];
              NSDictionary *write = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@", dateString], @"date", [NSString stringWithFormat:@"%@",timeStart], @"startime", [NSString stringWithFormat:@"%@",timeEnd], @"stoptime", [NSString stringWithFormat:@"%@ m",dislivelloReplace], @"dislivello", [NSString stringWithFormat:@"%@ f",dislivelloReplaceFeet], @"dislivellof", [NSString stringWithFormat:@"%@",distanceReplace], @"distotale", [NSString stringWithFormat:@"%@",duration], @"durata", nil];
              [write writeToFile:[[HLPath shared] logArray] atomically:YES];
              /*ti = 0;
              seconds = 0;
              minutes = 0;
              hours = 0;*/

              NSDateFormatter *dateFormatter1 = [[[NSDateFormatter alloc] init] autorelease];    
              [dateFormatter1 setLocale: [NSLocale currentLocale]]; 
            [dateFormatter1 setDateStyle:kCFDateFormatterMediumStyle];
            [dateFormatter1 setTimeStyle:kCFDateFormatterNoStyle];   
              NSString* dataString = [dateFormatter1 stringFromDate:[NSDate date]];
              [[highestAppDelegate get].list addObject:[NSString stringWithFormat:@"track_%d", number_total]];
              [[highestAppDelegate get].dates addObject:[NSString stringWithFormat:@"%@",dataString]];
              number_total+=1;
              [[NSUserDefaults standardUserDefaults] setInteger:number_total forKey:@"track_total"];
              [[NSUserDefaults standardUserDefaults] synchronize];
              [[NSFileManager defaultManager] createFileAtPath:[[HLPath shared] meterFilePath] contents:nil attributes:nil];
              //[[highestAppDelegate get].list sortUsingSelector:@selector(localizedCompare:)];

            //Ricreo Ambiente            
          } else {
              [[NSFileManager defaultManager] removeItemAtPath:[[HLPath shared] meterFilePath] error:nil];
              [[NSFileManager defaultManager] createFileAtPath:[[HLPath shared] meterFilePath] contents:nil attributes:nil];
              [[NSFileManager defaultManager] removeItemAtPath:[[HLPath shared] dataFilePath] error:nil];
              [[NSFileManager defaultManager] removeItemAtPath:[[HLPath shared] dataGpxFilePath] error:nil];
              [[NSFileManager defaultManager] removeItemAtPath:[[HLPath shared] dataCsvFilePath] error:nil];
              [[NSFileManager defaultManager] removeItemAtPath:[[HLPath shared] moveTrackPath] error:nil];
              [[NSFileManager defaultManager] removeItemAtPath:[[HLPath shared] moveAltPath] error:nil];
              [[NSFileManager defaultManager] removeItemAtPath:[[HLPath shared] lockFilePath] error:nil];
              [[NSFileManager defaultManager] removeItemAtPath:[[HLPath shared] moveKmlPath] error:nil];
              [[NSFileManager defaultManager] removeItemAtPath:[[HLPath shared] moveGpxPath] error:nil];
              [[NSFileManager defaultManager] removeItemAtPath:[[HLPath shared] moveCsvPath] error:nil];
              [[NSFileManager defaultManager] removeItemAtPath:[[HLPath shared] emptyFilePath] error:nil];
              [[NSFileManager defaultManager] removeItemAtPath:[[HLPath shared] lockFilePath] error:nil];
          }
            self.locManager.delegate = nil;
            [self.locManager stopUpdatingLocation];
         //   [self.locManager dealloc];
            [locManager release];
            [self.locationz removeAllObjects];
            locationOffline = YES;
            NSLog(@"Location stoppata e rilasciata");
            [self spinEnd];
            [accu1 setHidden:YES];
            [accu2 setHidden:YES];
            [accu3 setHidden:YES];
            [accu4 setHidden:YES];
            [accu5 setHidden:YES];	
            
            min = 0;
            max = 0;
            altmin = 0;
            altmedia = 0;
            altmediaFeet = 0;
            forzacheck = 0;
            firstRecord = 0;
            altitudeRecord =0;
            checkThreeData =0;
            // myIntAlt = 0;
            myLastAltitude =@"";
            altitudine.text =@"";
            altitudineFeet.text =@"";
            myoldlatitude = @"";
            latitudine.text =@"";
            myoldlongitude =@"";
            longitudine.text =@"";

            startingPoint = nil;
            totalDistanceTraveled = 0;
            totaldistance.text =@"0.00km";
            altitudine.text =@"";
            altitudineFeet.text=@"";
            latitudine.text =@"";
            latitudineExt.text=@"";
            longitudine.text=@"";
            longitudineExt.text=@"";
            [stop setHidden:YES];
            [play setHidden:NO];
        } else if (buttonIndex == 1) {
           // [self spinEnd];
            myTimer = [NSTimer scheduledTimerWithTimeInterval:35 target:self selector:@selector(reversing) userInfo:NULL repeats:YES];

        }
    }
}
//v3.0


// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller 
		  didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {	
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark
#pragma mark start-pause-stop
-(IBAction)stopPress:(id)sender{
        [myTimer invalidate];
        [self stopTrack];
}

-(IBAction)playPress:(id)sender{
	
        self.locManager = [[CLLocationManager alloc] init];
        
        //definisco delegate x accedere ai suoi metodi
        self.locManager.delegate = self;
        
        //controllo presenza magnetometro
        if (locManager.headingAvailable) {
            [locManager startUpdatingHeading];
            ismagne = YES;
        } else {
            ismagne = NO;
        }
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
        setGps  = [defaults floatForKey:kGps] ;
        if ((setGps >= 0) && (setGps < 5))
        {
            //locManager.distanceFilter = 5.0f;
            locManager.desiredAccuracy = kCLLocationAccuracyBest;
        } else if ((setGps >= 3) && (setGps <7))
        {
            locManager.distanceFilter = 20.0f;
            locManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        }else if ((setGps >= 7) && (setGps <=10))
        {
            locManager.distanceFilter = 50.0f;
            locManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        }
        [[self locManager] startUpdatingLocation];
        NSLog(@"playPress: Location Startata");
		[mp setHidden:NO];
		[citta setHidden:NO];
		[self spinBegin];
        myTimer = [NSTimer scheduledTimerWithTimeInterval:35 target:self selector:@selector(reversing) userInfo:NULL repeats:YES];
        locationOffline = NO;
        [play setEnabled:NO];
        NSArray *docPathss = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDirectory = [docPathss objectAtIndex:0];
        NSString *srcPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"track.kml"];
        NSString *destPath = [docDirectory stringByAppendingPathComponent:@"mytrack.kml"];	
        NSError *err;
        NSString *srcPathgpx = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"track.gpx"];
        NSString *destPathgpx = [docDirectory stringByAppendingPathComponent:@"mytrack.gpx"];		NSError *errgpx;
        NSString *srcPathcsv = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"track.csv"];
        NSString *destPathcsv = [docDirectory stringByAppendingPathComponent:@"mytrack.csv"];NSError *errcsv;
        [[NSFileManager defaultManager] copyItemAtPath:srcPathcsv toPath:destPathcsv error:&errcsv];			
        NSLog(@"Start_mytrack: csv BASE importato: path %@", destPathcsv);
        [[NSFileManager defaultManager] copyItemAtPath:srcPathgpx toPath:destPathgpx error:&errgpx];			
        NSLog(@"Start_mytrack: gpx BASE importato: path %@", destPathgpx);
        [[NSFileManager defaultManager] copyItemAtPath:srcPath toPath:destPath error:&err];	
        NSLog(@"Start_mytrack: kml BASE importato: path %@", destPath);
        NSError *erra;
        [[NSFileManager defaultManager] moveItemAtPath:destPath toPath:[[HLPath shared] moveKmlPath] error:&erra];
        [[NSFileManager defaultManager] moveItemAtPath:destPathgpx toPath:[[HLPath shared] moveGpxPath] error:&erra];
        [[NSFileManager defaultManager] moveItemAtPath:destPathcsv toPath:[[HLPath shared] moveCsvPath] error:&erra];
        [[NSFileManager defaultManager] removeItemAtPath:[[HLPath shared] meterFilePath] error:&erra];
        [[NSFileManager defaultManager] createFileAtPath:[[HLPath shared] meterFilePath] contents:nil attributes:nil];
        [[NSFileManager defaultManager] createFileAtPath: [[HLPath shared] lockFilePath] contents:nil attributes:nil];
        [[NSFileManager defaultManager] createFileAtPath:[[HLPath shared] dataFilePath] contents:nil attributes:nil];
        [[NSFileManager defaultManager] createFileAtPath:[[HLPath shared] dataGpxFilePath] contents:nil attributes:nil];
        [[NSFileManager defaultManager] createFileAtPath:[[HLPath shared] dataCsvFilePath] contents:nil attributes:nil];
        [[NSFileManager defaultManager] createFileAtPath:[[HLPath shared] moveTrackPath] contents:nil attributes:nil];
        [[NSFileManager defaultManager] createFileAtPath:[[HLPath shared] moveAltPath] contents:nil attributes:nil];
        [[NSFileManager defaultManager] createFileAtPath: [[HLPath shared] emptyFilePath] contents:nil attributes:nil];
	}

#pragma mark
#pragma mark activityView

- (void)initSpinner {
	actView = [[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(195.0, 8.0, 30.0, 30.0) ] autorelease];    
	actView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
	[actView hidesWhenStopped];
	[self.view addSubview:actView];
}

- (void)spinBegin {
	[actView startAnimating];
	[accu1 setHidden:YES];
	[accu2 setHidden:YES];
	[accu3 setHidden:YES];
	[accu4 setHidden:YES];
	[accu5 setHidden:YES];	
}

- (void)spinEnd {
	[actView stopAnimating];
	[accu1 setHidden:NO];
	[accu2 setHidden:NO];
	[accu3 setHidden:NO];
	[accu4 setHidden:NO];
	[accu5 setHidden:NO];
	
}

#pragma mark
#pragma mark Facebook
- (IBAction)postGradesTapped:(id)sender {
	_posting = YES;	
	// If we're not logged in, log in first...
	if (![_session isConnected]) {
		self.loginDialog = nil;
		_loginDialog = [[FBLoginDialog alloc] init];	
		[_loginDialog show];	
	}
	// If we have a session and a name, post to the wall!
	else if (_facebookName != nil) {
		[self postToWall];
	}
	// Otherwise, we don't have a name yet, just wait for that to come through.
}

- (IBAction)logoutButtonTapped:(id)sender {
	[_session logout];
}

- (void)session:(FBSession*)session didLogin:(FBUID)uid {
	[self getFacebookName];
}

- (void)session:(FBSession*)session willLogout:(FBUID)uid {
	_logoutButton.hidden = YES;
	_facebookName = nil;
}


- (void)getFacebookName {
	NSString* fql = [NSString stringWithFormat:
					 @"select uid,name from user where uid == %lld", _session.uid];
	NSDictionary* params = [NSDictionary dictionaryWithObject:fql forKey:@"query"];
	[[FBRequest requestWithDelegate:self] call:@"facebook.fql.query" params:params];
}

#pragma mark FBRequestDelegate methods

- (void)request:(FBRequest*)request didLoad:(id)result {
	if ([request.method isEqualToString:@"facebook.fql.query"]) {
		NSArray* users = result;
		NSDictionary* user = [users objectAtIndex:0];
		NSString* name = [user objectForKey:@"name"];
		self.facebookName = name;		
		_logoutButton.hidden = NO;
		[_logoutButton setTitle:[NSString stringWithFormat:@"Facebook: Logout as %@", name] forState:UIControlStateNormal];
		if (_posting) {
			[self postToWall];
			_posting = NO;
		}
	}
}

- (void)postToWall {
	
	FBStreamDialog* dialog = [[[FBStreamDialog alloc] init] autorelease];
	dialog.userMessagePrompt = [NSString stringWithFormat:@"%@", NSLocalizedString(@"fbmsgprompt", @"")];
    
    
	NSString *mex = [[NSString alloc] initWithFormat:
					 @"{ \"name\":\"%@ %@ %@ %@ %@ %@!\"," "\"media\":[{\"type\":\"image\"," "\"src\":\"http://maps.google.com/maps/api/staticmap?size=191x191&markers=color:blue|label:Hello|%@,%@&zoom=15&mobile=true&sensor=false\"," "\"href\":\"http://itunes.apple.com/it/app/high-altimeter-and-stuff/id368770019?mt=8\"}],}",
					 _facebookName, NSLocalizedString(@"fbwhere", @""), citta.text, NSLocalizedString(@"fbtraver", @""),totaldistance.text, NSLocalizedString(@"fbwith", @""),latitudine.text, longitudine.text ];
	
	dialog.attachment = mex;
	dialog.actionLinks = [NSString stringWithFormat:@"%@", NSLocalizedString(@"dwnkey", @"")];
	[dialog show];
}

@end

