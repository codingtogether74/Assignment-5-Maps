//
//  PhotosInPlacesTableViewController.h
//  MyTopPlaces
//
//  Created by Tatiana Kornilova on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoTableViewController.h"
#import "MapViewController.h"

@interface PhotosInPlacesTableViewController : PhotoTableViewController
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *refreshSpinner;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *mapButton;
@property (weak, nonatomic)NSDictionary *photoToDisplay;

-(void)segueWithIdentifier:(NSString *)identifier sender:(id)sender;
@end