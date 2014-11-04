//
//  BRSearchLocationViewController.m
//  BikeRun
//
//  Created by Andrea Bianco on 21/10/14.
//  Copyright (c) 2014 mad. All rights reserved.
//

#import "BRSearchLocationViewController.h"

@interface BRSearchLocationViewController ()

@end

@implementation BRSearchLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.searchBar.delegate = self;
    self.map.delegate = self;
    
    NSLog(@"Location to search: %@", self.locationToSearch);
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:self.locationToSearch completionHandler:^(NSArray *placemarks, NSError *error) {
        
        //Mark location and center
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        MKCoordinateRegion region;
        CLLocationCoordinate2D newLocation = [placemark.location coordinate];
        //NSString *test = placemark.locality;
        region.center = [(CLCircularRegion *) placemark.region center];
        
        //Drop pin
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
        [annotation setCoordinate:newLocation];
        [annotation setTitle:self.locationToSearch];
        [self.map addAnnotation:annotation];
        
        //Scroll to search result
        MKMapRect mr = [self.map visibleMapRect];
        MKMapPoint pt = MKMapPointForCoordinate([annotation coordinate]);
        mr.origin.x = pt.x - mr.size.width * 0.5;
        mr.origin.y = pt.y - mr.size.height * 0.25;
        [self.map setVisibleMapRect:mr animated:YES];
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self.searchBar resignFirstResponder];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:self.searchBar.text completionHandler:^(NSArray *placemarks, NSError *error) {
        
        //Mark location and center
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        MKCoordinateRegion region;
        CLLocationCoordinate2D newLocation = [placemark.location coordinate];
        region.center = [(CLCircularRegion *) placemark.region center];
        
        //Drop pin
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
        [annotation setCoordinate:newLocation];
        [annotation setTitle:self.searchBar.text];
        [self.map addAnnotation:annotation];
        
        //Scroll to search result
        MKMapRect mr = [self.map visibleMapRect];
        MKMapPoint pt = MKMapPointForCoordinate([annotation coordinate]);
        mr.origin.x = pt.x - mr.size.width * 0.5;
        mr.origin.y = pt.y - mr.size.height * 0.25;
        [self.map setVisibleMapRect:mr animated:YES];
        
    }];
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
