//
//  AppDelegate.m
//  Buy-Sale
//
//  Created by Jin on 4/18/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "ChatView.h"
#import <Parse/Parse.h>
#import "MYViewController.h"

@implementation AppDelegate


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    
    self.location = currentLocation;
    
    [self.locationManager stopUpdatingLocation];
    
    
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self.locationManager startUpdatingLocation];
 

    
    NSError *error;
    
    NSString *documentsDirectory = NSTemporaryDirectory(); //2
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"usersetting.plist"]; //3
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL
    flaginit=  false;
    
    
    if (![fileManager fileExistsAtPath: path]) //4
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"usersetting" ofType:@"plist"]; //5
        
        [fileManager copyItemAtPath:bundle toPath: path error:&error]; //6
        flaginit = true;
        
        
    }
    
    
    
    self.savedUserSetting = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    
    
    
    [Parse setApplicationId:@"2KPN1mjfZIMGlfgwCSZLPDWWzzCEfI4r8HsuBxW3"     // Parse.com App ID
                  clientKey:@"VJUmDXjvpsWDkBYVk8NpKgjW5Z9vuZLYMiz6jES2"];   // Parse.com Client Key

    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
//    
//    if (flaginit) {
//        MYViewController *instuctionview = [[MYViewController alloc]init];
//        self.window.rootViewController = instuctionview;
//    }else
//    {
        MainViewController *mvc = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
        self.window.rootViewController = mvc;
//    }
    
    NSDictionary *userInfo = [launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    NSString *touserInfo = [userInfo objectForKey:@"touser"];
    NSString *productInfo = [userInfo objectForKey:@"productid"];
    if(touserInfo && [PFUser currentUser]) {
        ChatView* chatviewController = [[ChatView alloc]init];
        chatviewController.touser =touserInfo;
        chatviewController.objectId =productInfo;
        
        
        [self.window.rootViewController presentModalViewController:chatviewController animated:YES];
        
        
    }
    
    
    [self.window makeKeyAndVisible];
    

    return YES;
}
+(void) alertMsg:(NSString*) title msg:(NSString*)msg
{
    int64_t delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertview show];
    });
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
       application.applicationIconBadgeNumber = 0;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken {
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:newDeviceToken];
    
    
    PFUser* user = [PFUser currentUser];
    if (user != nil) {
        currentInstallation[@"user"] = user.username;
        currentInstallation.badge = 0;
    }
    [currentInstallation saveInBackground];
    [PFPush storeDeviceToken:newDeviceToken];
    [PFPush subscribeToChannelInBackground:@""];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Failed to register for push, %@", error);
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushNotification" object:nil userInfo:userInfo];
    
    NSString *touserInfo = [userInfo objectForKey:@"touser"];
    NSString *productInfo = [userInfo objectForKey:@"productid"];
    if(touserInfo && [PFUser currentUser]) {
        ChatView* chatviewController = [[ChatView alloc]init];
        chatviewController.touser =touserInfo;
        chatviewController.objectId =productInfo;
        
        
        [self.window.rootViewController presentModalViewController:chatviewController animated:YES];
        
        
    }

    
    
}
@end
