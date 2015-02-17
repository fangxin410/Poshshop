//
//  MapViewController.m
//  Dealo
//
//  Created by admin on 8/14/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapview;

@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)clickclose:(id)sender {
    [self dismissModalViewControllerAnimated:NO];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    MKPointAnnotation * postuser = [[MKPointAnnotation alloc]init];
    postuser.coordinate = CLLocationCoordinate2DMake(self.postPoint.latitude, self.postPoint.longitude);
    
    [self.mapview addAnnotation:postuser];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
