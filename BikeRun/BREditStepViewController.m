//
//  BREditStepViewController.m
//  BikeRun
//
//  Created by Andrea on 15/10/14.
//  Copyright (c) 2014 mad. All rights reserved.
//

#import "BREditStepViewController.h"

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)saveStep:(id)sender {
    // Prepare the query string.
    NSString *query;
    if (self.recordIDToEdit != -1) {
        query = [NSString stringWithFormat:@"update stepTour set lat='%@', long='%@', description='%@', address='%@' where id=%d", self.txtLat.text, self.txtLong.text, self.txtDesc.text, self.txtAddress.text, self.recordIDToEdit];
    } else {
        query = [NSString stringWithFormat:@"insert into stepTour values(null, '%@', '%@', '%@', '%@')", self.txtLat.text, self.txtLong.text, self.txtDesc.text, self.txtAddress.text];
    }
    
    // Execute the query.
    [self.dbManager executeQuery:query];
    
    // If the query was successfully executed then pop the view controller.
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
        
        [self.delegate editingStepWasFinished];
        
        // Pop the view controller.
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        NSLog(@"Could not execute the query.");
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
