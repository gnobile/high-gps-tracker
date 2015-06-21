//
//  DetailTrack.h
//  highest
//
//  Created by Giorgio Nobile on 24/02/12.
//  Copyright (c) 2012 ZeroNetAPP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailTrack : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView *tableView;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
-(IBAction)nomeTraccia:(NSString *)det;

@end
