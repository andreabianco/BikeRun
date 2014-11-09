//
//  BRTourListViewController.h
//  BikeRun
//
//  Created by Andrea Bianco on 09/11/14.
//  Copyright (c) 2014 mad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import "BREditTourViewController.h"

@interface BRTourListViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,EditTourViewControllerDelegate>

- (IBAction)addTour:(id)sender;

@property (strong, nonatomic) IBOutlet UITableView *tblTours;

@property (strong,nonatomic) DBManager *dbManager;

@end
