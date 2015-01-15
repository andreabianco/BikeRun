//
//  EditStepViewController.m
//  TourPart
//
//  Created by Andrea on 30/11/14.
//  Copyright (c) 2014 Andrea. All rights reserved.
//

#import "EditStepViewController.h"
#import "ShowStepMapViewController.h"

@interface EditStepViewController ()

@end

@implementation EditStepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_step) {
        NSLog(@"[EditStepVC] Edit Step");
        [self loadStep];
    } else {
        NSLog(@"[EditStepVC] Add Step");
    }
    // Do any additional setup after loading the view.
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
    UIViewController *nextController = [segue destinationViewController];
    if ([nextController isKindOfClass:[ShowStepMapViewController class]]) {
        ((ShowStepMapViewController *) nextController).address = _txtAddress.text;
        ((ShowStepMapViewController *) nextController).name = _txtName.text;
    }
}

- (IBAction)saveStep:(id)sender {
    if ([_txtAddress.text isEqualToString:@""]) {
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
            if (!_step) {
                _step = [NSEntityDescription insertNewObjectForEntityForName:@"Step" inManagedObjectContext:self.managedObjectContext];
            }
            _step.address = _txtAddress.text;
            _step.name = _txtName.text;
            
            Location *location = [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:_managedObjectContext];
            location.latitudine = [NSNumber numberWithDouble:lat];
            location.longitudine = [NSNumber numberWithDouble:lon];
            _step.hasLocation = location;
            
            /*NSArray *keys = [NSArray arrayWithObjects:@"id", @"address", @"description", @"lat", @"long",@"idTour", nil];
            NSNumber *idStep = [NSNumber numberWithInt:-1];
            if (_positionStep != -1) {
                idStep = [_stepDict objectForKey:@"id"];
            }
            NSArray *objects = [NSArray arrayWithObjects:idStep, self.txtAddress.text, self.txtName.text, [NSNumber numberWithDouble:lat], [NSNumber numberWithDouble:lon],[NSNumber numberWithInt:_idTour], nil];
            NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects
                                                                   forKeys:keys];*/
            [_delegate editingStepWasFinished:_step :[NSNumber numberWithInt:_positionStep]];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}

-(void) loadStep {
    //_txtName.text = [_stepDict objectForKey:@"description"];
    //_txtAddress.text = [_stepDict objectForKey:@"address"];
    _txtName.text = _step.name;
    _txtAddress.text = _step.address;
    
    NSLog(@"%@", [NSString stringWithFormat:@"[EditStepVC] Step loaded -> Name: %@, Description: %@, Address: %@, Location.latitudine: %@, Location.longitudine: %@", _step.name, _step.descr, _step.address, _step.hasLocation.latitudine, _step.hasLocation.longitudine]);
    
}
@end
