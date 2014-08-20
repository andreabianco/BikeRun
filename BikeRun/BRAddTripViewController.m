//
//  BRAddTripViewController.m
//  BikeRun
//
//  Created by Andrea Bianco on 12/08/14.
//  Copyright (c) 2014 mad. All rights reserved.
//

#import "BRAddTripViewController.h"

@interface BRAddTripViewController ()
- (IBAction)closeModal:(id)sender;

@end

@implementation BRAddTripViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
//    
//    if([title isEqualToString:@"No"])
//    {
//        NSLog(@"No was selected.");
//    }
//    else if([title isEqualToString:@"Yes"])
//    {
//        NSLog(@"Yes was selected.");
//    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Choose start" message:@"Selezionare la posizione corrente come punto di partenza?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    //[alert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)closeModal:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
@end
