//
//  BRTravellingViewController.m
//  BikeRun
//
//  Created by Alex De Biasi on 23/10/14.
//  Copyright (c) 2014 mad. All rights reserved.
//

#import "BRTravellingViewController.h"
#import "BRSharedVariables.h"
#import "BRMathOperation.h"

@interface BRTravellingViewController ()
@property int seconds;
@property float distance;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSMutableArray *locations; //store the percurred way.
@end

@implementation BRTravellingViewController

BRSharedVariables *sharedManager;
MKRoute *routeDetails;

- (void)viewDidLoad {
   [super viewDidLoad];
//    // Do any additional setup after loading the view.
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //PROVVISORI QUESTI SON DA TOGLIERE NELLA VERSIONE FINALE E INIZIALIZZARE OPPORTUNAMENTE
    sharedManager = [BRSharedVariables sharedVariablesManager];
    _distance=0;//ora son inizializzati a 0 poi saranno da mettere alla quantità raggiunta
    _seconds=0;
    ///////////////////
    
    //initialize the timer that call function eachSecond
    self.timer = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self selector:@selector(eachSecond) userInfo:nil repeats:YES];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 10; //used to have a good treshold if the person is
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
    
    //print of the guide-line
    NSMutableArray *destinations=sharedManager.destList;
    for (int i=0; i<destinations.count; i++) {
        routeDetails=destinations[i];
        routeDetails.polyline.title=@"1";
        [self.mapView addOverlay:routeDetails.polyline];
    }
    
}

- (void) viewWillDisappear:(BOOL)animated //used to stop the timer and update of label if view is dismissed
{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
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
    for (CLLocation *newLocation in locations) {
        
        NSDate *eventDate = newLocation.timestamp;
        
        NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
        
        if (abs(howRecent) < 10.0 && newLocation.horizontalAccuracy < 20) {
            
            // update distance
            if (self.locations.count > 0) {
                self.distance += [newLocation distanceFromLocation:self.locations.lastObject];
                
                CLLocationCoordinate2D coords[2];
                coords[0] = ((CLLocation *)self.locations.lastObject).coordinate;
                coords[1] = newLocation.coordinate;
                
                MKCoordinateRegion region =
                MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 500, 500);
                [self.mapView setRegion:region animated:YES];
                
                [self.mapView addOverlay:[MKPolyline polylineWithCoordinates:coords count:2]];
            }
            
            [self.locations addObject:newLocation];
        }
    }
//    [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
//    NSLog(@"%f aaaa %f",self.mapView.userLocation.location.coordinate.latitude, self.mapView.userLocation.location.coordinate.longitude);
    
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
    //if is guideline paint blu
    if ([routeDetails.polyline.title isEqualToString:@"1"]) {
        MKPolylineRenderer  * routeLineRenderer = [[MKPolylineRenderer alloc] initWithPolyline:routeDetails.polyline];
        routeLineRenderer.strokeColor = [UIColor blueColor];
        routeLineRenderer.lineWidth = 3;
        return routeLineRenderer;
    }
    //else is the road that the user is percurring so black print
    MKPolylineRenderer  * routeLineRenderer = [[MKPolylineRenderer alloc] initWithPolyline:routeDetails.polyline];
    routeLineRenderer.strokeColor = [UIColor blackColor];
    routeLineRenderer.lineWidth = 3;
    return routeLineRenderer;
    
}

/*! function that update trascurred time and labels on screen*/
- (void)eachSecond
{
    self.seconds++;
    [self updateLabels];
}

- (void)updateLabels
{
    self.timeLabel.text = [NSString stringWithFormat:@"Time: %@",  [BRMathOperation stringifySecondCount:self.seconds usingLongFormat:NO]];
    self.distLabel.text = [NSString stringWithFormat:@"Distance: %@", [BRMathOperation stringifyDistance:self.distance]];
    self.paceLabel.text = [NSString stringWithFormat:@"Pace: %@",  [BRMathOperation stringifyAvgPaceFromDist:self.distance overTime:self.seconds]];
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
