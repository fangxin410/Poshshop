//
//  ProductViewController.m
//  Buy-Sale
//
//  Created by Jin on 4/20/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "ProductViewController.h"
#import "UIImageView+WebCache.h"
#import "ChatView.h"
#import "MapViewController.h"
#import "LPPopup.h"
#import "UIImageView+WebCache.h"

@interface ProductViewController ()

@end

@implementation ProductViewController
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    currentIndex = 0;
    [super viewDidLoad];
    [self setupGestureRecognizers];
    
    [self initUI];
}


- (IBAction)clickpinpoint:(id)sender {
    
    
    
    
    
    PFGeoPoint* userLocation = [m_selProduct valueForKey:@"location"];
    if (userLocation) {
        
        MapViewController* mapview = [[MapViewController alloc]initWithNibName:@"MapViewController" bundle:nil];
        mapview.postPoint = userLocation;
        [self presentModalViewController:mapview animated:YES];
        
    }
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
    
    
    UISwipeGestureRecognizer* rightSwipeGestureRecognizer1 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight1:)];
    rightSwipeGestureRecognizer1.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightSwipeGestureRecognizer1];
    
    
    // Setup a right swipe gesture recognizer
    UISwipeGestureRecognizer* rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.rootview addGestureRecognizer:rightSwipeGestureRecognizer];
    
    
    // Setup a right swipe gesture recognizer
    UISwipeGestureRecognizer* leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.rootview addGestureRecognizer:leftSwipeGestureRecognizer];
    
    
}

// Called when a right swipe ocurred
- (void)swipeRight1:(UISwipeGestureRecognizer *)recognizer
{
    [self dismissModalViewControllerAnimated:YES];
}

// Called when a right swipe ocurred
- (void)swipeRight:(UISwipeGestureRecognizer *)recognizer
{
    currentIndex--;
    
    if (currentIndex < 0) {
        currentIndex = countimage-1;
    }
    switch (currentIndex) {
        case 0:
            [self.view bringSubviewToFront:self.image1];
            break;
        case 1:
            [self.view bringSubviewToFront:self.image2];
            break;
        case 2:
            [self.view bringSubviewToFront:self.image3];
            break;
        case 3:
            [self.view bringSubviewToFront:self.image4];
            
            break;
            
        case 4:
            [self.view bringSubviewToFront:self.image5];
            break;
            
            
            
    }
    
    [self.pagecontrol setCurrentPage:currentIndex];
    
    [self.view bringSubviewToFront:self.rootview];
    [self.view bringSubviewToFront:self.btnCancel];
    
    [self.view bringSubviewToFront:self.pagecontrol];
    [self.view bringSubviewToFront:self.lblDistance];
    [self.view bringSubviewToFront:self.btnPin];
    
    

    
}

- (void)swipeLeft:(UISwipeGestureRecognizer *)recognizer
{
    
    
    currentIndex++;
    
    if (currentIndex > countimage-1) {
        currentIndex = 0;
    }
    switch (currentIndex) {
        case 0:
            [self.view bringSubviewToFront:self.image1];
            break;
        case 1:
            [self.view bringSubviewToFront:self.image2];
            break;
        case 2:
            [self.view bringSubviewToFront:self.image3];
            break;
        case 3:
            [self.view bringSubviewToFront:self.image4];
            
            break;
            
        case 4:
            [self.view bringSubviewToFront:self.image5];
            break;
            
            
            
    }
    [self.pagecontrol setCurrentPage:currentIndex];
    
    [self.view bringSubviewToFront:self.rootview];
    [self.view bringSubviewToFront:self.btnCancel];
    [self.view bringSubviewToFront:self.pagecontrol];
    [self.view bringSubviewToFront:self.lblDistance];
    [self.view bringSubviewToFront:self.btnPin];

}





-(void) initUI
{
    m_selProduct = [delegate getProduct];
    
    
    
    NSString *dist = [m_selProduct valueForKey:@"contact"];
    [self.lblDistance setText:dist];
    
    
    NSString *title = [m_selProduct valueForKey:@"name"];
    [self.lblTitle setText:title];
    

    
    CGFloat price = [[m_selProduct objectForKey:@"price"] floatValue];
    NSString *strPrice = [NSString stringWithFormat:@"$%.02f", price];
    [self.lblPrice setText:strPrice];
    
    
  
    
    countimage = 1;
    NSString *imageUrl = [m_selProduct valueForKey:@"image"];
    
    [self.image1 sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                           placeholderImage:[UIImage imageNamed:@"placeholder"] options:SDWebImageRefreshCached];
    
   
    
    
    
  
    NSString *imageUrl4 = [m_selProduct valueForKey:@"image4"];
    
   
    
    NSString *imageUrl2 = [m_selProduct valueForKey:@"image2"];
    if (imageUrl2 != nil) {
        if (![imageUrl2 isEqualToString:@""]) {
            [self.image2 sd_setImageWithURL:[NSURL URLWithString:imageUrl2]
                           placeholderImage:[UIImage imageNamed:@"placeholder"] options:SDWebImageRefreshCached];
            countimage++;
        }
        
        
    }
    
    
    NSString *imageUrl3 = [m_selProduct valueForKey:@"image3"];
    if (imageUrl3 != nil) {
        if (![imageUrl3 isEqualToString:@""]) {
            [self.image3 sd_setImageWithURL:[NSURL URLWithString:imageUrl3]
                           placeholderImage:[UIImage imageNamed:@"placeholder"] options:SDWebImageRefreshCached];
            countimage++;

        }
        
    }
    
    if (imageUrl4 != nil) {
        if (![imageUrl4 isEqualToString:@""]) {
            [self.image4 sd_setImageWithURL:[NSURL URLWithString:imageUrl4]
                           placeholderImage:[UIImage imageNamed:@"placeholder"] options:SDWebImageRefreshCached];
            countimage++;
        }
        
        
    }
    
    NSString *imageUrl5 = [m_selProduct valueForKey:@"image5"];
    if (imageUrl5 != nil) {
        if (![imageUrl5 isEqualToString:@""]) {
            [self.image5 sd_setImageWithURL:[NSURL URLWithString:imageUrl5]
                           placeholderImage:[UIImage imageNamed:@"placeholder"] options:SDWebImageRefreshCached];
            countimage++;
            

        }
        
    }
    
    [self.pagecontrol setNumberOfPages:countimage];
    
//    
//    NSURL *imageUrl = [m_selProduct valueForKey:@"image"];
//    [self.imgProduct setImageWithURL:imageUrl];
//    [[self.imgProduct layer] setCornerRadius:5.0f];
//    [[self.imgProduct layer] setMasksToBounds:YES];
    
    
    if ([[m_selProduct valueForKey:@"contact"] isEqualToString:[PFUser currentUser].username]) {
        [self.btnContact setHidden:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onCancel:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)onContact:(id)sender {
    
    if ([PFUser currentUser] == nil) {
        [[[UIAlertView alloc] initWithTitle:@"You must signin!"
                                    message:nil
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        
        return;
    }
    UIActionSheet *actions = [[UIActionSheet alloc] initWithTitle:@""
                                                         delegate:self
                                                cancelButtonTitle:@"Cancel"
                                           destructiveButtonTitle:nil
                                                otherButtonTitles:@"Call", @"Chat", nil];
    [actions showInView:self.view];
    
}

#pragma mark - MFMessage Delegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissModalViewControllerAnimated:YES];
}
#pragma mark - UIActionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        switch (buttonIndex) {
            case 0:
            {
                NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", [m_selProduct valueForKey:@"phone"]]];
                if ([[UIApplication sharedApplication] canOpenURL:telURL]) {
                    [[UIApplication sharedApplication] openURL:telURL];
                }
                else {
                    [[[UIAlertView alloc] initWithTitle:@"Your device does not support a call!"
                                                 message:nil
                                                delegate:nil
                                       cancelButtonTitle:@"Cancel"
                                       otherButtonTitles:nil] show];
                }
            }
                break;
            case 1:
            {
                
                
                ChatView* chatviewController = [[ChatView alloc]init];
                chatviewController.touser =[m_selProduct valueForKey:@"contact"];
                chatviewController.objectId =[m_selProduct valueForKey:@"objectId"];
                
                
                [self presentModalViewController:chatviewController animated:YES];

                
                
            }
                break;
            default:
                break;
        }
    }

}


- (IBAction)onMore:(id)sender
{
    NSString* desc = [m_selProduct objectForKey:@"description"];
    
    LPPopup *popup = [LPPopup popupWithText:desc];
    
    [popup showInView:self.view
        centerAtPoint:self.view.center
             duration:kLPPopupDefaultWaitDuration
           completion:nil];
}
@end
