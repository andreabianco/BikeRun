//
//  StepListTableViewController.h
//  TourPart
//
//  Created by Andrea on 29/11/14.
//  Copyright (c) 2014 Andrea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditStepViewController.h"
#import "Step.h"

@protocol EditStepListTableViewControllerDelegate

-(void)editingWasFinished:(NSMutableArray*)data;

@end

@interface StepListTableViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,EditStepViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (nonatomic) int idTour;
@property (nonatomic) int idStepToEdit;
@property (nonatomic,strong) NSMutableArray *arrSteps;
@property (nonatomic,strong) NSDictionary *dictStep;
@property (nonatomic,strong) id<EditStepListTableViewControllerDelegate> delegate;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)addStep:(id)sender;
- (IBAction)saveFromStepList:(id)sender;


@end
