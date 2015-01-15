//
//  EditTourViewController.h
//  TourPart
//
//  Created by Andrea on 23/11/14.
//  Copyright (c) 2014 Andrea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StepListTableViewController.h"
#import <CoreData/CoreData.h>
#import "Tour.h"
#import "Step.h"

@protocol EditTourViewControllerDelegate

-(void)editingTourWasFinished;

@end

@interface EditTourViewController : UIViewController <EditStepListTableViewControllerDelegate, UIActionSheetDelegate>

- (IBAction)backToEditTour:(id)sender;
- (IBAction)saveTour:(id)sender;
- (IBAction)deleteTour:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *deleteBtt;
@property (weak, nonatomic) IBOutlet UIProgressView *progress_bar;

@property (weak, nonatomic) IBOutlet UITextField *txtNome;
@property (strong, nonatomic) IBOutlet UITextField *txtDesc;
@property (nonatomic) int tourToEdit;
@property (nonatomic,strong) id<EditTourViewControllerDelegate> delegate;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong) Tour *tour;

@end
