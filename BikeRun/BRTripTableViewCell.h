//
//  BRTripTableViewCell.h
//  BikeRun
//
//  Created by Andrea Bianco on 11/08/14.
//  Copyright (c) 2014 mad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BRTripTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *partenzaLabel;
@property (nonatomic, strong) IBOutlet UILabel *arrivoLabel;
@property (nonatomic, weak) IBOutlet UILabel *distanceLabel;

@end
