//
//  BREditStepViewController.m
//  BikeRun
//
//  Created by Andrea on 15/10/14.
//  Copyright (c) 2014 mad. All rights reserved.
//

#import "BREditStepViewController.h"
#import "BRSearchLocationViewController.h"

@interface BREditStepViewController ()

@property (strong,nonatomic) NSString *addressStep;
@property (strong,nonatomic) NSString *nameStep;
@property (nonatomic) double latStep;
@property (nonatomic) double longStep;

@end

@implementation BREditStepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.txtAddress.delegate = self;
    self.txtDesc.delegate = self;
    //self.txtLat.delegate = self;
    //self.txtLong.delegate = self;
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"bikerun.sqlite"];
    
    if(self.recordIDToEdit != -1) {
        [self loadStepToEdit];
    }
    
}

-(void)placeAnnotationInMap:(CLLocationCoordinate2D)location {
    
    [self.mapStep removeAnnotations:self.mapStep.annotations];
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
    [annotation setCoordinate:location];
    [annotation setTitle:self.nameStep];
    [annotation setSubtitle:self.addressStep];
    [self.mapStep addAnnotation:annotation];
    
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
    [self.mapStep setRegion:region animated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    BRSearchLocationViewController *searchLocationViewController = [segue destinationViewController];
    searchLocationViewController.locationToSearch = self.txtAddress.text;
}

- (IBAction)saveStep:(id)sender {
    
    if([self.txtAddress.text isEqualToString:@""]) {
        NSLog(@"Address empty!");
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"BikeRun"
                                                          message:@"Insert the address!"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    } else {
        
        NSString *addressToSearch = self.txtAddress.text;
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder geocodeAddressString:addressToSearch completionHandler:^(NSArray *placemarks, NSError *error) {
            
            //Get geo information to save in DB
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            CLLocationCoordinate2D newLocation = [placemark.location coordinate];
            double lat = newLocation.latitude;
            double lon = newLocation.longitude;
            
            // Prepare the query string.
            NSString *query;
            if (self.recordIDToEdit != -1) {
                query = [NSString stringWithFormat:@"update stepTour set lat=%f, long=%f, description='%@', address='%@' where id=%d", lat, lon, self.txtDesc.text, addressToSearch, self.recordIDToEdit];
            } else {
                query = [NSString stringWithFormat:@"insert into stepTour values(null, %f, %f, '%@', '%@')", lat, lon, self.txtDesc.text, addressToSearch];
            }
            [self.dbManager executeQuery:query];
            if(self.dbManager.affectedRows != 0) {
                NSLog(@"Success");
                [self.delegate editingStepWasFinished];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                NSLog(@"Error");
            }
            
        }];
        
    }
}

-(void)loadStepToEdit{
    // Create the query.
    NSString *query = [NSString stringWithFormat:@"select * from stepTour where id=%d", self.recordIDToEdit];
    
    // Load the relevant data.
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    // Set the loaded data to the textfields.
    double lat = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"lat"]] doubleValue];
    self.latStep = lat;
    double lon = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"long"]] doubleValue];
    self.longStep = lon;
    self.txtDesc.text = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"description"]];
    self.nameStep = self.txtDesc.text;
    self.txtAddress.text = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"address"]];
    self.addressStep = self.txtAddress.text;
    
    [self placeAnnotationInMap:CLLocationCoordinate2DMake(self.latStep, self.longStep)];
    
}

- (IBAction)verifyLocation:(id)sender {
    if ([self.txtAddress.text isEqualToString:@""]) {
        //Empty
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"BikeRun"
                                                          message:@"Insert the address!"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    } else {
        //Cerco address
        
        self.addressStep = self.txtAddress.text;
        self.nameStep = self.txtDesc.text;
        
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder geocodeAddressString:self.txtAddress.text completionHandler:^(NSArray *placemarks, NSError *error) {
            
            //Mark location and center
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            MKCoordinateRegion region;
            CLLocationCoordinate2D newLocation = [placemark.location coordinate];
            [self placeAnnotationInMap:newLocation];
            
//            region.center = [(CLCircularRegion *) placemark.region center];
//            
//            //Drop pin
//            MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
//            [annotation setCoordinate:newLocation];
//            [annotation setTitle:self.txtDesc.text];
//            [self.mapStep addAnnotation:annotation];
//            
//            //Scroll to search result
//            MKMapRect mr = [self.mapStep visibleMapRect];
//            MKMapPoint pt = MKMapPointForCoordinate([annotation coordinate]);
//            mr.origin.x = pt.x - mr.size.width * 0.5;
//            mr.origin.y = pt.y - mr.size.height * 0.25;
//            [self.mapStep setVisibleMapRect:mr animated:YES];
            
        }];
    }
}

@end
