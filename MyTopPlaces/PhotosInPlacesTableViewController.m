//
//  PhotosInPlacesTableViewController.m
//  MyTopPlaces
//
//  Created by Tatiana Kornilova on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhotosInPlacesTableViewController.h"
#import "RecentsUserDefaults.h"
#import "MapViewController.h"
#import "PhotoAnnotation.h"
#import "TopPlacesPhotoViewController.h"

@interface PhotosInPlacesTableViewController () <MapViewControllerDelegate>

@end

@implementation PhotosInPlacesTableViewController
@synthesize refreshSpinner;
@synthesize mapButton;
@synthesize photoToDisplay=_photoToDisplay;

- (void)awakeFromNib
{
    self.cellId = @"Photos Description";
}

#define MAX_RESULTS 50

- (NSMutableArray *)retrievePhotoList
{

    [refreshSpinner startAnimating];
    dispatch_queue_t photoListFetchingQueue =
    dispatch_queue_create("photo list fetching queue", NULL);
    
    dispatch_async(photoListFetchingQueue, ^{
        if (self.photos)return;
        self.photos = [[FlickrFetcher photosInPlace:self.place
                                        maxResults:MAX_RESULTS] mutableCopy];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [refreshSpinner stopAnimating];
            [self.tableView reloadData];
        });
    });
    
    dispatch_release(photoListFetchingQueue);
   
    return nil;
}

- (void)viewDidUnload
{
    [self setMapButton:nil];
    [self setRefreshSpinner:nil];
    [super viewDidUnload];
}

- (NSArray *)mapAnnotations
{
    NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:[self.photos count]];
    for (NSDictionary *photo in self.photos){
        [annotations addObject:[PhotoAnnotation annotationForPhoto:photo]];
    }
    return annotations;
}

#pragma mark - MapViewControllerDelegate

- (UIImage *)mapViewController:(MapViewController *)sender imageForAnnotation:(id <MKAnnotation>)annotation
{
    PhotoAnnotation *fpa = (PhotoAnnotation *)annotation;
    NSURL *url = [FlickrFetcher urlForPhoto:fpa.photo format:FlickrPhotoFormatSquare];
    NSData *data = [NSData dataWithContentsOfURL:url];
    return data ? [UIImage imageWithData:data] : nil;
}


-(TopPlacesPhotoViewController *)splitViewPhotoViewController
{
    UINavigationController *nc = [self.splitViewController.viewControllers lastObject];
    id pvc = nc.topViewController;
    if (![pvc isKindOfClass:[TopPlacesPhotoViewController class]]) {
        pvc = nil;
    }
    return pvc;
}

-(void)segueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    self.photoToDisplay = sender;
//---------------------------------------------------
    id vc = [self.splitViewController.viewControllers lastObject];
    if ([vc isKindOfClass:[TopPlacesPhotoViewController class]])
        [vc setPhoto:sender];
    else
        [self performSegueWithIdentifier:@"Show Photo" sender:sender];
//-----------------------------------------------------
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    if ([segue.identifier isEqualToString:@"Show Photo"])
//    else if ([segue.destinationViewController isEqualToString:@"Show map"])
    if ([segue.destinationViewController isKindOfClass:[TopPlacesPhotoViewController class]])
    {
           NSIndexPath *path = [self.tableView indexPathForSelectedRow];
           NSDictionary *photo = [self.photos objectAtIndex:path.row];
           [segue.destinationViewController setPhoto:photo];
           [[segue.destinationViewController navigationItem] setTitle:[[sender textLabel] text]];
           UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
    
           [segue.destinationViewController setPhotoTitle : cell.textLabel.text];
           [RecentsUserDefaults saveRecentsUserDefaults:photo];
    }
   else if ([segue.destinationViewController isKindOfClass:[MapViewController class]])
    
    {
        MapViewController *mapVC = segue.destinationViewController;
        mapVC.annotations = [self mapAnnotations];
        mapVC.delegate = self;
        mapVC.title = self.title;
//        [segue.destinationViewController setDelegate:self];
//        [segue.destinationViewController setAnnotations:[self mapAnnotations]];
    }
    
    [super prepareForSegue:segue sender:sender];
   
}

@end
