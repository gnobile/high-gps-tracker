//
//  GraphDetail.h
//  highest
//
//  Created by Giorgio Nobile on 13/02/12.
//  Copyright (c) 2012 ZeroNetAPP. All rights reserved.
//
#import "S7GraphView.h"
#import "MBProgressHUD.h"

@interface GraphDetail : UIViewController <S7GraphViewDataSource> {
	S7GraphView *graphView;
	MBProgressHUD *HUD;
}

+ (GraphDetail *)shared;
-(IBAction)nomeTraccia:(NSString *)det;

@property (nonatomic, retain) S7GraphView *graphView;

@end