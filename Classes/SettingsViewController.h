//
//  SettingsViewController.h
//  highest
//
//  Created by Giorgio Nobile on 20/02/12.
//  Copyright (c) 2012 ZeroNetAPP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICustomSwitch.h"



@interface SettingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    UISwitch *caca;
	UISwitch *unit;
	UISwitch *coord;
	UISlider *gps;
    UITableView *tableView;
    /*UICustomSwitch *caca;
    UICustomSwitch *unit;
    UICustomSwitch *coord;*/
    
    
}

@property (nonatomic, retain) IBOutlet UISwitch *caca;
@property (nonatomic, retain) IBOutlet UISwitch *unit;
@property (nonatomic, retain) IBOutlet UISwitch *coord;
/*@property (nonatomic, retain) IBOutlet UICustomSwitch *caca;
@property (nonatomic, retain) IBOutlet UICustomSwitch *unit;
@property (nonatomic, retain) IBOutlet UICustomSwitch *coord;*/

@property (nonatomic, retain) IBOutlet UISlider *gps;
@property (nonatomic, retain) IBOutlet UITableView *tableView;


@end

