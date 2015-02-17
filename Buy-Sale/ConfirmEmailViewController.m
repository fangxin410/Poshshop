//
//  ConfirmEmailViewController.m
//  ShareTasks
//
//  Created by Admin on 6/7/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import "ConfirmEmailViewController.h"
#import "AppDelegate.h"



#import <Parse/Parse.h>

@interface ConfirmEmailViewController () {
    IBOutlet UITextField            *m_txtEmail;
    UITextField             *txtActived;
}

@end

@implementation ConfirmEmailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    m_txtEmail.text = [PFUser currentUser].email;
}
- (IBAction)clickcancel:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onClickedResend:(id)sender
{
    PFUser *user = [PFUser currentUser];
    
   
    

    NSString *strEmail = m_txtEmail.text;
    
    if (strEmail.length == 0) {
        [AppDelegate alertMsg:@"" msg:@"Please input email address"];
        return;
    }
    
    if (user == nil) {
       
        NSString *strEmail = m_txtEmail.text;
        
        return;
    }
    NSError *error = nil;
    if (![user[@"emailVerified"] boolValue]) {
        PFUser *user = [PFUser currentUser];
        user.email = strEmail;
        user.username = strEmail;
        [user save:&error];
        if (error) {
            NSString *str = error.description;
            NSLog(@"%@", str);
        } else {
            if (![user[@"emailVerified"] boolValue])
            {
                [AppDelegate alertMsg:@"" msg:@"You must verify your email address to use this app."];
                return;
            } else {
                
                
            }
        }
    }
}

- (IBAction)onClickedChangeEmail:(id)sender
{
    NSString *strEmail = m_txtEmail.text;
    
    NSError *error = nil;
    if (strEmail.length == 0) {
        [AppDelegate alertMsg:@"" msg:@"Confirm email address must matches email address."];
        return;
    } else {
        PFUser *user = [PFUser currentUser];
        user.email = strEmail;
        user.username = strEmail;
        [user save:&error];
        if (error)
            [AppDelegate alertMsg:@"" msg:@"Sorry, the email can't be changed for now. Please try again later."];
        else
            [AppDelegate alertMsg:@"" msg:@"Your email address has been changed successfully."];
    }
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

@end
