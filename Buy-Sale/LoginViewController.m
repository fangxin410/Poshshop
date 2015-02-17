//
//  LoginViewController.m
//  Buy-Sale
//
//  Created by Jin on 4/18/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "SVProgressHUD.h"
#import "AddProductViewController.h"
#import "ConfirmEmailViewController.h"
#import "AppDelegate.h"
@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize m_passwordField,m_usernameField;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    [self.lblAddress setFont:[UIFont fontWithName:@"Gotham-Medium" size:13.0f]];
    [self.lblPassword setFont:[UIFont fontWithName:@"Gotham-Medium" size:13.0f]];
    [self.btnRegister setFont:[UIFont fontWithName:@"Nexa Bold" size:12.0f]];
    [self.btnLogin setFont:[UIFont fontWithName:@"Nexa Bold" size:12.0f]];
    [self.btnCancel setFont:[UIFont fontWithName:@"Nexa Bold" size:12.0f]];
    
    
    [m_usernameField setValue:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    [m_passwordField setValue:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    
    m_usernameField.layer.masksToBounds=YES;
    
    m_usernameField.layer.borderColor=[[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]CGColor];
    
    m_passwordField.layer.borderColor=[[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]CGColor];
    
    m_usernameField.layer.borderWidth=1.0;
    m_passwordField.layer.borderWidth=1.0;
    
    m_passwordField.secureTextEntry = YES;
    
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)onLogin:(UIButton *)sender {
    if(self.m_usernameField.text.length == 0 || self.m_passwordField.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:@"You must enter the correct login & password to register or login, try again." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        [SVProgressHUD showWithStatus:@"Logging in ..."
                             maskType:SVProgressHUDMaskTypeNone];
        [PFUser logInWithUsernameInBackground:self.m_usernameField.text password:self.m_passwordField.text target:self selector:@selector(handleUserLogin:error:)];

    }
}

- (void)handleUserLogin:(PFUser *)user error:(NSError *)error
{
    [SVProgressHUD dismiss];
    if (error.code == 101) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:@"You must enter the correct login & password to register or login, try again." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    }else if (error.code == 100)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Network error, would you like to work offline?"
                                                       delegate:self
                                              cancelButtonTitle:@"Yes"
                                              otherButtonTitles:@"No", nil];
        
        
        [alert show];
    }
    else if (!error)
    {
        
        PFUser *user = [PFUser currentUser];
        if (![user[@"emailVerified"] boolValue])
        {
            ConfirmEmailViewController *lvc = [[ConfirmEmailViewController alloc] initWithNibName:@"ConfirmEmailViewController" bundle:nil];
            [self presentModalViewController:lvc animated:YES];
            
            
            return;
        } else {
            
             [[PFInstallation currentInstallation] setObject:[PFUser currentUser].username forKey:@"user"];
            [[PFInstallation currentInstallation] saveInBackground];
            
            [self dismissModalViewControllerAnimated:YES];
        }
        
        
        
    }
}


- (IBAction)onRegister:(id)sender {
    if(self.m_usernameField.text.length == 0 || self.m_passwordField.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Register Error" message:@"You must enter the correct login & password to register or login, try again." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        PFUser *user = [PFUser user];
        user.username = self.m_usernameField.text;
        user.password = self.m_passwordField.text;
        user.email =self.m_usernameField.text;
    
        [SVProgressHUD showWithStatus:@"Registering ..."
                         maskType:SVProgressHUDMaskTypeNone];
    
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
         
                
                [self performSelectorOnMainThread:@selector(signup_success) withObject:nil waitUntilDone:NO];
            } else {
                if (error.code == 100) { // network error
                    [AppDelegate alertMsg:@"" msg:@"Network error"];
                   
                } else if ((error.code == 202) || (error.code == 203)) {
                    [AppDelegate alertMsg:@"" msg:@"The email address is already taken by other user."];
                } else {
                    [AppDelegate alertMsg:@"Sorry, unknown error. Try again later." msg:error.description];
                }
            }
            [SVProgressHUD dismiss];
        }];

    }

}

- (void)signup_success
{
    
    PFUser *user = [PFUser currentUser];
    [user save];
    
    ConfirmEmailViewController *vc = [[ConfirmEmailViewController alloc] initWithNibName:@"ConfirmEmailViewController" bundle:nil];
    [self presentModalViewController:vc animated:YES];
   
}


- (IBAction)onClose:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)handleSignUp:(NSNumber *)result error:(NSError *)error
{
    if (!error) {
        [SVProgressHUD dismiss];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration Successful!" message:@"Congratulations, you have been susccessfully signed up." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        alert.tag = 1;
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        [self dismissModalViewControllerAnimated:YES];
    }
}
@end
