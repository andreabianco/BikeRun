//
//  BRNavigationViewController.m
//  BikeRun
//
//  Created by Alex De Biasi on 16/10/14.
//  Copyright (c) 2014 mad. All rights reserved.
//



#import "BRNavigationViewController.h"
#import "BRSharedVariables.h"

@interface BRNavigationViewController ()

@end

@implementation BRNavigationViewController

MKRoute *routeDetails; //object for route instruction

int iter = 0;
int waypoints=0;
NSMutableDictionary *dest;
BRSharedVariables *sharedManager;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.mapView.delegate = self;
    dest=[[NSMutableDictionary alloc] init];
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"bikerun.sqlite"];
    //Qua dovrebbe fare la chiamata e apparire l'alert da accettare, ma non accade.
  //  [self requestAlwaysAuthorization];
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
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
//    [self.locationManager startUpdatingLocation];
//    self.mapView.showsUserLocation=YES;
    
//    
    }
}

/*!
 commento
 @param placemark Questo è un parametro
 */
- (void)addAnnotation:(CLPlacemark *)placemark {
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = CLLocationCoordinate2DMake(placemark.location.coordinate.latitude, placemark.location.coordinate.longitude);
    point.title = [placemark.addressDictionary objectForKey:@"Street"];
    point.subtitle = [placemark.addressDictionary objectForKey:@"City"];
    [self.mapView addAnnotation:point];
}


- (IBAction)routePressed:(UIBarButtonItem *)sender {
    //method that calculate route
    NSMutableArray *destinazioni=[[NSMutableArray alloc]init];
    MKDirectionsRequest *directionsRequest = [[MKDirectionsRequest alloc] init];
    for (int i=0; i<dest.count-1; i++) {
        [directionsRequest setSource:[dest objectForKey:[NSNumber numberWithInt:i]]];
        MKMapItem *elem =[dest objectForKey:[NSNumber numberWithInt:i]];
        NSLog(@"SetSource:%@",elem.name);
        [directionsRequest setDestination:[dest objectForKey:[NSNumber numberWithInt:i+1]]];
        elem=[dest objectForKey:[NSNumber numberWithInt:i]];
        NSLog(@"Setdest:%@",elem.name);
        directionsRequest.transportType = MKDirectionsTransportTypeWalking;
        MKDirections *directions = [[MKDirections alloc] initWithRequest:directionsRequest];
        [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
            if (error) {
                NSLog(@"Error %@", error.description);
            } else {
                routeDetails = response.routes.lastObject;
                //DA CANCELLARE QUANDO IMP IN DATABASE///////
                sharedManager = [BRSharedVariables sharedVariablesManager];
                [sharedManager.destList addObject:routeDetails];//add the current direction to the array of direction to store it
                ////////////////////////////////////////////
                [self.mapView addOverlay:routeDetails.polyline];
                self.allSteps = @"";
                for (int i = 0; i < routeDetails.steps.count; i++) {
                    MKRouteStep *step = [routeDetails.steps objectAtIndex:i];
                    NSString *newStep = step.instructions;
                    self.allSteps = [self.allSteps stringByAppendingString:newStep];
                    self.allSteps = [self.allSteps stringByAppendingString:@"\n\n"];
                    self.steps.text = self.allSteps;
                }
                NSLog(@"DENTRO:numero elementi %d filled=%@",sharedManager.destList.count,sharedManager.filled);

            }
        }];
        //try to dispaly something
        [self show_message];
    }
}

- (IBAction)destinationPressed:(UIBarButtonItem *)sender {
    [self initDestArray:dest];
}

- (IBAction)clearPressed:(UIBarButtonItem *)sender {
    //method that clear the map (route + pins )
    id userLocation = [self.mapView userLocation];
    NSMutableArray *pins = [[NSMutableArray alloc] initWithArray:[self.mapView annotations]];
    if ( userLocation != nil ) {
        [pins removeObject:userLocation]; // avoid removing user location off the map
    }
    
    [self.mapView removeAnnotations:pins];
    pins = nil;
    self.steps.text = nil;
    [self.mapView removeOverlay:routeDetails.polyline];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[MKPointAnnotation class]]) {
        // Try to dequeue an existing pin view first.
        MKPinAnnotationView *pinView = (MKPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        if (!pinView)
        {
            // If an existing pin view was not available, create one.
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
            pinView.canShowCallout = YES;
        } else {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    return nil;
}

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    MKPolylineRenderer  * routeLineRenderer = [[MKPolylineRenderer alloc] initWithPolyline:routeDetails.polyline];
    routeLineRenderer.strokeColor = [UIColor redColor];
    routeLineRenderer.lineWidth = 5;
    return routeLineRenderer;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*********************************
 *********************************
 METODO PER INIZIALIZZARE LE TAPPE VA POI TOLTO E MI VIENE GIA RESTITUITO L'ARRAY 
 **********************************/

- (void)initDestArray:(NSMutableDictionary *)destinaz{
    NSArray *mete=[[NSArray alloc] initWithObjects:@"Milano", @"Torino", @"Cuneo", @"Savona", @"Firenze", @"Siena", @"Roma", @"Salerno", @"Napoli", @"Reggio Calabria", @"Messina" , nil];
    
    NSString *query = @"select * from stepTour";
    NSArray *arrSteps;
    // Get the results.
    if (arrSteps != nil) {
        arrSteps = nil;
    }
    arrSteps = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    NSInteger indexOfAddress = [self.dbManager.arrColumnNames indexOfObject:@"address"];
    
    
    for (int i=0; i<arrSteps.count; i++) {
        NSString *stringa=[[arrSteps objectAtIndex:i] objectAtIndex:indexOfAddress];
        NSLog(@"Destinazione %d nome:%@",i,stringa);
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder geocodeAddressString:stringa completionHandler:^(NSArray *placemarks, NSError *error) {
            if (error) {
                NSLog(@"%@", error);
            } else {
                 NSLog(@"Destinazione nel blocco %d nome:%@",i,stringa);
                CLPlacemark *place;
                place = [placemarks lastObject]; //prendi l'ultimo valore della ricerca
                [self addAnnotation:place];      //aggiungi il pin
                MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:place];
                MKMapItem* item=[[MKMapItem alloc] initWithPlacemark:placemark];
                item.name=stringa;
                [dest setObject:item forKey:[NSNumber numberWithInt:i]];
            }
        }];
        
    }
    
}
//
//    METODO PER RICHIEDERE AUTH
//
//
- (void)requestAwaysAuthorization
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    // If the status is denied or only granted for when in use, display an alert
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusDenied) {
        NSString *title;
        title = (status == kCLAuthorizationStatusDenied) ? @"Location services are off" : @"Background location is not enabled";
        NSString *message = @"To use background location you must turn on 'Always' in the Location Services Settings";
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Settings", nil];
        [alertView show];
    }
    // The user has not enabled any location services. Request background authorization.
    else if (status == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestAlwaysAuthorization];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        // Send the user to the Settings for this app
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsURL];
    }
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
