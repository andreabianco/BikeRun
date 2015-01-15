//
//  TourListTableViewController.h
//  TourPart
//
//  Created by Andrea on 23/11/14.
//  Copyright (c) 2014 Andrea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "EditTourViewController.h"
#import "Tour.h"
#import "DBManager.h"

@interface TourListTableViewController : UITableViewController<EditTourViewControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
