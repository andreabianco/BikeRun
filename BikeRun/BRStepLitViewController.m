//
//  BRStepLitViewController.m
//  BikeRun
//
//  Created by Andrea on 15/10/14.
//  Copyright (c) 2014 mad. All rights reserved.
//

#import "BRStepLitViewController.h"

@interface BRStepLitViewController ()

@end

@implementation BRStepLitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tblSteps.delegate = self;
    self.tblSteps.dataSource = self;
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"bikerun.sqlite"];
    
    [self loadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrSteps.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // Dequeue the cell.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idStepCell" forIndexPath:indexPath];
    
    NSInteger indexOfLat = [self.dbManager.arrColumnNames indexOfObject:@"lat"];
    NSInteger indexOfLong = [self.dbManager.arrColumnNames indexOfObject:@"long"];
    NSInteger indexOfAddress = [self.dbManager.arrColumnNames indexOfObject:@"address"];
    
    // Set the loaded data to the appropriate cell labels.
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [[self.arrSteps objectAtIndex:indexPath.row] objectAtIndex:indexOfAddress]];
    //cell.detailTextLabel.text = [NSString stringWithFormat:@"Lat: %@ - Long: %@", [[self.arrSteps objectAtIndex:indexPath.row] objectAtIndex:indexOfLat], [[self.arrSteps objectAtIndex:indexPath.row] objectAtIndex:indexOfLong]];
    
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    //NSLog(@"Performing segue...");
    BREditStepViewController *editStepViewController = [segue destinationViewController];
    editStepViewController.recordIDToEdit = self.recordIdToEdit;
    editStepViewController.delegate = self;
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    
    self.recordIdToEdit = [[[self.arrSteps objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
    [self performSegueWithIdentifier:@"showStepEdit" sender:self];
    
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        int recordIDToDelete = [[[self.arrSteps objectAtIndex:indexPath.row]objectAtIndex:0] intValue];
        // Prepare the query.
        NSString *query = [NSString stringWithFormat:@"delete from stepTour where id=%d", recordIDToDelete];
        
        // Execute the query.
        [self.dbManager executeQuery:query];
        
        // Reload the table view.
        [self loadData];
    }
}

- (IBAction)addNewStep:(id)sender {
    self.recordIdToEdit = -1;
    [self performSegueWithIdentifier:@"showStepEdit" sender:sender];
}

-(void)loadData{
    // Form the query.
    NSString *query = @"select * from stepTour";
    
    // Get the results.
    if (self.arrSteps != nil) {
        self.arrSteps = nil;
    }
    self.arrSteps = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    // Reload the table view.
    [self.tblSteps reloadData];
}

-(void)editingStepWasFinished{
    [self loadData];
}

@end
