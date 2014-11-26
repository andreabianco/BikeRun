//
//  BRTravellingViewController.m
//  BikeRun
//
//  Created by Alex De Biasi on 23/10/14.
//  Copyright (c) 2014 mad. All rights reserved.
//

#import "BRTravellingViewController.h"
#import "BRSharedVariables.h"
@interface BRTravellingViewController ()

@end

@implementation BRTravellingViewController

BRSharedVariables *sharedManager;
MKRoute *routeDetails;

- (void)viewDidLoad {
   [super viewDidLoad];
//    // Do any additional setup after loading the view.
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    sharedManager = [BRSharedVariables sharedVariablesManager];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.mapView.delegate = self;
    CLAuthorizationStatus status=[CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status==kCLAuthorizationStatusAuthorized || status==kCLAuthorizationStatusAuthorizedAlways) {
        [self.locationManager stopUpdatingLocation];
        [self.locationManager startUpdatingLocation];
        // self.mapView.showsUserLocation = YES;
        
    }
    else{
        
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            //[self.locationManager requestWhenInUseAuthorization];
            [self.locationManager requestAlwaysAuthorization];
        }
       }
    NSMutableArray *destinations=sharedManager.destList;
    for (int i=0; i<destinations.count; i++) {
        routeDetails=destinations[i];
        [self.mapView addOverlay:routeDetails.polyline];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status==kCLAuthorizationStatusAuthorized || status==kCLAuthorizationStatusAuthorizedAlways) {
        [self.locationManager stopUpdatingLocation];
        [self.locationManager startUpdatingLocation];
        //self.mapView.showsUserLocation = YES;
    }
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    self.mapView.showsUserLocation = YES;
    [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
    NSLog(@"%f aaaa %f",self.mapView.userLocation.location.coordinate.latitude, self.mapView.userLocation.location.coordinate.longitude);
    
}

-(void) show_message{
    NSString *message = @"You are going in the wrong direction! Please come back.";
    NSString *cancel = @"Ok";
    
    UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:cancel
                                          otherButtonTitles:nil, nil];
    [toast show];
    int duration = 5; // duration in seconds
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [toast dismissWithClickedButtonIndex:0 animated:YES];
    });
}

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    MKPolylineRenderer  * routeLineRenderer = [[MKPolylineRenderer alloc] initWithPolyline:routeDetails.polyline];
    routeLineRenderer.strokeColor = [UIColor blueColor];
    routeLineRenderer.lineWidth = 3;
    return routeLineRenderer;
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
