//
//  ShowRecapMapViewController.m
//  TourPart
//
//  Created by Alex De Biasi on 13/01/15.
//  Copyright (c) 2015 Andrea. All rights reserved.
//

#import "ShowRecapMapViewController.h"
#import "Location.h"

@interface ShowRecapMapViewController ()

@end

@implementation ShowRecapMapViewController
NSTimeInterval totalTime=0;
CLLocationDistance totalDistance=0;
int cnt=0;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //set delegate and initialize object/db/core
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.mapView.delegate = self;

    [_kmLabel setHidden:TRUE];
    [_timeLabel setHidden:TRUE];
    [_stepLabel setHidden:TRUE];
    
    //verify and acquire permission
    CLAuthorizationStatus status=[CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status==kCLAuthorizationStatusAuthorized || status==kCLAuthorizationStatusAuthorizedAlways) {
        [self.locationManager stopUpdatingLocation];
        [self.locationManager startUpdatingLocation];
    }
    else{
        
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            //[self.locationManager requestWhenInUseAuthorization];
            [self.locationManager requestAlwaysAuthorization];
        }
    }
    [_mapView removeAnnotations:_mapView.annotations];

    for (Step* s in self.waypoint) {
        [self placeAnnotationInMap:s ];
    }
    [self createRoute];
   
    
    
    
}

-(void)placeAnnotationInMap:(Step* )location {
    
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
    [annotation setCoordinate:CLLocationCoordinate2DMake([location.hasLocation.latitudine doubleValue], [location.hasLocation.longitudine doubleValue])];
    
    
    [annotation setTitle:location.name];
    [annotation setSubtitle:location.address];
    [_mapView addAnnotation:annotation];
    
//    MKCoordinateSpan span;
//    span.latitudeDelta = 0.01f;
//    span.longitudeDelta = 0.01f;
//    
//    MKCoordinateRegion region;
//    region.center = location;
//    region.span = span;
//    [_mapView setRegion:region animated:YES];
}

/*! Function that create the route asking MKdirection and then saving it into core data*/
- (void) createRoute {

    //retrieve point and address
    MKDirectionsRequest *directionsRequest = [[MKDirectionsRequest alloc] init];
    MKMapItem *mapItem;
    MKPlacemark *placemark;
    for (int i=0; i<_waypoint.count-1; i++){
        Step *s=[_waypoint objectAtIndex:i];
         NSLog(@"start %@",s.address);
        placemark=[[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake([s.hasLocation.latitudine doubleValue], [s.hasLocation.longitudine doubleValue]) addressDictionary:nil];
        mapItem=[[MKMapItem alloc] initWithPlacemark:placemark];
        [directionsRequest setSource:mapItem];
        s=[_waypoint objectAtIndex:i+1];
       placemark= [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake([s.hasLocation.latitudine doubleValue], [s.hasLocation.longitudine doubleValue]) addressDictionary:nil];
        mapItem=[[MKMapItem alloc] initWithPlacemark:placemark];
        [directionsRequest setDestination:mapItem];
        NSLog(@"next %@",s.address);
        directionsRequest.transportType = MKDirectionsTransportTypeWalking;
        MKDirections *directions = [[MKDirections alloc] initWithRequest:directionsRequest];
        [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
            if (error) {
                NSLog(@"Error %@", error.description);
            } else {
                MKRoute* route = response.routes.lastObject;
                //IMPLEMENTARE POI LA PIU CORTA
                
                
                
                //////////////////////
               
                //DA CANCELLARE QUANDO IMP IN DATABASE///////
                totalDistance+= route.distance;
                totalTime+=route.expectedTravelTime;
                [self.mapView addOverlay:route.polyline];
                cnt++;
                if(cnt==_waypoint.count-1){
                    [_kmLabel setHidden:FALSE];
                    [_timeLabel setHidden:FALSE];
                    [_stepLabel setHidden:FALSE];
                    totalDistance=totalDistance/1000; //conversion to KM
                    totalTime=totalTime/10800; //conversion to bycicle hours
                    _kmLabel.text= [@(totalDistance) stringValue];
                    _timeLabel.text= [@(totalTime) stringValue];
                    _stepLabel.text =[@(_waypoint.count) stringValue];
                }
                    
            }
        }];

        
    }
    
    return;
}

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    MKPolyline *line= (MKPolyline*) overlay;
    MKPolylineRenderer  * routeLineRenderer = [[MKPolylineRenderer alloc] initWithPolyline:line];
    routeLineRenderer.strokeColor = [UIColor blueColor];
    routeLineRenderer.lineWidth = 3;
    return routeLineRenderer;
    
}


/* FUNZIONE PER SALVARE LE POSIZIONI
 CLLocationCoordinate2D coords[2];
 NSMutableArray myfoot;(globale)
 
 @property(nonatomic, strong) Run *run;
 
/////Entro in didupdatePosition
 coords[0] = ((CLLocation *)self.locations.lastObject).coordinate;
 coords[1] = newLocation.coordinate;
 Location *location = [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:_managedObjectContext];
 location.latitudine = [NSNumber numberWithDouble:coord];
 location.longitudine = [NSNumber numberWithDouble:lon];
 [myfoot addObject location] salva la posizione corrente
 
 ///Finisce la corsa
 if (_arrSteps.count > 0) {
 for (Step *s in _arrSteps) {
 [_tour addHasStepsObject:s];
 }
 }
 
 //Salvataggio del path
 Run *path = [NSEntityDescription insertNewObjectForEntityForName:@"Run" inManagedObjectContext:_managedObjectContext];
 for(i to n) {
    Location *location = [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:_managedObjectContext];
    location.latitudine = ...
    location.longitudine = ...
    location.posStep = [_waypoint objectAtIndex:i].position;
    path addObject:location];
 }
 NSError *error = nil;
 if (![self.managedObjectContext save:&error]) {
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
 }
 
*/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
