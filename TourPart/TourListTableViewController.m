//
//  TourListTableViewController.m
//  TourPart
//
//  Created by Andrea on 23/11/14.
//  Copyright (c) 2014 Andrea. All rights reserved.
//

#import "TourListTableViewController.h"

@interface TourListTableViewController ()

@property (nonatomic,strong) NSMutableArray *arrTours;
@property (nonatomic,strong) DBManager *dbManager;
@property (nonatomic) int tourToEdit;
@property (nonatomic,copy) NSIndexPath *tmpIndexPath;

@end

@implementation TourListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //_dbManager = [[DBManager alloc] initWithDatabaseFilename:@"bikerun.sqlite"];
    //[self loadToursFromDB];
    [self loadToursFromCoreData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_arrTours count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellTour" forIndexPath:indexPath];
    
    // Configure the cell...
    Tour *tour = [_arrTours objectAtIndex:indexPath.row];
    cell.textLabel.text = tour.name;
    
    return cell;
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    _tourToEdit = (int)indexPath.row;
//    NSLog([NSString stringWithFormat:@"Selected row: %d", _tourToEdit]);
//}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        _tmpIndexPath = indexPath;
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Title"
                                                           message:@"This is the message."
                                                          delegate:self
                                                 cancelButtonTitle:@"Cancel"
                                                 otherButtonTitles:@"Ok", nil];
        [theAlert show];
    }
}

- (void)alertView:(UIAlertView *)theAlert clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"The %@ button was tapped.", [theAlert buttonTitleAtIndex:buttonIndex]);
    if ([[theAlert buttonTitleAtIndex:buttonIndex] isEqualToString:@"Ok"]) {
        Tour *tour = [_arrTours objectAtIndex:_tmpIndexPath.row];
        [_arrTours removeObjectAtIndex:_tmpIndexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[_tmpIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        [_managedObjectContext deleteObject:tour];
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UINavigationController *navController = (UINavigationController*)[segue destinationViewController];
    EditTourViewController *editTourViewController = [navController topViewController];
    editTourViewController.delegate = self;
    editTourViewController.managedObjectContext = _managedObjectContext;
    if ([[segue identifier] isEqualToString:@"addNewTour"]) {
        editTourViewController.tourToEdit = -1;
    } else {
        //Edit Tour Segue
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        _tourToEdit = (int)selectedIndexPath.row;
        //NSLog([NSString stringWithFormat:@"Selected row: %d", _tourToEdit]);
        editTourViewController.tourToEdit = _tourToEdit;
        editTourViewController.tour = [_arrTours objectAtIndex:_tourToEdit];
    }
}

/*
 * Usato per caricare i Tour dal DB
 */
-(void) loadToursFromDB
{
    // Form the query.
    NSString *query = @"select * from trip";
    
    // Get the results.
    if (_arrTours != nil) {
        _arrTours = nil;
    }
    _arrTours = [NSMutableArray arrayWithArray:[[NSArray alloc] initWithArray:[_dbManager loadDataFromDB:query]]];
    
    // Reload the table view.
    [self.tableView reloadData];
}

-(void) loadToursFromCoreData {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Tour" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    _arrTours = [NSMutableArray arrayWithArray:[_managedObjectContext executeFetchRequest:fetchRequest error:nil]];
    
    NSLog(@"%@", [NSString stringWithFormat:@"[TourListTVC] #Tours loaded: %lu", (unsigned long)_arrTours.count]);
    
    [self.tableView reloadData];
}

-(void)editingTourWasFinished {
    //[self loadToursFromDB];
    [self loadToursFromCoreData];
}

-(void)deleteRowFromDB:(NSNumber*)row {
    NSString * queryTour = [NSString stringWithFormat:@"delete from trip where id = %d", [row intValue]];
    [_dbManager executeQuery:queryTour];
    if (_dbManager.affectedRows != 0) {
        NSLog(@"Tour deleted");
        NSString *queryStep = [NSString stringWithFormat:@"delete from stepTour where idTour = %d", [row intValue]];
        [_dbManager executeQuery:queryStep];
        if (_dbManager.affectedRows != 0) {
            NSLog(@"Steps deleted");
        }
    }
}

@end
