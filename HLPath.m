//
//  HLPath.m
//  highest
//
//  Created by Giorgio Nobile on 09/06/11.
//  Copyright 2011 ZeroNetAPP. All rights reserved.
//

#import "HLPath.h"


@implementation HLPath

/*NSDateFormatter * datex;
NSDateFormatter * giornex;
NSString *datax;
NSString *giornox;*/
int number_kml = 1;
int number_csv = 1; 
int number_gpx = 1;
int number_total;



static HLPath *shAccess = nil;

+ (HLPath *) shared {
    if (!shAccess) {
        shAccess = [[HLPath alloc] init];
    }
    return shAccess;
}

- (id) init {
    /*datex = [[[NSDateFormatter alloc] init] autorelease];
	[datex setDateFormat:@"dd_MM_yyyy_HH_mm_"];
	datax = [datex stringFromDate:[NSDate date]];
	
	giornex = [[[NSDateFormatter alloc]init] autorelease];
	[giornex setDateFormat:@"ddMMyyyy"];
	giornox = [giornex stringFromDate:[NSDate date]];*/
    number_kml = [[NSUserDefaults standardUserDefaults] integerForKey:@"track_kml"];
    number_gpx = [[NSUserDefaults standardUserDefaults] integerForKey:@"track_gpx"];
    number_csv = [[NSUserDefaults standardUserDefaults] integerForKey:@"track_csv"];
    number_total = [[NSUserDefaults standardUserDefaults] integerForKey:@"track_total"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    return self;
}

//one shoot start

- (NSString *)dataFilePath_1 { 
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [paths objectAtIndex:0]; 
	return [documentsDirectory stringByAppendingPathComponent:@"rottina.csv"];	
}

- (NSString *)dataGpxFilePath_1 { 
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [paths objectAtIndex:0]; 
	return [documentsDirectory stringByAppendingPathComponent:@"rottina_gpx.csv"];	
}

- (NSString *)dataCsvFilePath_1 { 
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [paths objectAtIndex:0]; 
	return [documentsDirectory stringByAppendingPathComponent:@"rottina_csv.csv"];	
}


- (NSString *)meterFilePath_1 { 
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [paths objectAtIndex:0]; 
	return [documentsDirectory stringByAppendingPathComponent:@"altezza.csv"];
}

- (NSString *)gpxFilePath_1 {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [paths objectAtIndex:0]; 
	return [documentsDirectory stringByAppendingPathComponent:@"mytrack.gpx"];	
}

- (NSString *)kmlFilePath_1 {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [paths objectAtIndex:0]; 
	return [documentsDirectory stringByAppendingPathComponent:@"mytrack.kml"];
}	
- (NSString *)csvFilePath_1 {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [paths objectAtIndex:0]; 
	return [documentsDirectory stringByAppendingPathComponent:@"mytrack.csv"];
}	

- (NSString *)kmlExport_1 {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [paths objectAtIndex:0]; 
	return [documentsDirectory stringByAppendingPathComponent:@"e_mytrack.kml"];
}
- (NSString *)gpxExport_1 {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [paths objectAtIndex:0]; 
	return [documentsDirectory stringByAppendingPathComponent:@"e_mytrack.gpx"];
}	
- (NSString *)csvExport_1 {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [paths objectAtIndex:0]; 
	return [documentsDirectory stringByAppendingPathComponent:@"e_mytrack.csv"];
}	


// one shoot end


- (NSString *)dataFilePath { 
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [NSString stringWithFormat:@"%@/Priv", [paths objectAtIndex:0]];
	return [documentsDirectory stringByAppendingPathComponent:@"rottina.csv"];	
}

- (NSString *)dataGpxFilePath { 
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [NSString stringWithFormat:@"%@/Priv", [paths objectAtIndex:0]];
	return [documentsDirectory stringByAppendingPathComponent:@"rottina_gpx.csv"];	
}

- (NSString *)dataCsvFilePath { 
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [NSString stringWithFormat:@"%@/Priv", [paths objectAtIndex:0]];
	return [documentsDirectory stringByAppendingPathComponent:@"rottina_csv.csv"];	
}


- (NSString *)meterFilePath { 
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [NSString stringWithFormat:@"%@/Priv", [paths objectAtIndex:0]];
	return [documentsDirectory stringByAppendingPathComponent:@"altezza.csv"];
}

- (NSString *)gpxFilePath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [NSString stringWithFormat:@"%@/Priv", [paths objectAtIndex:0]];
	return [documentsDirectory stringByAppendingPathComponent:@"mytrack.gpx"];	
}

- (NSString *)kmlFilePath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [NSString stringWithFormat:@"%@/Priv", [paths objectAtIndex:0]];
	return [documentsDirectory stringByAppendingPathComponent:@"mytrack.kml"];
}	
- (NSString *)csvFilePath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [NSString stringWithFormat:@"%@/Priv", [paths objectAtIndex:0]];
	return [documentsDirectory stringByAppendingPathComponent:@"mytrack.csv"];
}	

- (NSString *)kmlExport {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [NSString stringWithFormat:@"%@/Priv", [paths objectAtIndex:0]];
	return [documentsDirectory stringByAppendingPathComponent:@"e_mytrack.kml"];
}
- (NSString *)gpxExport {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [NSString stringWithFormat:@"%@/Priv", [paths objectAtIndex:0]];
	return [documentsDirectory stringByAppendingPathComponent:@"e_mytrack.gpx"];
}	
- (NSString *)csvExport {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [NSString stringWithFormat:@"%@/Priv", [paths objectAtIndex:0]];
	return [documentsDirectory stringByAppendingPathComponent:@"e_mytrack.csv"];
}	
/*
- (NSString *)moveKmlPath { 
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [paths objectAtIndex:0]; 
	//NSString *tempfile = [datax stringByAppendingString:@"track.kml"];
    NSString *tempfile =@"track.kml";
	return [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%d_%@", number_total, tempfile]];  
}*/
- (NSString *)moveKmlPath { 
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [paths objectAtIndex:0]; 
    //NSString *tempfile =@"track.kml";
	return [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"track_%d.kml", number_total]];  
}


- (NSString *)moveGpxPath { 
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [paths objectAtIndex:0]; 
    //NSString *tempfile =@"track.gpx";
	return [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"track_%d.gpx", number_total]];   
}

- (NSString *)moveCsvPath { 
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [paths objectAtIndex:0]; 
    //NSString *tempfile =@"track.csv";
	return [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"track_%d.csv", number_total]];    
}

- (NSString *)moveTrackPath { 
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [NSString stringWithFormat:@"%@/PushTrack", [paths objectAtIndex:0]];
   // NSString *tempfile =@"track";
	return [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"track_%d", number_total]];    
}

- (NSString *)moveAltPath { 
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [NSString stringWithFormat:@"%@/PushAlt", [paths objectAtIndex:0]];
   // NSString *tempfile =@"track";
	return [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"track_%d", number_total]];    
}
- (NSString *)lockFilePath { 
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [NSString stringWithFormat:@"%@/Priv", [paths objectAtIndex:0]];
	return [documentsDirectory stringByAppendingPathComponent:@"lock"];	
}
- (NSString *)emptyFilePath { 
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [NSString stringWithFormat:@"%@/Priv", [paths objectAtIndex:0]];
	return [documentsDirectory stringByAppendingPathComponent:@"empty"];	
}

- (NSString *)logArray { 
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [NSString stringWithFormat:@"%@/Details", [paths objectAtIndex:0]];
	return [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"track_%d.plist", number_total]];    
}

-(void)generateKmlToShare { 
    //[[NSFileManager defaultManager] moveItemAtPath:[[HLPath shared] kmlFilePath] toPath:[[HLPath shared] moveKmlPath] error:nil];
    
    NSString *klm = [NSString stringWithFormat:@"</coordinates>\n        </LineString>\n        </MultiGeometry>\n    </Placemark>\n  </Document>\n</kml>"];
    NSData *klmData = [klm dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSFileHandle *writeKlm = [NSFileHandle fileHandleForWritingAtPath:[[HLPath shared] moveKmlPath]];
    
    [writeKlm truncateFileAtOffset:[writeKlm seekToEndOfFile]];
    [writeKlm writeData:klmData];
    [writeKlm closeFile];
    
    [[NSFileManager defaultManager] removeItemAtPath:[[HLPath shared] dataFilePath]  error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:[[HLPath shared] meterFilePath]  error:nil];
    
}	

-(void)generateGpxToShare {    
    
    NSString *gpx = [NSString stringWithFormat:@"\t\t</trkseg>\n\t</trk><\n</gpx>"];
    NSData *gpxData = [gpx dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSFileHandle *writeGpx = [NSFileHandle fileHandleForWritingAtPath:[[HLPath shared] moveGpxPath]];
    [writeGpx truncateFileAtOffset:[writeGpx seekToEndOfFile]];
    [writeGpx writeData:gpxData];
    [writeGpx closeFile];
    
    [[NSFileManager defaultManager] removeItemAtPath: [[HLPath shared] dataGpxFilePath] error:nil];
    
}	

-(void)generateCsvToShare {
    
    [[NSFileManager defaultManager] removeItemAtPath: [[HLPath shared] dataCsvFilePath] error:nil];
    
}	





@end
