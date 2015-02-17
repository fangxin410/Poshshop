//
//  AppDelegate.h
//  Buy-Sale
//
//  Created by Jin on 4/18/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>
{
    
}
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic)NSMutableDictionary *savedUserSetting;

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *location;


+(void) alertMsg:(NSString*) title msg:(NSString*)msg;

@end
