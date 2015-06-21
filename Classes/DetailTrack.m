//
//  DetailTrack.m
//  highest
//
//  Created by Giorgio Nobile on 24/02/12.
//  Copyright (c) 2012 ZeroNetAPP. All rights reserved.
//

#import "DetailTrack.h"
#import "FirstViewController.h"


@implementation DetailTrack
@synthesize tableView;
NSString *titolo, *date, *timeStart, *timeStop, *dislivello, *dislivelloF, *distT, *durata;
NSDictionary *print;
bool UNIT;

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
-(IBAction)nomeTraccia:(NSString *)det {
    titolo = det;
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self.view addSubview:self.tableView];
    
    //self.tableView.frame = self.view.bounds;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    self.navigationItem.title =[NSString stringWithFormat:@"%@", NSLocalizedString(@"dStatistiche", @"")];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    //self.tableView = nil;
    //self.title = nil;
}
-(void)dealloc{
    //[tableView release];
    //[titolo release];
    [super dealloc];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    UNIT = [def boolForKey:kUnit];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *docsPath = [paths objectAtIndex:0]; 
    NSString *priva = [docsPath stringByAppendingPathComponent:@"Details"];
    NSString *detailPath = [priva stringByAppendingPathComponent:titolo];
    NSString *detail = [detailPath stringByAppendingPathExtension:@"plist"];
    print = [[NSDictionary alloc] initWithContentsOfFile:detail];
    date = [print valueForKey:@"date"];
    timeStart = [print valueForKey:@"startime"];
    timeStop = [print valueForKey:@"stoptime"];
    dislivello = [print valueForKey:@"dislivello"];
    dislivelloF = [print valueForKey:@"dislivellof"];
    distT = [print valueForKey:@"distotale"];
    durata = [print valueForKey:@"durata"];
    [self.tableView reloadData];

}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark TableViewDelegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TrackDetail";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@", NSLocalizedString(@"dData", @"")];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.text = date;

    }
    if (indexPath.row == 1) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@", NSLocalizedString(@"dStart", @"")];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.text =timeStart;
    }
    if (indexPath.row == 2) {
        cell.textLabel.text =[NSString stringWithFormat:@"%@", NSLocalizedString(@"dStop", @"")];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.text =timeStop;
    }
    if (indexPath.row == 3) {
        cell.textLabel.text =[NSString stringWithFormat:@"%@", NSLocalizedString(@"dDurata", @"")];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.text =durata;
    }
    if (indexPath.row == 4) {
        cell.textLabel.text =[NSString stringWithFormat:@"%@", NSLocalizedString(@"dDislivello", @"")];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (UNIT){
            cell.detailTextLabel.text =dislivello;
        } else {
            cell.detailTextLabel.text = dislivelloF;
        }
    }    
    if (indexPath.row == 5) {
        cell.textLabel.text =[NSString stringWithFormat:@"%@", NSLocalizedString(@"dDistanza", @"")];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", distT];
        cell.detailTextLabel.text = distT;

    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

@end
