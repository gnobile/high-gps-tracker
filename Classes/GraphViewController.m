//
//  RootViewController.m
//  DemoS7GraphView
//
//  Created by Rudi Farkas on 20.12.09.
//  Copyright Wolfscliff 2009. All rights reserved.
//

// It clips negative y values to 0
// It autoscales y to the max y over all plots

#import "GraphViewController.h"
#import "FirstViewController.h"

@implementation GraphViewController

@synthesize graphView;
NSString *fullPathToFile;
NSString *speed;

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	
	//self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	//self.graphView = [[S7GraphView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.graphView = [[S7GraphView alloc] initWithFrame:CGRectZero];
	self.view = self.graphView;
	self.graphView.dataSource = self;
	self.view.backgroundColor = [UIColor yellowColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

	NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
	[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	[numberFormatter setMinimumFractionDigits:0];
	[numberFormatter setMaximumFractionDigits:0];
	
	self.graphView.yValuesFormatter = numberFormatter;
	
	NSDateFormatter *dateFormatter = [NSDateFormatter new];
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	
	self.graphView.xValuesFormatter = dateFormatter;
	
	[dateFormatter release];        
	[numberFormatter release];
	
	self.graphView.backgroundColor = [UIColor blackColor]; //black
	
	self.graphView.drawAxisX = YES;
	self.graphView.drawAxisY = YES;
	self.graphView.drawGridX = YES;
	self.graphView.drawGridY = YES;
	
	self.graphView.xValuesColor = [UIColor whiteColor]; //white
	self.graphView.yValuesColor = [UIColor yellowColor];//white
	
	self.graphView.gridXColor = [UIColor whiteColor];
	self.graphView.gridYColor = [UIColor blueColor]; //white
	
	self.graphView.drawInfo = YES;
	self.graphView.info = [NSString stringWithFormat:@"%@" , NSLocalizedString(@"altkey", @"")];
	self.graphView.infoColor = [UIColor yellowColor]; //white
	self.graphView.userInteractionEnabled = YES;
	graphView.multipleTouchEnabled = YES;
	
	//When you need to update the data, make this call:
	
	//[self.graphView reloadData];
	
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	//[self.graphView reloadData];
	[self.graphView reloadData];


	
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/


 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	//return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}
 

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release anything that can be recreated in viewDidLoad or on demand.
	// e.g. self.myOutlet = nil;
	graphView = nil;
}


- (void)dealloc {
	[graphView release];
    [super dealloc];
}

#pragma mark protocol S7GraphViewDataSource

- (NSUInteger)graphViewNumberOfPlots:(S7GraphView *)graphView {
	/* Return the number of plots you are going to have in the view. 1+ */

	return 2;
}

- (NSArray *)graphViewXValues:(S7GraphView *)graphView {
	// An array of objects that will be further formatted to be displayed on the X-axis.
	// The number of elements should be equal to the number of points you have for every plot. 
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [NSString stringWithFormat:@"%@/Priv/", [paths objectAtIndex:0]];
	
	fullPathToFile = [documentsDirectory stringByAppendingPathComponent:@"altezza.csv"];
    
	NSString* fileContents = [NSString stringWithContentsOfFile:fullPathToFile];
	NSArray* pointStrings = [fileContents  componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	NSMutableArray* array = [NSMutableArray arrayWithCapacity:pointStrings.count];
	
    NSUInteger i;
	if (pointStrings.count >2) {
        for ( i = 0; i < pointStrings.count; i++ ) {
            [array addObject:[pointStrings objectAtIndex:0]];
		}
	}
	return array;

}


- (NSArray *)graphView:(S7GraphView *)graphView yValuesForPlot:(NSUInteger)plotIndex {
	//Return the values for a specific graph. Each plot is meant to have equal number of points.
//	 And this amount should be equal to the amount of elements you return from graphViewXValues: method.*
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [NSString stringWithFormat:@"%@/Priv", [paths objectAtIndex:0]];
	
    fullPathToFile = [documentsDirectory stringByAppendingPathComponent:@"altezza.csv"];
	
	NSString* fileContents = [NSString stringWithContentsOfFile:fullPathToFile];
	NSArray* pointStrings = [fileContents  componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	NSMutableArray *array = [[NSMutableArray alloc] initWithArray:pointStrings];
	
    return array;
}

- (void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)
toInterfaceOrientation duration:(NSTimeInterval)duration {
	// Change graphview.frame to make it a litle smaller
	self.graphView.frame = CGRectMake(50, 150, 200, 200);
	[self.graphView reloadData];
	
}

@end

