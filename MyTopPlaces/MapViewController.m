//
//  MapViewController.m
//  MyTopPlaces5
//
//  Created by Tatiana Kornilova on 8/7/12.
//
//

#import "MapViewController.h"
#import "PhotoAnnotation.h"

@interface MapViewController ()<MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end

@implementation MapViewController

@synthesize mapView=_mapView;
@synthesize annotations=_annotations;
@synthesize delegate=_delegate;

-(void)updateMapView
{
    if (self.mapView.annotations)[self.mapView removeAnnotations:self.mapView.annotations];
    if (self.annotations) [self.mapView addAnnotations:self.annotations];
    
}
-(void)setMapView:(MKMapView *)mapView
{
    _mapView=mapView;
    [self updateMapView];
}
-(void)setAnnotations:(NSArray *)annotations
{
    _annotations=annotations;
    [self updateMapView];
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *aView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MapVC"];
    if (!aView) {
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MapVC"];
        aView.canShowCallout = YES;
        aView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        aView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        // could put a rightCalloutAccessoryView here
    }
    
    aView.annotation = annotation;
    [(UIImageView *)aView.leftCalloutAccessoryView setImage:nil];
    
    return aView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)aView
{
    UIImage *image = [self.delegate mapViewController:self imageForAnnotation:aView.annotation];
    [(UIImageView *)aView.leftCalloutAccessoryView setImage:image];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    PhotoAnnotation *annotation = (PhotoAnnotation *)view.annotation;
    NSDictionary *photo = annotation.photo;
    [self.delegate segueWithIdentifier:@"Show Photo" sender:photo];
//    NSLog(@"callout accessory tapped for annotation %@", [view.annotation title]);
}

// Position the map so that all overlays and annotations are visible on screen.
- (MKMapRect) mapRectForAnnotations:(NSArray*)annotations
{
    MKMapRect mapRect = MKMapRectNull;
    
    //annotations is an array with all the annotations I want to display on the map
    for (id<MKAnnotation> annotation in annotations) {
        
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
        
        if (MKMapRectIsNull(mapRect))
        {
            mapRect = pointRect;
        } else
        {
            mapRect = MKMapRectUnion(mapRect, pointRect);
        }
    }
    
    return mapRect;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate=self;
}

- (void)viewWillAppear:(BOOL)animated
{
    MKMapRect regionToDisplay = [self mapRectForAnnotations:self.annotations];
    if (!MKMapRectIsNull(regionToDisplay)) self.mapView.visibleMapRect = regionToDisplay;
}
- (void)viewDidUnload
{
    [self setMapView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
