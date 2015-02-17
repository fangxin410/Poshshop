//
//  AddProductViewController.h
//  Buy-Sale
//
//  Created by Jin on 4/22/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "TPKeyboardAvoidingScrollView.h"
#import <Parse/Parse.h>
@interface AddProductViewController : UIViewController <UITextFieldDelegate, UIScrollViewDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate, CLLocationManagerDelegate>
{
    BOOL keyboardIsShown;
    UITextField *currentTextField;
    int currentIndex;
    int imageCount;
    int initimageCount;
    
}
@property (strong, nonatomic)PFObject *m_selObject;
@property (weak, nonatomic) IBOutlet UIButton *btnShipping;

@property (strong, nonatomic) IBOutlet UIButton *btnCancel;
@property (strong, nonatomic) IBOutlet UIButton *btnSubmit;
@property (strong, nonatomic) IBOutlet UITextField *m_txtContact;
@property (strong, nonatomic) IBOutlet UITextField *m_txtTitle;
@property (strong, nonatomic) IBOutlet UITextField *m_txtPrice;
@property (strong, nonatomic) IBOutlet UITextField *m_txtDescription;


@property (nonatomic, strong) NSData* imageData1;

@property (nonatomic, strong) NSData* imageData2;

@property (nonatomic, strong) NSData* imageData3;

@property (nonatomic, strong) NSData* imageData4;

@property (nonatomic, strong) NSData* imageData5;

@property (nonatomic, strong) NSMutableArray* imageUrlArray;
@property (strong, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *sv;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *location;

- (IBAction)saveProduct:(id)sender;
- (IBAction)onCancel:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *productImage;
@property (strong, nonatomic) IBOutlet UIButton *productImage1;
@property (strong, nonatomic) IBOutlet UIButton *productImage2;
@property (strong, nonatomic) IBOutlet UIButton *productImage3;
@property (strong, nonatomic) IBOutlet UIButton *productImage4;


@property (strong, nonatomic) IBOutlet UIImageView *ImageView5;
@property (strong, nonatomic) IBOutlet UIImageView *ImageView1;
@property (strong, nonatomic) IBOutlet UIImageView *ImageView2;
@property (strong, nonatomic) IBOutlet UIImageView *ImageView3;
@property (strong, nonatomic) IBOutlet UIImageView *ImageView4;


- (IBAction)onPickImage:(id)sender;
@end
