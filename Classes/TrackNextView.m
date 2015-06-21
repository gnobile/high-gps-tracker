//
//  TrackNextView.m
//  highest
//
//  Created by Giorgio Nobile on 05/02/12.
//  Copyright (c) 2012 ZeroNetAPP. All rights reserved.
//

#import "TrackNextView.h"
#import "PushMapViewController.h"
#import "GraphDetail.h"
#import "DetailTrack.h"
#import "HLPath.h"

@implementation TrackNextView
@synthesize tableView;
NSString *titolo;
NSString *fullPathToFileAlt;
int sectone = 0;
int donekml = 0;
int donegpx = 0;
int donecsv = 0;
int twosect = 0;



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

-(IBAction)changeProductText:(NSString *)det {
    titolo = det;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    
    self.tableView.frame = self.view.bounds;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    self.navigationItem.title =[NSString stringWithFormat:@"%@", NSLocalizedString(@"kDettaglio", @"")];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.tableView = nil;
}

-(void) dealloc {
    [tableView release];
    [titolo release];
    [fullPathToFileAlt release];
    [super dealloc];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    sectone = 0;
    donekml = 0;
    donegpx = 0;
    donecsv = 0;
    twosect = 0;

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *docsPath = [paths objectAtIndex:0]; 
    NSString *temp = [docsPath stringByAppendingPathComponent:titolo];
    if ([[NSFileManager defaultManager] fileExistsAtPath:[temp stringByAppendingPathExtension:@"kml"]]) {
        return 3;
    } else {
        return 2;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return [NSString stringWithFormat:@"%@", NSLocalizedString(@"kNomeTraccia", @"")];
            break;
        case 1:
            return [NSString stringWithFormat:@"%@", NSLocalizedString(@"kEsportaTraccia", @"")];
            break;
        case 2:
            return [NSString stringWithFormat:@"%@", NSLocalizedString(@"kVisualizzaTraccia", @"")];
            break;
        default:
            return nil;
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *docsPath = [paths objectAtIndex:0]; 
    NSString *temp1 = [docsPath stringByAppendingPathComponent:@"PushAlt"];
    fullPathToFileAlt = [temp1 stringByAppendingPathComponent:titolo];
    NSString *temp = [docsPath stringByAppendingPathComponent:titolo];
    NSString *existKml = [temp stringByAppendingPathExtension:@"kml"];
    NSString *existGpx = [temp stringByAppendingPathExtension:@"gpx"];
    NSString *existCsv = [temp stringByAppendingPathExtension:@"csv"];

    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            if ([[NSFileManager defaultManager] fileExistsAtPath:existKml]){
                sectone += 1;
                donekml +=1;
            }
            if ([[NSFileManager defaultManager] fileExistsAtPath:existGpx]){
                sectone += 1;
                donegpx +=1;
            }
            if ([[NSFileManager defaultManager] fileExistsAtPath:existCsv]){
                sectone += 1;
                donecsv +=1;
            }
            return sectone;
            break;
        case 2:
            if ([[NSFileManager defaultManager] fileExistsAtPath:[temp stringByAppendingPathExtension:@"kml"]]) {
                twosect +=1;
            }
            if ([[NSFileManager defaultManager] fileExistsAtPath:fullPathToFileAlt]) {
                twosect +=1;
            }
                return twosect;
                break;
        default:
            return nil;
            break;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    sectone =0;
    twosect =0;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *docsPath = [paths objectAtIndex:0]; 
    NSString *temp = [docsPath stringByAppendingPathComponent:titolo];
    NSString *temp1 = [docsPath stringByAppendingPathComponent:@"PushAlt"];
    NSString *pathAlt = [temp1 stringByAppendingPathComponent:titolo];
    NSString *priva = [docsPath stringByAppendingPathComponent:@"Details"];
    NSString *detailPath = [priva stringByAppendingPathComponent:titolo];
    NSString *detail = [detailPath stringByAppendingPathExtension:@"plist"];

    static NSString *CellIdentifier = @"CellDettaglio";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    if (indexPath.section == 0) {
        cell.textLabel.text = titolo;
        if (![[NSFileManager defaultManager] fileExistsAtPath:detail]) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        } else {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; 
        }

    }
    if (indexPath.section == 1) {
        if (([[NSFileManager defaultManager] fileExistsAtPath:[temp stringByAppendingPathExtension:@"kml"]]) && (donekml > 0)) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@", NSLocalizedString(@"kExpKML", @"")];
            donekml = 0;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; 
            cell.tag = 1;
        }
        else if (([[NSFileManager defaultManager] fileExistsAtPath:[temp stringByAppendingPathExtension:@"gpx"]]) && (donegpx > 0)){
            cell.textLabel.text =[NSString stringWithFormat:@"%@", NSLocalizedString(@"kExpGPX", @"")];
            donegpx = 0;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; 
            cell.tag = 2;
        }
        else if (([[NSFileManager defaultManager] fileExistsAtPath:[temp stringByAppendingPathExtension:@"csv"]]) && (donecsv > 0)){
            cell.textLabel.text =[NSString stringWithFormat:@"%@", NSLocalizedString(@"kExpCSV", @"")];
            donecsv = 0;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; 
            cell.tag = 3;
        }
    }
    if (indexPath.section == 2) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:[temp stringByAppendingPathExtension:@"kml"]] && (indexPath.row == 0)){
            cell.textLabel.text =[NSString stringWithFormat:@"%@", NSLocalizedString(@"kVtrack", @"")];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; 
            cell.imageView.image = [UIImage imageNamed:@"map_layer.png"];
            cell.tag =4;
        }
        if ([[NSFileManager defaultManager] fileExistsAtPath:pathAlt] && (indexPath.row == 1)){
            cell.textLabel.text =[NSString stringWithFormat:@"%@", NSLocalizedString(@"kValt", @"")];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; 
            cell.imageView.image = [UIImage imageNamed:@"graph.png"];
            cell.tag = 5;
        }
    }

    return cell;
}

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *docsPath = [paths objectAtIndex:0]; 
    NSString *priva = [docsPath stringByAppendingPathComponent:@"Details"];
    NSString *detailPath = [priva stringByAppendingPathComponent:titolo];
    NSString *detail = [detailPath stringByAppendingPathExtension:@"plist"];

    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if ((indexPath.section == 0) && ([[NSFileManager defaultManager] fileExistsAtPath:detail])) {
        DetailTrack *detController = [[DetailTrack alloc] initWithNibName:@"DetailTrack" bundle:nil];
        [self.navigationController pushViewController:detController animated:YES];
        [detController nomeTraccia:titolo];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    /*if ((indexPath.section == 0) && ([[NSFileManager defaultManager] fileExistsAtPath:detail])) {
        DetTrack *detController = [[DetTrack alloc] initWithNibName:@"DetTrack" bundle:nil];
        [self.navigationController pushViewController:detController animated:YES];
       // [detController nomeTraccia:titolo];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }*/

    if ((indexPath.section == 1) && (cell.tag == 3)) {
        [self displayComposerSheetCsv];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    }
    if ((indexPath.section == 1) && (cell.tag == 2)) {
        [self displayComposerSheetGpx];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    }
    if ((indexPath.section == 1) && (cell.tag == 1)) {
        [self displayComposerSheetKml];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    }
    
    //if ((indexPath.section == 2) && (indexPath.row == 0)) {
    if ((indexPath.section == 2) && (cell.tag == 4)) {

        PushMapViewController *nextController = [[PushMapViewController alloc] initWithNibName:@"PushMapViewController" bundle:nil];
        [self.navigationController pushViewController:nextController animated:YES];
        [nextController nomeTraccia:titolo];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    }
    //if ((indexPath.section == 2) && (indexPath.row == 1)) {
    if ((indexPath.section == 2) && (cell.tag == 5)) {

        GraphDetail *graphContorller = [[GraphDetail alloc] initWithNibName:@"GraphDetail" bundle:nil];
        [self.navigationController pushViewController:graphContorller animated:YES];
        [graphContorller nomeTraccia:titolo];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    }

}

#pragma mark - MFMail delegate
- (void)mailComposeController:(MFMailComposeViewController*)controller 
		  didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {	
	[self dismissModalViewControllerAnimated:YES];
}


-(void)displayComposerSheetCsv
{	
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    [picker setSubject:@"Tracking MySelf!"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                        NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path1 = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.csv", titolo]];
    NSLog(@"PAth csv %@", path1);
    NSString *det = [documentsDirectory stringByAppendingPathComponent:@"Details"];
    NSString *dett = [det stringByAppendingPathComponent:titolo];
    NSString *dettaglio = [dett stringByAppendingPathExtension:@"plist"];
    NSData *myData1 = [NSData dataWithContentsOfFile:path1];
    [picker addAttachmentData:myData1 mimeType:@"text/xml" fileName:[NSString stringWithFormat:@"%@.csv", titolo]];

    NSString *emailBody;
    if (![[NSFileManager defaultManager] fileExistsAtPath:dettaglio]) {
        emailBody = NSLocalizedString(@"bodykeycsv", @"");
    } else {
        NSDictionary *print = [[NSDictionary alloc] initWithContentsOfFile:dettaglio];
        emailBody = NSLocalizedString(@"bodykeystatscsv", @"");
        emailBody = [NSString stringWithFormat:emailBody, [print valueForKey:@"date"], [print valueForKey:@"startime"], [print valueForKey:@"stoptime"], [print valueForKey:@"dislivello"], [print valueForKey:@"distotale"], [print valueForKey:@"durata"]];
    }
    [picker setMessageBody:emailBody isHTML:YES];
    [self presentModalViewController:picker animated:YES];
    [picker release];
}

-(void)displayComposerSheetKml
{	
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    [picker setSubject:@"Tracking MySelf!"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *documentsDirectory = [paths objectAtIndex:0];    
    NSString *path1 = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.kml", titolo]];
    NSString *det = [documentsDirectory stringByAppendingPathComponent:@"Details"];
    NSString *dett = [det stringByAppendingPathComponent:titolo];
    NSString *dettaglio = [dett stringByAppendingPathExtension:@"plist"];
    NSData *myData1 = [NSData dataWithContentsOfFile:path1];
    [picker addAttachmentData:myData1 mimeType:@"text/xml" fileName:[NSString stringWithFormat:@"%@.kml", titolo]];
    NSString *emailBody;
    if (![[NSFileManager defaultManager] fileExistsAtPath:dettaglio]) {
        emailBody = NSLocalizedString(@"bodykeykml", @"");
    } else {
        NSDictionary *print = [[NSDictionary alloc] initWithContentsOfFile:dettaglio];
        emailBody = NSLocalizedString(@"bodykeystatskml", @"");
        emailBody = [NSString stringWithFormat:emailBody, [print valueForKey:@"date"], [print valueForKey:@"startime"], [print valueForKey:@"stoptime"], [print valueForKey:@"dislivello"], [print valueForKey:@"distotale"], [print valueForKey:@"durata"]];

    }
    [picker setMessageBody:emailBody isHTML:YES];
    [self presentModalViewController:picker animated:YES];
    [picker release];
}

-(void)displayComposerSheetGpx
{	
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    [picker setSubject:@"Tracking MySelf!"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path1 = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.gpx", titolo]];
    NSString *det = [documentsDirectory stringByAppendingPathComponent:@"Details"];
    NSString *dett = [det stringByAppendingPathComponent:titolo];
    NSString *dettaglio = [dett stringByAppendingPathExtension:@"plist"];
    NSData *myData1 = [NSData dataWithContentsOfFile:path1];
    [picker addAttachmentData:myData1 mimeType:@"text/xml" fileName:[NSString stringWithFormat:@"%@.gpx", titolo]];
    NSString *emailBody;
    if (![[NSFileManager defaultManager] fileExistsAtPath:dettaglio]) {
        emailBody = NSLocalizedString(@"bodykey", @"");
    } else {
        NSDictionary *print = [[NSDictionary alloc] initWithContentsOfFile:dettaglio];
        emailBody = NSLocalizedString(@"bodykeystats", @"");
        emailBody = [NSString stringWithFormat:emailBody, [print valueForKey:@"date"], [print valueForKey:@"startime"], [print valueForKey:@"stoptime"], [print valueForKey:@"dislivello"], [print valueForKey:@"distotale"], [print valueForKey:@"durata"]];
    }
    [picker setMessageBody:emailBody isHTML:YES];
    [self presentModalViewController:picker animated:YES];
    [picker release];
}


@end
