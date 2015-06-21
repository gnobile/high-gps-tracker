//
//  FirstViewController.h
//  highss
//
//  Created by Giorgio Nobile on 08/06/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h> 
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import <MapKit/MKReverseGeocoder.h>
#import "FBConnect/FBConnect.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>




#define kAutolock		@"autolock"
#define kUnit			@"unit"
#define kGps			@"gps"
#define kCoord			@"coord"


//includo il framework x accesso alle funzionalità gps, mappa e FB

@interface FirstViewController : 
UIViewController <MFMailComposeViewControllerDelegate, CLLocationManagerDelegate, MKReverseGeocoderDelegate, MKAnnotation, MKMapViewDelegate, FBSessionDelegate, FBRequestDelegate, UIActionSheetDelegate> {

	CLLocationManager	*locManager; 
	//accedo delegate methods di cllocman e setto var per
	//istanziale cllocmanager
	CLLocation	*startingPoint; //prendo il punto di partenza
	UILabel *latitudine;
	UILabel *longitudine;
	UILabel *degreeLat;
	UILabel *degreeLon;
	UILabel *latitudineExt;
	UILabel *longitudineExt;
	UILabel *altitudine;	
	UILabel *altitudineFeet;
	UILabel *altitudineWeb;
	UILabel *citta;
	UILabel *mp;
	UILabel *totaldistance;
	UIImageView *dir;
	UIImageView *accu1;
	UIImageView *accu2;
	UIImageView *accu3;
	UIImageView *accu4;
	UIImageView *accu5;
	MKReverseGeocoder *geoCoder;
	UIButton *play;
    UIButton *stop;
	UIActivityIndicatorView *actView;
	NSMutableArray *locationz;
	//FB Def
	FBSession* _session;
	FBLoginDialog *_loginDialog;
	UIButton *_postGradesButton;
	UIButton *_logoutButton;
	NSString *_facebookName;
	BOOL _posting;
	
}


@property (assign, nonatomic) CLLocationManager *locManager;
@property (retain, nonatomic) CLLocation *startingPoint;
@property (retain, nonatomic) IBOutlet UILabel *degreeLat;
@property (retain, nonatomic) IBOutlet UILabel *degreeLon;
@property (retain, nonatomic) IBOutlet UILabel *latitudine;
@property (retain, nonatomic) IBOutlet UILabel *longitudine;
@property (retain, nonatomic) IBOutlet UILabel *latitudineExt;
@property (retain, nonatomic) IBOutlet UILabel *longitudineExt;
@property (retain, nonatomic) IBOutlet UILabel *altitudine;
@property (retain, nonatomic) IBOutlet UILabel *altitudineFeet;
@property (retain, nonatomic) IBOutlet UILabel *altitudineWeb;
@property (retain, nonatomic) IBOutlet UILabel *citta;
@property (retain, nonatomic) IBOutlet UILabel *totaldistance;
@property (nonatomic,retain) IBOutlet UILabel *mp;
@property (retain, nonatomic) IBOutlet UIImageView *dir;
@property (nonatomic,retain) IBOutlet UIImageView *accu1;
@property (nonatomic,retain) IBOutlet UIImageView *accu2;
@property (nonatomic,retain) IBOutlet UIImageView *accu3;
@property (nonatomic,retain) IBOutlet UIImageView *accu4;
@property (nonatomic,retain) IBOutlet UIImageView *accu5;
@property (nonatomic, retain) IBOutlet UIButton *play;
@property (nonatomic, retain) IBOutlet UIButton *stop;
@property (nonatomic, retain) MKReverseGeocoder *geoCoder;
@property (nonatomic, retain) UIActivityIndicatorView *actView;
@property (nonatomic, retain) NSMutableArray *locationz;



//FB Property
@property (nonatomic, retain) FBSession *session;
@property (nonatomic, retain) IBOutlet UIButton *postGradesButton;
@property (nonatomic, retain) IBOutlet UIButton *logoutButton;
@property (nonatomic, retain) FBLoginDialog *loginDialog;
@property (nonatomic, copy) NSString *facebookName;
@property (nonatomic, assign) BOOL posting;

-(void)reversing;
//-(void)displayComposerSheet;
//-(IBAction)emailTo:(id)sender;
//-(IBAction)updating:(id)sender;
//-(IBAction)showActionSheet:(id)sender;
-(void)stopTrack;
- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation
			fromLocation:(CLLocation *)oldLocation;

/*-(void)generateKmlToShare;
-(void)generateGpxToShare;
-(void)generateCsvToShare;
-(void)displayComposerSheetGpx;
-(void)displayComposerSheetKml;
-(void)displayComposerSheetCsv;*/
-(IBAction)playPress:(id)sender;
-(IBAction)stopPress:(id)sender;


//animation method
- (void)initSpinner;
- (void)spinBegin;
- (void)spinEnd;



//FB Method
- (IBAction)postGradesTapped:(id)sender;
- (IBAction)logoutButtonTapped:(id)sender;
- (void)postToWall;
- (void)getFacebookName;


@end
