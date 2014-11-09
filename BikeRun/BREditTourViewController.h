//
//  BREditTourViewController.h
//  BikeRun
//
//  Created by Andrea Bianco on 09/11/14.
//  Copyright (c) 2014 mad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@protocol EditTourViewControllerDelegate
-(void)editingTourWasFinished;
@end

@interface BREditTourViewController : UIViewController

- (IBAction)saveTour:(id)sender;
-(void)loadTourToEdit;

@property (strong, nonatomic) IBOutlet UITextField *txtNameTour;

@property (strong, nonatomic) DBManager *dbManager;
@property (nonatomic, strong) id<EditTourViewControllerDelegate> delegate;
@property (nonatomic) int recordToEdit;

@end
