//
//  BRNavigationViewController.m
//  BikeRun
//
//  Created by Alex De Biasi on 16/10/14.
//  Copyright (c) 2014 mad. All rights reserved.
//

#import "BRNavigationViewController.h"

@interface BRNavigationViewController ()

@end

@implementation BRNavigationViewController

CLPlacemark *thePlacemark;
CLPlacemark *thePlacemark2;
CLPlacemark *start;
MKRoute *routeDetails; //object for route instruction
int iter = 0;
int waypoints=0;
NSArray *dest;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.mapView.delegate = self;
    dest = [NSArray arrayWithObjects:@"Torino",@"Milano",@"Pavia",@"Torino",@"Milano",@"Pavia"@"Firenze",@"Roma",@"Napoli",@"Messina",nil];

}

- (void)addAnnotation:(CLPlacemark *)placemark {
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = CLLocationCoordinate2DMake(placemark.location.coordinate.latitude, placemark.location.coordinate.longitude);
    point.title = [placemark.addressDictionary objectForKey:@"Street"];
    point.subtitle = [placemark.addressDictionary objectForKey:@"City"];
    [self.mapView addAnnotation:point];
}

- (IBAction)routePressed:(UIBarButtonItem *)sender {
    //method that calculate route
    
    MKDirectionsRequest *directionsRequest = [[MKDirectionsRequest alloc] init];
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:thePlacemark];
    MKPlacemark *third = [[MKPlacemark alloc] initWithPlacemark:thePlacemark2];
    MKPlacemark *begin = [[MKPlacemark alloc] initWithPlacemark:start];
    [directionsRequest setSource:[[MKMapItem alloc] initWithPlacemark:begin]];
    [directionsRequest setDestination:[[MKMapItem alloc] initWithPlacemark:placemark]];
    directionsRequest.transportType = MKDirectionsTransportTypeWalking;
    MKDirections *directions = [[MKDirections alloc] initWithRequest:directionsRequest];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error %@", error.description);
        } else {
            routeDetails = response.routes.lastObject;
            [self.mapView addOverlay:routeDetails.polyline];
            self.allSteps = @"";
            for (int i = 0; i < routeDetails.steps.count; i++) {
                MKRouteStep *step = [routeDetails.steps objectAtIndex:i];
                NSString *newStep = step.instructions;
                self.allSteps = [self.allSteps stringByAppendingString:newStep];
                self.allSteps = [self.allSteps stringByAppendingString:@"\n\n"];
                self.steps.text = self.allSteps;
            }
        }
    }];
    
    //PROVA CON 2 STRADE
    [directionsRequest setSource:[[MKMapItem alloc] initWithPlacemark:placemark]];
    [directionsRequest setDestination:[[MKMapItem alloc] initWithPlacemark:third]];
    directionsRequest.transportType = MKDirectionsTransportTypeWalking;
    directions = [[MKDirections alloc] initWithRequest:directionsRequest];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error %@", error.description);
        } else {
            routeDetails = response.routes.lastObject;
            [self.mapView addOverlay:routeDetails.polyline];
            self.allSteps = @"";
            for (int i = 0; i < routeDetails.steps.count; i++) {
                MKRouteStep *step = [routeDetails.steps objectAtIndex:i];
                NSString *newStep = step.instructions;
                self.allSteps = [self.allSteps stringByAppendingString:newStep];
                self.allSteps = [self.allSteps stringByAppendingString:@"\n\n"];
                self.steps.text = self.allSteps;
            }
        }
    }];

}
- (IBAction)destinationPressed:(UIBarButtonItem *)sender {
    //add the destination on the map
    if (iter==2){
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder geocodeAddressString:@"Pavia" completionHandler:^(NSArray *placemarks, NSError *error) {
            if (error) {
                NSLog(@"%@", error);
            } else {
                thePlacemark2 = [placemarks lastObject];
                float spanX = 1.00725;
                float spanY = 1.00725;
                MKCoordinateRegion region;
                region.center.latitude = thePlacemark2.location.coordinate.latitude;
                region.center.longitude = thePlacemark2.location.coordinate.longitude;
                region.span = MKCoordinateSpanMake(spanX, spanY);
                [self.mapView setRegion:region animated:YES];
                [self addAnnotation:thePlacemark2];
            }
        }];
    }

    if (iter==1){
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder geocodeAddressString:@"Torino" completionHandler:^(NSArray *placemarks, NSError *error) {
            if (error) {
                NSLog(@"%@", error);
            } else {
                thePlacemark = [placemarks lastObject];
                float spanX = 1.00725;
                float spanY = 1.00725;
                MKCoordinateRegion region;
                region.center.latitude = thePlacemark.location.coordinate.latitude;
                region.center.longitude = thePlacemark.location.coordinate.longitude;
                region.span = MKCoordinateSpanMake(spanX, spanY);
                [self.mapView setRegion:region animated:YES];
                [self addAnnotation:thePlacemark];
            }
        }];
        iter++;
    }
    if (iter ==0) {
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder geocodeAddressString:@"Milano" completionHandler:^(NSArray *placemarks, NSError *error) {
            if (error) {
                NSLog(@"%@", error);
            } else {
                start = [placemarks lastObject];
                float spanX = 1.00725;
                float spanY = 1.00725;
                MKCoordinateRegion region;
                region.center.latitude = start.location.coordinate.latitude;
                region.center.longitude = start.location.coordinate.longitude;
                region.span = MKCoordinateSpanMake(spanX, spanY);
                [self.mapView setRegion:region animated:YES];
                [self addAnnotation:start];
            }
        }];
        iter++;
    }
}

- (IBAction)clearPressed:(UIBarButtonItem *)sender {
    //method that clear the map (Just the route)
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
