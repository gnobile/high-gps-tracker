//
//  TrackNextView.h
//  highest
//
//  Created by Giorgio Nobile on 05/02/12.
//  Copyright (c) 2012 ZeroNetAPP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>


@interface TrackNextView : UIViewController <UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate> {
   IBOutlet UITableView *tableView;
    
}
-(IBAction)changeProductText:(NSString *)det;
-(void)displayComposerSheetKml;
-(void)displayComposerSheetGpx;
-(void)displayComposerSheetCsv;

@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end
