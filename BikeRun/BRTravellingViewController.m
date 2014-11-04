//
//  BRTravellingViewController.m
//  BikeRun
//
//  Created by Alex De Biasi on 23/10/14.
//  Copyright (c) 2014 mad. All rights reserved.
//

#import "BRTravellingViewController.h"

@interface BRTravellingViewController ()

@end

@implementation BRTravellingViewController

- (void)viewDidLoad {
   [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    self.locationManager = [[CLLocationManager alloc] init];
//    self.locationManager.delegate = self;
//    self.mapView.delegate = self;
//    //Qua dovrebbe fare la chiamata e apparire l'alert da accettare, ma non accade.
//    //  [self requestAlwaysAuthorization];
//    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
//    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
//        [self.locationManager requestWhenInUseAuthorization];
//    }
//    [self.locationManager startUpdatingLocation];
    self.mapView.delegate = self;
    
    
    //Instantiate a location object.
    self.locationManager = [[CLLocationManager alloc] init];
    
    //Make this controller the delegate for the location manager.
    [self.locationManager setDelegate:self];
    
    //Set some parameters for the location object.
    [self.locationManager setDistanceFilter:kCLDistanceFilterNone];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    // Request use on iOS 8
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        // Ensure that you can view your own location in the map view.
        [self.mapView setShowsUserLocation:YES];
    } else {
        [self.locationManager requestWhenInUseAuthorization];
    }
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager startUpdatingLocation];
         self.mapView.showsUserLocation = YES;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
