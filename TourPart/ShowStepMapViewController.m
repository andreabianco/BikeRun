//
//  ShowStepMapViewController.m
//  TourPart
//
//  Created by Andrea Bianco on 07/12/14.
//  Copyright (c) 2014 Andrea. All rights reserved.
//

#import "ShowStepMapViewController.h"

@interface ShowStepMapViewController ()

@end

@implementation ShowStepMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"%@", [NSString stringWithFormat:@"[ShowStepMapVC] Looking position for the address %@", _address]);
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:_address completionHandler:^(NSArray *placemarks, NSError *error) {
        //Get geo information to save in DB
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        CLLocationCoordinate2D newLocation = [placemark.location coordinate];
        [self placeAnnotationInMap:newLocation];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)placeAnnotationInMap:(CLLocationCoordinate2D)location {
    
    [_mapView removeAnnotations:_mapView.annotations];
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
    [annotation setCoordinate:location];
    [annotation setTitle:_name];
    [annotation setSubtitle:_address];
    [_mapView addAnnotation:annotation];
    
    //Scroll to search result
    //MKMapRect mr = [self.mapStep visibleMapRect];
    //MKMapPoint pt = MKMapPointForCoordinate([annotation coordinate]);
    //mr.origin.x = pt.x - mr.size.width * 0.5;
    //mr.origin.y = pt.y - mr.size.height * 0.25;
    //[self.mapStep setVisibleMapRect:mr animated:YES];
    
    MKCoordinateSpan span;
    span.latitudeDelta = 0.01f;
    span.longitudeDelta = 0.01f;
    
    MKCoordinateRegion region;
    region.center = location;
    region.span = span;
    [_mapView setRegion:region animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)changeMapType:(id)sender {
    switch (_segmentedControl.selectedSegmentIndex) {
        case 0:
            _mapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            _mapView.mapType = MKMapTypeSatellite;
            break;
        case 2:
            _mapView.mapType = MKMapTypeHybrid;
            break;
        default:
            break;
    }
}
@end
