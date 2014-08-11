//
//  BRTripTableViewCell.m
//  BikeRun
//
//  Created by Andrea Bianco on 11/08/14.
//  Copyright (c) 2014 mad. All rights reserved.
//

#import "BRTripTableViewCell.h"

@implementation BRTripTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
