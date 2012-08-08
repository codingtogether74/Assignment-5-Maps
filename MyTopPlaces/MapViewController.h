//
//  MapViewController.h
//  MyTopPlaces5
//
//  Created by Tatiana Kornilova on 8/7/12.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class MapViewController;

@protocol MapViewControllerDelegate <NSObject>

-(UIImage *)mapViewController:(MapViewController *)sender imageForAnnotation:(id<MKAnnotation>)annotation;
- (void)segueWithIdentifier:(NSString *)identifier sender:(id)sender;
@end

@interface MapViewController : UIViewController
@property (nonatomic,strong) NSArray *annotations; // of id <MKAnnotations  
@property (nonatomic,weak) id <MapViewControllerDelegate> delegate;

@end