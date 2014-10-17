//
//  BREditStepViewController.h
//  BikeRun
//
//  Created by Andrea on 15/10/14.
//  Copyright (c) 2014 mad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@protocol EditStepViewControllerDelegate
-(void)editingStepWasFinished;
@end

@interface BREditStepViewController : UIViewController

@property (strong,nonatomic) DBManager *dbManager;

@property (weak, nonatomic) IBOutlet UITextField *txtLong;
@property (weak, nonatomic) IBOutlet UITextField *txtLat;
@property (weak, nonatomic) IBOutlet UITextField *txtDesc;

@property (nonatomic,strong) id<EditStepViewControllerDelegate> delegate;
@property (nonatomic) int recordIDToEdit;

- (IBAction)saveStep:(id)sender;

-(void)loadStepToEdit;

@end
