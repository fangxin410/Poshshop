//
//  SettingsViewController.m
//  Buy-Sale
//
//  Created by Jin on 4/18/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "SettingsViewController.h"
#import <Parse/Parse.h>
#import "LoginViewController.h"
#import "ConfirmEmailViewController.h"
#import "AppDelegate.h"
@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
#pragma mark Side Swiping under iOS 4.x
- (BOOL) gestureRecognizersSupported
{
    // Apple's docs: Although this class was publicly available starting with iOS 3.2, it was in development a short period prior to that
    // check if it responds to the selector locationInView:. This method was not added to the class until iOS 3.2.
    return [[[UISwipeGestureRecognizer alloc] init] respondsToSelector:@selector(locationInView:)];
}
- (void) setupGestureRecognizers
{
    // Do nothing under 3.x
    if (![self gestureRecognizersSupported]) return;
    
    // Setup a right swipe gesture recognizer
    UISwipeGestureRecognizer* rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightSwipeGestureRecognizer];
    
}

// Called when a right swipe ocurred
- (void)swipeRight:(UISwipeGestureRecognizer *)recognizer
{
    [self dismissModalViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupGestureRecognizers];
   
    NSString *documentsDirectory = NSTemporaryDirectory(); //2
    path = [documentsDirectory stringByAppendingPathComponent:@"usersetting.plist"]; //3
    
    
    _pickerData = @[@"3 miles", @"5 miles", @"10 miles", @"15 miles", @"25 miles", @"50 miles", @"100 miles", @"250 miles", @"500 miles", @"unlimited"];
    [self.picker setHidden:YES];
    [self.pickerlabel setHidden:YES];
    
    [self.btnLogout setFont:[UIFont fontWithName:@"Nexa Bold" size:12.0f]];
    [self.btnCancel setFont:[UIFont fontWithName:@"Nexa Bold" size:12.0f]];
}
-(int) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerData.count;
}
-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _pickerData[row];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    NSString* strMiles = _pickerData[row];
    
    
    
    NSString *resultString = [[NSString alloc] initWithFormat:
                              @"Display listings under %@ from the user",strMiles];
    self.pickerlabel.text = resultString;
    
    
    
    AppDelegate * app =  (AppDelegate*)[UIApplication sharedApplication].delegate;

    
    
    //here add elements to data file and write data to file
    int value = row;
    
    [app.savedUserSetting setObject:[NSNumber numberWithInt:value] forKey:@"displaymiles"];
    
    [app.savedUserSetting writeToFile: path atomically:YES];
    flagchange = true;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) viewWillAppear:(BOOL)animated
{
    PFUser * currentuser = [PFUser currentUser];
    
    
    if(![PFUser currentUser].isAuthenticated || ![currentuser[@"emailVerified"] boolValue]) {
        [self.btnLogout setTitle:@"L O G    I N" forState:UIControlStateNormal];
    } else {
        
        [self.picker setHidden:NO];
        [self.pickerlabel setHidden:NO];
        
  
        AppDelegate * app =  (AppDelegate*)[UIApplication sharedApplication].delegate;
        
        
        //load from savedStock example int value
        int displaymiles = [[app.savedUserSetting objectForKey:@"displaymiles"] intValue];
        

        [self.picker selectRow:displaymiles inComponent:0 animated:NO];
        
        NSString* milesstring;
        
        
        switch (displaymiles) {
            case 0:
                milesstring = @"3 miles";
                break;
            case 1:
                milesstring = @"5 miles";
                break;
            case 2:
                milesstring = @"10 miles";
                break;
            case 3:
                milesstring = @"15 miles";
                break;
            case 4:
                milesstring = @"25 miles";
                break;
            case 5:
                milesstring = @"50 miles";
                break;
            case 6:
                milesstring = @"100 miles";
                break;
            case 7:
                milesstring = @"250 miles";
                break;
            case 8:
                milesstring = @"500 miles";
                break;
            case 9:
                milesstring = @"unlimited";
                break;
                
                

        }
        
        NSString *resultString = [[NSString alloc] initWithFormat:
                                  @"Display listings under %@ from the user",milesstring];
        self.pickerlabel.text = resultString;
        
        
        [self.btnLogout setTitle:@"L O G    O U T" forState:UIControlStateNormal];
    }
}
- (IBAction)onLogout:(id)sender {
     PFUser * currentuser = [PFUser currentUser];
    
    if(!currentuser.isAuthenticated || ![currentuser[@"emailVerified"] boolValue]) {
        

        LoginViewController *lvc = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        [self presentModalViewController:lvc animated:YES];
    } else {
        [PFUser logOut];
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (IBAction)onClose:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
    if (flagchange) {
        [self.mainview setupRefresh];
    }
    
    
    
}
@end
