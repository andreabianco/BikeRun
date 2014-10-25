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

@end

@implementation BREditStepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.txtAddress.delegate = self;
    self.txtDesc.delegate = self;
    self.txtLat.delegate = self;
    self.txtLong.delegate = self;
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"bikerun.sqlite"];
    
    if(self.recordIDToEdit != -1) {
        [self loadStepToEdit];
    }
    
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
    self.txtLat.text = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"lat"]];
    self.txtLong.text = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"long"]];
    self.txtDesc.text = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"description"]];
    self.txtAddress.text = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"address"]];
}

@end
