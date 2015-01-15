//
//  ShowStepMapViewController.h
//  TourPart
//
//  Created by Andrea Bianco on 07/12/14.
//  Copyright (c) 2014 Andrea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ShowStepMapViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *name;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)changeMapType:(id)sender;

@end
