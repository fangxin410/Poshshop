//
//  MapViewController.h
//  Dealo
//
//  Created by admin on 8/14/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
@interface MapViewController : UIViewController<MKMapViewDelegate>
@property (nonatomic, retain) PFGeoPoint* postPoint;
@end
