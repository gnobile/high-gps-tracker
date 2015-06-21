//
//  SettingsViewController.m
//  highest
//
//  Created by Giorgio Nobile on 20/02/12.
//  Copyright (c) 2012 ZeroNetAPP. All rights reserved.
//

#import "SettingsViewController.h"
#import "FirstViewController.h"


@implementation SettingsViewController

@synthesize caca;
@synthesize unit;
@synthesize coord;
@synthesize gps;
@synthesize tableView;


- (id) initWithStyle:(UITableViewStyle) style {
    if (self = [super initWithNibName:nil bundle:nil]) {
        //      tableView = [[self tableViewWithStyle:style] retain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.tableView.frame = self.view.bounds;
    self.navigationItem.title = [NSString stringWithFormat:@"%@", NSLocalizedString(@"sTitolo", @"")];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
	//switch gestione autolock
    
    /*caca = [[UICustomSwitch alloc] initWithFrame:CGRectZero];
    //[caca setCenter:CGPointMake(160.0f,260.0f)];
    [[caca leftLabel] setText:@"ON"];
    [[caca rightLabel] setText:@"OFF"];
    [[caca rightLabel] setFont:[UIFont fontWithName:@"Georgia" size:13.0f]];
    [[caca leftLabel] setFont:[UIFont fontWithName:@"Georgia" size:13.0f]];

    unit = [[UICustomSwitch alloc] initWithFrame:CGRectZero];
    //[caca setCenter:CGPointMake(160.0f,260.0f)];
    [[unit leftLabel] setText:@"Meter"];
    [[unit rightLabel] setText:@"Feet"];
    [[unit rightLabel] setFont:[UIFont fontWithName:@"Georgia" size:8.0f]];
    [[unit leftLabel] setFont:[UIFont fontWithName:@"Georgia" size:8.0f]];

    coord = [[UICustomSwitch alloc] initWithFrame:CGRectZero];
    //[caca setCenter:CGPointMake(160.0f,260.0f)];
    [[coord leftLabel] setText:@"DD"];
    [[coord rightLabel] setText:@"DMS"];
    [[coord rightLabel] setFont:[UIFont fontWithName:@"Georgia" size:16.0f]];
    [[coord leftLabel] setFont:[UIFont fontWithName:@"Georgia" size:16.0f]];*/

    

	caca.on = [defaults boolForKey:kAutolock];
	//switch gestione unità misura
	coord.on = [defaults boolForKey:kCoord];
	//switch gestione visualizzazione coordinate
	unit.on = [defaults boolForKey:kUnit];
	//switch precisione gps
	gps.value = [defaults floatForKey:kGps];
    if (caca.on) {
		UIApplication *lockStat = [UIApplication sharedApplication];
		lockStat.idleTimerDisabled = NO;
		//NSLog(@"Autolock Abilitato");
	}
	else { 
		UIApplication *lockStat = [UIApplication sharedApplication];
		lockStat.idleTimerDisabled = YES;
		//NSLog(@"Autolock Disabilitato");
	}	
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
	//switch gestione autolock
    
	caca.on = [defaults boolForKey:kAutolock];
	//switch gestione unità misura
	coord.on = [defaults boolForKey:kCoord];
	//switch gestione visualizzazione coordinate
	unit.on = [defaults boolForKey:kUnit];
	//switch precisione gps
	gps.value = [defaults floatForKey:kGps];
    if (caca.on) {
		UIApplication *lockStat = [UIApplication sharedApplication];
		lockStat.idleTimerDisabled = NO;
	}
	else { 
		UIApplication *lockStat = [UIApplication sharedApplication];
		lockStat.idleTimerDisabled = YES;
	}	

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool:caca.on forKey:kAutolock]; 
	[defaults setBool:unit.on forKey:kUnit]; 
	[defaults setBool:coord.on forKey:kCoord]; 
	[defaults setFloat:gps.value forKey:kGps];
	[defaults synchronize];
    if (caca.on) {
        UIApplication *lockStat = [UIApplication sharedApplication];
		lockStat.idleTimerDisabled = NO;

    } else {
        UIApplication *lockStat = [UIApplication sharedApplication];
		lockStat.idleTimerDisabled = YES;
    }
    if (unit.on) {
        NSLog(@"Unita' metri");
    } else {
        NSLog(@"Unita' piedi");
    }
    if (coord.on) {
        NSLog(@"Coordinate DD");
        
    } else {
        NSLog(@"Coordinate DSM");
    }
    NSLog(@"GPS SLiders: %f", gps.value);
    

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 3;
            break;
        case 1:
            return 1;
            break;
        default:
            return nil;
            break;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return [NSString stringWithFormat:@"%@", NSLocalizedString(@"sGenerali", @"")];
            break;
        case 1:
            return [NSString stringWithFormat:@"%@", NSLocalizedString(@"sAccu", @"")];
            break;
        default:
            return nil;
            break;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    if ((indexPath.section == 0) && (indexPath.row == 0))  {
        cell.textLabel.text = [NSString stringWithFormat:@"%@", NSLocalizedString(@"sLock", @"")];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        caca = [[UISwitch alloc] initWithFrame:CGRectZero];
        cell.accessoryView = caca;
        //[caca setOn:NO animated:NO];
        [caca setOn:NO animated:NO];
        [caca addTarget:self action:@selector(cacaChange:) forControlEvents:UIControlEventValueChanged];
        [caca release];
        cell.tag = 1;
        
    }
    if ((indexPath.section == 0) && (indexPath.row == 1))  {
            cell.textLabel.text = [NSString stringWithFormat:@"%@", NSLocalizedString(@"sUnit", @"")];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        unit = [[UISwitch alloc] initWithFrame:CGRectZero];
        cell.accessoryView = unit;
        //[unit setOn:NO animated:NO];
        [unit setOn:NO animated:YES];
        [unit addTarget:self action:@selector(coordChange:) forControlEvents:UIControlEventValueChanged];
        [unit release];

            cell.tag = 2;
        }
    if ((indexPath.section == 0) && (indexPath.row == 2))  {
        cell.textLabel.text = [NSString stringWithFormat:@"%@", NSLocalizedString(@"sCoordF", @"")];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        coord = [[UISwitch alloc] initWithFrame:CGRectZero];
        cell.accessoryView = coord;
        //[coord setOn:NO animated:NO];
        [coord setOn:NO animated:YES];
        [coord addTarget:self action:@selector(unitChange:) forControlEvents:UIControlEventValueChanged];
        [coord release];

        cell.tag = 3;
    }
    
    if ((indexPath.section == 1) && (indexPath.row == 0))  {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        gps = [[UISlider alloc] initWithFrame:CGRectZero];
        [cell.contentView addSubview:gps];
        gps.maximumValue=10;
        gps.minimumValue=0;
        gps.minimumValueImage = [UIImage imageNamed:@"b1.png"];
        gps.maximumValueImage = [UIImage imageNamed:@"s1.png"];
        gps.bounds = CGRectMake(0, 0, cell.contentView.bounds.size.width - 10, gps.bounds.size.height);
        gps.center = CGPointMake(CGRectGetMidX(cell.contentView.bounds), CGRectGetMidY(cell.contentView.bounds));
        gps.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        cell.tag = 3;
    }


    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}



- (void) cacaChange:(id)sender {
    //UISwitch* switchControl = sender;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //NSLog( @"CaCaSwitch %@", switchControl.on ? @"ON" : @"OFF" );
    [defaults setBool:caca.on forKey:kAutolock]; 
    [defaults synchronize];
}

- (void) coordChange:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //NSLog( @"Coord Switch %@", switchControl.on ? @"ON" : @"OFF" );
    [defaults setBool:coord.on forKey:kCoord]; 
    [defaults synchronize];    
}
- (void) unitChange:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //NSLog( @"Unit Switch %@", switchControl.on ? @"ON" : @"OFF" );
    [defaults setBool:unit.on forKey:kUnit]; 
    [defaults synchronize];
    
}



@end
