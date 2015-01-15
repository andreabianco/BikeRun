//
//  StepListTableViewController.m
//  TourPart
//
//  Created by Andrea on 29/11/14.
//  Copyright (c) 2014 Andrea. All rights reserved.
//

#import "StepListTableViewController.h"
#import "EditStepViewController.h"
#import "DBManager.h"

@interface StepListTableViewController ()

//@property (nonatomic,strong) NSArray *arrSteps;
//@property (nonatomic,strong) DBManager *dbManager;
@property (nonatomic,copy) NSIndexPath *tmpIndexPath;

@end

@implementation StepListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _tblView.delegate = self;
    _tblView.dataSource = self;
    
    //_dbManager = [[DBManager alloc] initWithDatabaseFilename:@"bikerun.sqlite"];
    
    /*if([_arrSteps count] > 0)
        [self loadData];*/
    
    NSLog(@"%@", [NSString stringWithFormat:@"[StepListTVC] #Steps loaded: %lu", (unsigned long)[_arrSteps count]]);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData{
    // Form the query.
    //NSString *query = [NSString stringWithFormat:@"select * from stepTour where idTour = %d", self.idTour];
    
    // Get the results.
    //if (_arrSteps != nil) {
        //_arrSteps = nil;
    //}
    //_arrSteps = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    // Reload the table view.
    [_tblView reloadData];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    UIViewController *nextController = [segue destinationViewController];
    ((EditStepViewController *) nextController).managedObjectContext = _managedObjectContext;
    ((EditStepViewController *) nextController).delegate = self;
    if ([[segue identifier] isEqualToString:@"addStep"]) {
        ((EditStepViewController *) nextController).positionStep = -1;
    } else {
        NSIndexPath *selectedIndexPath = [self.tblView indexPathForSelectedRow];
        _idStepToEdit = (int)selectedIndexPath.row;
        //NSLog([NSString stringWithFormat:@"Selected row: %d", _idStepToEdit]);
        ((EditStepViewController *) nextController).step = [_arrSteps objectAtIndex:_idStepToEdit];
        ((EditStepViewController *) nextController).positionStep = _idStepToEdit;
    }
    
}

#pragma Table View

/*-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    //_tourToEdit = [[[_arrTours objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
    _idStepToEdit = indexPath.row;
    _dictStep = [_arrSteps objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"editStep" sender:self];
}*/

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
        [_arrSteps removeObjectAtIndex:_tmpIndexPath.row];
        for (int i = (int)_tmpIndexPath.row; i < (int)[_arrSteps count]; i++) {
            Step *s = [_arrSteps objectAtIndex:(NSInteger)i];
            int p = [s.position intValue];
            s.position = [NSNumber numberWithInt:p-1];
        }
        [self.tblView deleteRowsAtIndexPaths:@[_tmpIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrSteps.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // Dequeue the cell.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idStepCell" forIndexPath:indexPath];
    
    //NSInteger indexOfName = [self.dbManager.arrColumnNames indexOfObject:@"description"];
    //NSInteger indexOfAddress = [self.dbManager.arrColumnNames indexOfObject:@"address"];
    
    // Set the loaded data to the appropriate cell labels.
    Step *step = [_arrSteps objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", step.address];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", step.name];
    
    return cell;
}

- (IBAction)addStep:(id)sender {
    _idStepToEdit = -1;
    [self performSegueWithIdentifier:@"editStep" sender:sender];
}

- (IBAction)saveFromStepList:(id)sender {
    [_delegate editingWasFinished:_arrSteps];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)editingStepWasFinished:(Step *)data :(NSNumber *)position{
    if([position isEqualToNumber:[NSNumber numberWithInt:-1]])
    {
        NSInteger c = [_arrSteps count];
        data.position = [NSNumber numberWithInteger:c];
        [_arrSteps addObject:data];
    } else {
        [_arrSteps replaceObjectAtIndex:[position intValue] withObject:data];
    }
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"position" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *sortedArray = [_arrSteps sortedArrayUsingDescriptors:sortDescriptors];
    _arrSteps = [NSMutableArray arrayWithArray:sortedArray];
    [_tblView reloadData];
}

@end
