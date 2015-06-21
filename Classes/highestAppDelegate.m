//
//  highestAppDelegate.m
//  highest
//
//  Created by Giorgio Nobile on 06/05/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "highestAppDelegate.h"
#import "FirstViewController.h"
#import "HLPath.h"
#import "Appirater.h"
#import "FlurryAnalytics.h"



@implementation highestAppDelegate

@synthesize window;
@synthesize tabBarController, list, dates; 
NSString *lastFile;
NSString *lastFileNumber;
int number_total;
bool DEBUG = NO;

+ (highestAppDelegate *)get {
    return (highestAppDelegate *) [[UIApplication sharedApplication] delegate];
}


/*
- (void)applicationDidFinishLaunching:(UIApplication *)application {
    [window addSubview:tabBarController.view];
	//[self dataFilePath];
    //[window makeKeyAndVisible];
}*/
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions { 
   /* for (NSString *family in [UIFont familyNames]) {
        NSLog(@"%@", [UIFont fontNamesForFamilyName:family]);
    }*/
    [window addSubview:tabBarController.view];
    [window makeKeyAndVisible];
    [Appirater appLaunched];
    [FlurryAnalytics startSession:@"<FLURRY_ANALITYC_ID>"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];


    number_total = [[NSUserDefaults standardUserDefaults] integerForKey:@"track_total"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    if (DEBUG) {
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"track_kml"];
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"track_gpx"];
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"track_csv"];
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"track_total"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstTime"];
    }
    //END DEBUG
    int number_kml = [[NSUserDefaults standardUserDefaults] integerForKey:@"track_kml"];
    int number_gpx = [[NSUserDefaults standardUserDefaults] integerForKey:@"track_gpx"];
    int number_csv = [[NSUserDefaults standardUserDefaults] integerForKey:@"track_csv"];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstTime"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstTime"];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
        NSString *docsPaths = [paths objectAtIndex:0]; 
        NSString *createDir = [docsPaths stringByAppendingPathComponent:@"Priv"]; 
        NSString *createDir1 = [docsPaths stringByAppendingPathComponent:@"PushTrack"];    
        NSString *createDir2 = [docsPaths stringByAppendingPathComponent:@"PushAlt"]; 
        NSString *createDir3 = [docsPaths stringByAppendingPathComponent:@"Details"]; 
        NSString *removeSaves = [docsPaths stringByAppendingPathComponent:@"saves"]; 

        [[NSFileManager defaultManager] createDirectoryAtPath:createDir 
                                  withIntermediateDirectories:NO 
                                                   attributes:nil
                                                        error:NULL]; 
        [[NSFileManager defaultManager] createDirectoryAtPath:createDir1
                                  withIntermediateDirectories:NO 
                                                   attributes:nil
                                                        error:NULL]; 
        [[NSFileManager defaultManager] createDirectoryAtPath:createDir2 
                                  withIntermediateDirectories:NO 
                                                   attributes:nil
                                                        error:NULL]; 
        [[NSFileManager defaultManager] createDirectoryAtPath:createDir3
                                  withIntermediateDirectories:NO 
                                                   attributes:nil
                                                        error:NULL]; 
        //rimuovo old se esistono
        [[NSFileManager defaultManager] removeItemAtPath:removeSaves error:nil];
        [[NSFileManager defaultManager] removeItemAtPath: [[HLPath shared] kmlExport_1] error:nil];
        [[NSFileManager defaultManager] removeItemAtPath: [[HLPath shared] gpxExport_1] error:nil];
        [[NSFileManager defaultManager] removeItemAtPath: [[HLPath shared] csvExport_1] error:nil];
        
        [[NSFileManager defaultManager] removeItemAtPath: [[HLPath shared] kmlFilePath_1] error:nil];
        [[NSFileManager defaultManager] removeItemAtPath: [[HLPath shared] gpxFilePath_1] error:nil];
        [[NSFileManager defaultManager] removeItemAtPath: [[HLPath shared] csvFilePath_1] error:nil];
        
        [[NSFileManager defaultManager] removeItemAtPath: [[HLPath shared] dataGpxFilePath_1] error:nil];
        [[NSFileManager defaultManager] removeItemAtPath: [[HLPath shared] dataCsvFilePath_1] error:nil];
        [[NSFileManager defaultManager] removeItemAtPath: [[HLPath shared] dataFilePath_1] error:nil];
        [[NSFileManager defaultManager] removeItemAtPath: [[HLPath shared] meterFilePath_1] error:nil];
        //e muovo        
        for (NSString *file in [[NSFileManager defaultManager]
                                contentsOfDirectoryAtPath:docsPaths error:NULL]) {
            BOOL isDir;
            BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@", docsPaths, file] isDirectory:&isDir];
            if (exists) {
                if (!isDir) {
                    NSString *ext = [file pathExtension];
                    if ([ext isEqualToString:@"kml"]) {
                        [[NSFileManager defaultManager] moveItemAtPath:[NSString stringWithFormat:@"%@/%@", docsPaths, file] toPath:[NSString stringWithFormat:@"%@/track_%d.%@", docsPaths, number_kml, ext] error:nil];
                        number_kml +=1;
                        [[NSUserDefaults standardUserDefaults] setInteger:number_kml forKey:@"track_kml"];
                    }
                    if ([ext isEqualToString:@"gpx"]) {
                        [[NSFileManager defaultManager] moveItemAtPath:[NSString stringWithFormat:@"%@/%@", docsPaths, file] toPath:[NSString stringWithFormat:@"%@/track_%d.%@", docsPaths, number_gpx, ext] error:nil];
                        number_gpx +=1;
                        [[NSUserDefaults standardUserDefaults] setInteger:number_gpx forKey:@"track_gpx"];
                    }
                    if ([ext isEqualToString:@"csv"]) {
                        [[NSFileManager defaultManager] moveItemAtPath:[NSString stringWithFormat:@"%@/%@", docsPaths, file] toPath:[NSString stringWithFormat:@"%@/track_%d.%@", docsPaths, number_csv, ext] error:nil];
                        number_csv +=1;
                        [[NSUserDefaults standardUserDefaults] setInteger:number_csv forKey:@"track_csv"];
                    }
                    if (![[file stringByDeletingPathExtension] isEqualToString:[lastFileNumber stringByDeletingPathExtension]]){
                        number_total +=1;
                        lastFileNumber = file;

                    }  

                }
            }
        }
        number_total +=1;
        [[NSUserDefaults standardUserDefaults] setInteger:number_total forKey:@"track_total"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSFileManager defaultManager] createFileAtPath:[[HLPath shared] meterFilePath] contents:nil attributes:nil];
    }else {
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:[[HLPath shared] emptyFilePath]]) {
            [[NSFileManager defaultManager] removeItemAtPath:[[HLPath shared] meterFilePath] error:nil];
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

        if ([[NSFileManager defaultManager] fileExistsAtPath:[[HLPath shared] lockFilePath]]) {
            [[HLPath shared] generateKmlToShare];
            [[HLPath shared] generateGpxToShare];
            [[HLPath shared] generateCsvToShare];
            NSError *err;
            [[NSFileManager defaultManager] removeItemAtPath:[[HLPath shared] lockFilePath] error:&err];
            number_total+=1;
            [[NSUserDefaults standardUserDefaults] setInteger:number_total forKey:@"track_total"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:[[HLPath shared] meterFilePath]]){
        [[NSFileManager defaultManager] removeItemAtPath:[[HLPath shared] meterFilePath] error:nil];
        [[NSFileManager defaultManager] createFileAtPath:[[HLPath shared] meterFilePath] contents:nil attributes:nil];
    }
    list = [[NSMutableArray alloc] init];
    dates = [[NSMutableArray alloc] init];
    
    NSError *error;
    NSError *error1;
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *docsPathe = [path objectAtIndex:0]; 
    for (NSString *file in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:docsPathe error:&error]) {
        NSString *fileFrom = [docsPathe stringByAppendingPathComponent:file];
        NSDictionary* properties = [[NSFileManager defaultManager]
                                    attributesOfItemAtPath:fileFrom
                                    error:&error1];
        NSDate* modDate = [properties objectForKey:NSFileModificationDate];        
        NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];    
        [dateFormatter setLocale: [NSLocale currentLocale]];    
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        NSString* dateString = [dateFormatter stringFromDate:modDate];
        
        
        BOOL isDir;
        BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@", docsPathe, file] isDirectory:&isDir];
        if (exists && !isDir && ![file hasPrefix:@"."]) {
            if (![[file stringByDeletingPathExtension] isEqualToString:[lastFile stringByDeletingPathExtension]]){
                [list addObject:[file stringByDeletingPathExtension]];                
                [dates addObject:dateString];
                lastFile = file;
            }  
        }
    }
    //[list sortUsingSelector:@selector(localizedCompare:)];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
	
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}



/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewControl
 
 
 ler {
}
*/

/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/

-(void)applicationWillTerminate:(UIApplication *)application{
    
		
}


- (void)dealloc {
    [tabBarController release];
    [window release];
    [super dealloc];
}
@end

