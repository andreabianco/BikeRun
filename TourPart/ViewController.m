//
//  ViewController.m
//  TourPart
//
//  Created by Andrea on 23/11/14.
//  Copyright (c) 2014 Andrea. All rights reserved.
//

#import "ViewController.h"
#import "TourListTableViewController.h"
#import "Tour.h"
#import "Step.h"
#import "Location.h"
#import "DBManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /*Tour *tour = [NSEntityDescription insertNewObjectForEntityForName:@"Tour" inManagedObjectContext:self.managedObjectContext];
    tour.name = @"Test tour";
    tour.descr = @"Descrizione";
    
    Step *step = [NSEntityDescription insertNewObjectForEntityForName:@"Step" inManagedObjectContext:_managedObjectContext];
    step.name = @"Casa";
    step.address = @"Piazza Castello 9, Agliano Terme";
    step.descr = @"Casa ad Agliano";
    step.position = [NSNumber numberWithInt:0];
    
    Step *step2 = [NSEntityDescription insertNewObjectForEntityForName:@"Step" inManagedObjectContext:_managedObjectContext];
    step2.name = @"Cascina Nonna";
    step2.address = @"Regione Vianoce 10, Agliano Terme";
    step2.descr = @"Azienda e casa di nonna";
    step2.position = [NSNumber numberWithInt:1];
    
    Location *location = [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:_managedObjectContext];
    location.latitudine = [NSNumber numberWithInt:34];
    location.longitudine = [NSNumber numberWithInt:34];
    step.hasLocation = location;
    step.hasLocation = location;
    
    [tour addHasStepsObject:step2];
    [tour addHasStepsObject:step];
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }*/
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *nextController = [segue destinationViewController];
    if ([nextController isKindOfClass:[TourListTableViewController class]]) {
        ((TourListTableViewController *) nextController).managedObjectContext = self.managedObjectContext;
    }}

@end
