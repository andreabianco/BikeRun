//
//  BREditTourViewController.m
//  BikeRun
//
//  Created by Andrea Bianco on 09/11/14.
//  Copyright (c) 2014 mad. All rights reserved.
//

#import "BREditTourViewController.h"
#import "BRStepLitViewController.h"

@interface BREditTourViewController ()

@end

@implementation BREditTourViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"bikerun.sqlite"];
    
    if(self.recordToEdit != -1)
       [self loadTourToEdit];
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
    BRStepLitViewController *stepListViewController = [segue destinationViewController];
    stepListViewController.idTour = self.recordToEdit;
}

- (IBAction)saveTour:(id)sender {
    
    // Prepare the query string.
    NSString *query;
    if(self.recordToEdit != -1) {
        query = [NSString stringWithFormat:@"update trip set nameTrip = '%@' where id = %d", self.txtNameTour.text, self.recordToEdit];
    } else {
        query = [NSString stringWithFormat:@"insert into trip values(null, '%@')", self.txtNameTour.text];
    }
    
    // Execute the query.
    [self.dbManager executeQuery:query];
    
    // If the query was successfully executed then pop the view controller.
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
        
        [self.delegate editingTourWasFinished];
        
        // Pop the view controller.
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        NSLog(@"Could not execute the query.");
    }
    
}

-(void)loadTourToEdit
{
    // Create the query.
    NSString *query = [NSString stringWithFormat:@"select * from trip where id=%d", self.recordToEdit];
    
    // Load the relevant data.
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    // Set the loaded data to the textfields.
    self.txtNameTour.text = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"nameTrip"]];
}

@end
