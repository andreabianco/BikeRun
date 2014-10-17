//
//  BRStepLitViewController.h
//  BikeRun
//
//  Created by Andrea on 15/10/14.
//  Copyright (c) 2014 mad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import "BREditStepViewController.h"

@interface BRStepLitViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,EditStepViewControllerDelegate>

@property (nonatomic,strong) DBManager *dbManager;
@property (nonatomic,strong) NSArray *arrSteps;
@property (nonatomic) int recordIdToEdit;

@property (weak, nonatomic) IBOutlet UITableView *tblSteps;

- (IBAction)addNewStep:(id)sender;

- (void)loadData;

@end
