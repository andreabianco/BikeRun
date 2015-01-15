//
//  EditStepViewController.h
//  TourPart
//
//  Created by Andrea on 30/11/14.
//  Copyright (c) 2014 Andrea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Step.h"
#import "Location.h"

@protocol EditStepViewControllerDelegate

-(void)editingStepWasFinished:(Step*)data :(NSNumber*)position;

@end

@interface EditStepViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtAddress;

- (IBAction)saveStep:(id)sender;

@property (nonatomic) int positionStep;
@property (nonatomic,strong) NSDictionary *stepDict;

@property (nonatomic) int idTour;
@property (nonatomic,strong) id<EditStepViewControllerDelegate> delegate;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic) Step *step;

@end
