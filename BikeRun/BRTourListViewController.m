//
//  BRTourListViewController.m
//  BikeRun
//
//  Created by Andrea Bianco on 09/11/14.
//  Copyright (c) 2014 mad. All rights reserved.
//

#import "BRTourListViewController.h"

@interface BRTourListViewController ()

@property (strong,nonatomic) NSArray *arrTours;

-(void)loadTours;

@end

@implementation BRTourListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tblTours.delegate = self;
    self.tblTours.dataSource = self;
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"bikerun.sqlite"];
    
    [self loadTours];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrTours count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Dequeue the cell.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellTour" forIndexPath:indexPath];
    
    NSInteger indexOfName = [self.dbManager.arrColumnNames indexOfObject:@"nameTrip"];
    
    cell.textLabel.text = [[self.arrTours objectAtIndex:indexPath.row] objectAtIndex:indexOfName];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.recordToEdit = [[[self.arrTours objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
    [self performSegueWithIdentifier:@"showTourEdit" sender:self];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the selected record.
        // Find the record ID.
        int recordIDToDelete = [[[self.arrTours objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
        
        // Prepare the query.
        NSString *query = [NSString stringWithFormat:@"delete from trip where id=%d", recordIDToDelete];
        
        // Execute the query.
        [self.dbManager executeQuery:query];
        
        // Reload the table view.
        [self loadTours];
    }
}

-(void)loadTours
{
    // Form the query.
    NSString *query = @"select * from trip";
    
    // Get the results.
    if (self.arrTours != nil) {
        self.arrTours = nil;
    }
    self.arrTours = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    // Reload the table view.
    [self.tblTours reloadData];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    BREditTourViewController *editTourViewController = [segue destinationViewController];
    editTourViewController.recordToEdit = self.recordToEdit;
    editTourViewController.delegate = self;
}

- (IBAction)addTour:(id)sender {
    self.recordToEdit = -1;
    [self performSegueWithIdentifier:@"showTourEdit" sender:self];
}

-(void)editingTourWasFinished
{
    [self loadTours];
}

@end
