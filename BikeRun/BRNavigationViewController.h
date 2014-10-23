//
//  BRNavigationViewController.h
//  BikeRun
//
//  Created by Alex De Biasi on 16/10/14.
//  Copyright (c) 2014 mad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "DBManager.h"

@interface BRNavigationViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextView *steps;
@property (strong, nonatomic) NSString *allSteps;
@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong,nonatomic) DBManager *dbManager;

@end
