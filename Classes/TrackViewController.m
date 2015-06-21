//
//  TrackViewController.m
//  highest
//
//  Created by Giorgio Nobile on 19/01/12.
//  Copyright (c) 2012 ZeroNetAPP. All rights reserved.
//

#import "TrackViewController.h"
#import "CustomCell.h"
#import "highestAppDelegate.h"
#import "TrackNextView.h"

@class highestAppDelegate;
@implementation TrackViewController

NSFileManager *fileManager;
NSArray *paths;
NSString *docsPath;
NSString *fileFrom;
int number_total;



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization

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

    self.navigationItem.title =[NSString stringWithFormat:@"%@", NSLocalizedString(@"kPercorsi", @"")];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    number_total =  [[NSUserDefaults standardUserDefaults] integerForKey:@"track_total"];
    [[NSUserDefaults standardUserDefaults] synchronize];


}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void) dealloc {
    [fileManager release];
    [paths release];
    [docsPath release];
    [fileFrom release];
    [super dealloc];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[self tableView] reloadData];

        
    
}
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
//    return [self.list count]; 
    return [[highestAppDelegate get].list count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
   // static NSString *CellIdentifier = @"CustomCell";
 
  /*  
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
        for (id obj in views) {
            if([obj isKindOfClass:[UITableViewCell class]])
            {
                cell = (CustomCell *)obj;
                break;
            }
        }

        //cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }*/
    
    // Configure the cell...
   /* NSDictionary *dictionary = [[highestAppDelegate get].listaTraccia objectAtIndex:indexPath.section];
    
	NSArray *array = [dictionary objectForKey:@"traccia"];
	NSArray *array1  = [dictionary objectForKey:@"data"];
	NSString *cellValue = [array objectAtIndex:indexPath.row];
	NSString *cellDetail = [array1 objectAtIndex:indexPath.row];
    cell.textLabel.text = cellDetail;
	cell.detailTextLabel.text = cellValue;*/

    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton; 
    cell.detailTextLabel.textColor = [UIColor blueColor];
    cell.detailTextLabel.font = [UIFont italicSystemFontOfSize:12];
    cell.detailTextLabel.numberOfLines = 2;
    cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.text = [[highestAppDelegate get].list objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [[highestAppDelegate get].dates objectAtIndex:indexPath.row]; 
    cell.imageView.image = [UIImage imageNamed:@"map_map.png"];

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 46;
}


// Override to support conditional editing of the table view.

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
        docsPath = [paths objectAtIndex:0]; 
        NSString *documentsAlt = [NSString stringWithFormat:@"%@/PushAlt", [paths objectAtIndex:0]];
        NSString *documentsTrack = [NSString stringWithFormat:@"%@/PushTrack", [paths objectAtIndex:0]];
        NSString *details = [NSString stringWithFormat:@"%@/Details", [paths objectAtIndex:0]];
        NSString *temp = [[highestAppDelegate get].list objectAtIndex:indexPath.row];
        NSString *pushAlt = [documentsAlt stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", temp]];    
        NSString *pushTrack = [documentsTrack stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", temp]]; 
        NSString *pushTrackMove = [pushTrack stringByAppendingString:@"_mv"];
        NSString *lastPath = [docsPath stringByAppendingPathComponent:temp];
        NSString *removeDetail = [details stringByAppendingPathComponent:temp];
        NSString *pathKml = [lastPath stringByAppendingPathExtension:@"kml"];
        NSString *pathGpx = [lastPath stringByAppendingPathExtension:@"gpx"];
        NSString *pathCsv = [lastPath stringByAppendingPathExtension:@"csv"];
        [[NSFileManager defaultManager] removeItemAtPath:pathKml error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:pathGpx error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:pathCsv error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:pushAlt error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:pushTrack error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:pushTrackMove error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:removeDetail error:nil];
        // Delete the appropriate object
        [[highestAppDelegate get].list removeObjectAtIndex:indexPath.row];
        [[highestAppDelegate get].dates removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
        //[[highestAppDelegate get].list sortUsingSelector:@selector(localizedCompare:)];
    }   
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
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    TrackNextView *nextController = [[TrackNextView alloc] initWithNibName:@"TrackNextView" bundle:nil];
    [self.navigationController pushViewController:nextController animated:YES];
    [nextController changeProductText:[[highestAppDelegate get].list objectAtIndex:indexPath.row]];

}

@end
