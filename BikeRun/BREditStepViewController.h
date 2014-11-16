//
//  BREditStepViewController.h
//  BikeRun
//
//  Created by Andrea on 15/10/14.
//  Copyright (c) 2014 mad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "DBManager.h"

@protocol EditStepViewControllerDelegate
-(void)editingStepWasFinished:(NSDictionary*)data;
@end

@interface BREditStepViewController : UIViewController <UITextFieldDelegate,MKMapViewDelegate>

@property (strong,nonatomic) DBManager *dbManager;

//@property (weak, nonatomic) IBOutlet UITextField *txtLong;
//@property (weak, nonatomic) IBOutlet UITextField *txtLat;
@property (weak, nonatomic) IBOutlet UITextField *txtDesc;
@property (weak, nonatomic) IBOutlet UITextField *txtAddress;
@property (weak, nonatomic) IBOutlet MKMapView *mapStep;

@property (nonatomic,strong) id<EditStepViewControllerDelegate> delegate;
@property (nonatomic) int recordIDToEdit;
@property (nonatomic) int idTour;

- (IBAction)saveStep:(id)sender;

-(void)loadStepToEdit;
- (IBAction)verifyLocation:(id)sender;

@end
