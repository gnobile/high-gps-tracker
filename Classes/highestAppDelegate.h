//
//  highestAppDelegate.h
//  highest
//
//  Created by Giorgio Nobile on 06/05/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface highestAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate>{
    UIWindow *window;
    UITabBarController *tabBarController;
	//NSDateFormatter *datex;
	//NSString *datax;
	//NSDateFormatter *giornex;
	//NSString *giornox;
    NSMutableArray *list;
    NSMutableArray *dates;
}

+ (highestAppDelegate *)get;



@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain)  NSMutableArray *list;
@property (nonatomic, retain)  NSMutableArray *dates;



@end
