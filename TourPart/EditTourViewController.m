//
//  EditTourViewController.m
//  TourPart
//
//  Created by Andrea on 23/11/14.
//  Copyright (c) 2014 Andrea. All rights reserved.
//

#import "EditTourViewController.h"
#import "StepListTableViewController.h"
#import "ShowRecapMapViewController.h"
#import "DBManager.h"

@interface EditTourViewController ()

@property (nonatomic,strong) DBManager *dbManager;
@property (nonatomic,strong) NSMutableArray *arrSteps;

@end

@implementation EditTourViewController
int cnt=0;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"bikerun.sqlite"];
    _arrSteps = [[NSMutableArray alloc] init];
    
    if(_tour) {
       //Edit
        NSLog(@"[EditTourVC] Edit Tour");
        [self loadTour];
    } else {
        //Add
        [_deleteBtt setHidden:YES];
        NSLog(@"[EditTour] Add Tour");
    }
    
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
    if ([nextController isKindOfClass:[StepListTableViewController class]]) {
        ((StepListTableViewController *) nextController).managedObjectContext = self.managedObjectContext;
        ((StepListTableViewController *) nextController).idTour = _tourToEdit;
        ((StepListTableViewController *) nextController).arrSteps = _arrSteps;
        ((StepListTableViewController *) nextController).delegate = self;
    }
    else{
        if ([nextController isKindOfClass:[ShowRecapMapViewController class]]){
            ((ShowRecapMapViewController *) nextController).waypoint= self.arrSteps;
        }
    }
}

/*
 * I cambiamenti non vengono salvati
 */
- (IBAction)backToEditTour:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
 * Salvataggio del tour
 * Se idTour = -1, devo prima inserire il tour nel database, recupero l'id e poi salvo le tappe
 * Se idTour != -1, devo aggiornare il tuor e poi aggiorno o inserisco le tappe (a seconda se id =/!= -1)
 */
- (IBAction)saveTour:(id)sender {
    
    if ([_txtNome.text isEqualToString:@""]) {
        NSLog(@"Campo name vuoto!");
    } else {
        if (!_tour) {
            _tour = [NSEntityDescription insertNewObjectForEntityForName:@"Tour" inManagedObjectContext:self.managedObjectContext];
        }
        [_tour removeHasSteps:_tour.hasSteps];
        if (_arrSteps.count > 0) {
            for (Step *s in _arrSteps) {
                [_tour addHasStepsObject:s];
            }
            //[_tour addHasSteps:[NSSet setWithArray:_arrSteps]];
        }
        _tour.name = _txtNome.text;
        _tour.descr = _txtDesc.text;
        
        
        
        ////////////Copia e incolla funzione per il path!!!!!!!!

        
        //
        
        // Save the context. //////Quando è arrivato all'ultima tratta!!!
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        [self.delegate editingTourWasFinished];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (IBAction)deleteTour:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"What do you want to do with the tour?"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Delete it"
                                                    otherButtonTitles:nil];
    
    [actionSheet showInView:self.view];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"Index = %ld - Title = %@", (long)buttonIndex, [actionSheet buttonTitleAtIndex:buttonIndex]);
    if(buttonIndex == 0) {
        //Delete the tour
        [_managedObjectContext deleteObject:_tour];
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        [self.delegate editingTourWasFinished];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)loadTour {
    
    // Set the loaded data to the textfields.
    _txtNome.text = _tour.name;
    _txtDesc.text = _tour.descr;
  
    NSArray *a = [_tour.hasSteps allObjects];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"position" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *sortedArray = [a sortedArrayUsingDescriptors:sortDescriptors];
    _arrSteps = [NSMutableArray arrayWithArray:sortedArray];
    
    NSLog(@"%@", [NSString stringWithFormat:@"[EditTourVC] Tour loaded -> Name: %@ , Description: %@, #Steps: %lu, #Runs: %lu", _tour.name, _tour.descr, (unsigned long)[_tour.hasSteps count], (unsigned long)[_tour.hasRuns count]]);
    
}

-(void)loadSteps {
    // Create the query.
    NSString *query = [NSString stringWithFormat:@"select * from stepTour where idTour=%d", self.tourToEdit];
    // Load the relevant data.
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    NSLog(@"Steps loaded");
    
    NSArray *key = @[@"id", @"lat",@"long", @"description", @"address", @"idTour"];
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    for (int i = 0; i < results.count; i++) {
        NSArray *array = [results objectAtIndex:i];
        NSArray *data = @[[f numberFromString:[array objectAtIndex:0]],
                          [f numberFromString:[array objectAtIndex:1]],
                          [f numberFromString:[array objectAtIndex:2]],
                          [array objectAtIndex:3],
                          [array objectAtIndex:4],
                          [f numberFromString:[array objectAtIndex:5]]];
        NSDictionary *tour = [NSDictionary dictionaryWithObjects:data forKeys:key];
        [_arrSteps addObject:tour];
    }
    
}
- (void) saveRoute {
    
    //retrieve point and address
    MKDirectionsRequest *directionsRequest = [[MKDirectionsRequest alloc] init];
    MKMapItem *mapItem;
    MKPlacemark *placemark;
    for (int i=0; i<_arrSteps.count-1; i++){
        Step *s=[_arrSteps objectAtIndex:i];
        NSLog(@"start %@",s.address);
        placemark=[[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake([s.hasLocation.latitudine doubleValue], [s.hasLocation.longitudine doubleValue]) addressDictionary:nil];
        mapItem=[[MKMapItem alloc] initWithPlacemark:placemark];
        [directionsRequest setSource:mapItem];
        s=[_arrSteps objectAtIndex:i+1];
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
               // save the route as a sequence of Location object
                        NSUInteger count = route.polyline.pointCount;
                        CLLocationCoordinate2D * coordArray = malloc(count*sizeof(CLLocationCoordinate2D)); //create a C array to store Coordinate
                        [route.polyline getCoordinates:coordArray range:NSMakeRange(0, count)];//fill it
                        //save the Location
                        for (int i=0 ; i<count; i++) {
                            Location *location = [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:_managedObjectContext];
                            location.latitudine =@( coordArray[i].latitude);
                            location.longitudine = @(coordArray[i].longitude);
                         //   location.posStep = @([_arrSteps objectAtIndex:i].position); COME METTO POSIZIONE?
                        //    path addObject:location]; Aggiungere al Path
                        }
                        free(coordArray); //free the memory
                        NSError *error = nil;
                        if (![self.managedObjectContext save:&error]) {
                            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                                abort();
                        }
                cnt++;
                if(cnt==_arrSteps.count-1){
                    //SAVE THE LOCATION ARRAY
                    //SALVARE IL TUTTO NELLA RUN
                    /////////
                }
                
            }
        }];
    }
    
    return;
}


-(void)editingWasFinished:(NSMutableArray *)data {
    _arrSteps = data;
}

@end
