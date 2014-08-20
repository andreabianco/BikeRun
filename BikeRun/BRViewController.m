//
//  BRViewController.m
//  BikeRun
//
//  Created by Andrea Bianco on 06/08/14.
//  Copyright (c) 2014 mad. All rights reserved.
//

#import "BRViewController.h"

@interface BRViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *img;

@end

@implementation BRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.img.image = [UIImage imageNamed:@"full_bike_White.jpg"];
    self.navigationController.toolbarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
