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

MKRoute *routeDetails; //object for route instruction
int iter = 0;
int waypoints=0;
NSMutableDictionary *dest;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.mapView.delegate = self;
    dest=[[NSMutableDictionary alloc] init];

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
}

- (IBAction)destinationPressed:(UIBarButtonItem *)sender {
    [self initDestArray:dest];
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



/*********************************
 *********************************
 METODO PER INIZIALIZZARE LE TAPPE VA POI TOLTO E MI VIENE GIA RESTITUITO L'ARRAY 
 **********************************/

- (void)initDestArray:(NSMutableDictionary *)destinaz{
    NSArray *mete=[[NSArray alloc] initWithObjects:@"Milano", @"Torino", @"Cuneo", @"Savona", @"Firenze", @"Siena", @"Roma", @"Salerno", @"Napoli", @"Reggio Calabria", @"Messina" , nil];
    
    
    for (int i=0; i<mete.count; i++) {
        NSString *stringa=[mete objectAtIndex:i];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
