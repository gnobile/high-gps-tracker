//
//  CustomCell.m
//  highest
//
//  Created by Giorgio Nobile on 23/01/12.
//  Copyright (c) 2012 ZeroNetAPP. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

@synthesize custDetLabel, custImage, custLabel;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
