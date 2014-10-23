//
//  BRSearchLocationViewController.h
//  BikeRun
//
//  Created by Andrea Bianco on 21/10/14.
//  Copyright (c) 2014 mad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface BRSearchLocationViewController : UIViewController<UISearchBarDelegate,MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet MKMapView *map;

@property (strong,nonatomic) NSString *locationToSearch;

@end
