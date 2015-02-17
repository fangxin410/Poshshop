//
//  AddProductViewController.m
//  Buy-Sale
//
//  Created by Jin on 4/22/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "AddProductViewController.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"

@interface AddProductViewController ()


@end

@implementation AddProductViewController

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

- (IBAction)clickshipping:(id)sender {
    
    
    self.btnShipping.selected =  !self.btnShipping.selected;
    
    
}

- (void)viewDidLoad
{
    self.imageUrlArray = [NSMutableArray arrayWithCapacity:5];
    
    
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self.locationManager startUpdatingLocation];
    
    
    [self.sv contentSizeToFit];
    [super viewDidLoad];
    [self initUI];
    [self setupGestureRecognizers];
    
    
}



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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


- (void) initUI
{
    
    [self.m_txtPrice setFont:[UIFont fontWithName:@"Gotham-Medium" size:13.0f]];
    [self.m_txtContact setFont:[UIFont fontWithName:@"Gotham-Medium" size:13.0f]];
    [self.m_txtTitle setFont:[UIFont fontWithName:@"Gotham-Medium" size:12.0f]];
    [self.btnSubmit setFont:[UIFont fontWithName:@"Nexa Bold" size:12.0f]];
    [self.btnCancel setFont:[UIFont fontWithName:@"Nexa Bold" size:12.0f]];
    
    
    
    if (self.m_selObject == nil) {
        return;
    }
    
    NSString *phone = [self.m_selObject valueForKey:@"phone"];
    [self.m_txtContact setText:phone];
    
    
    
    NSString *title = [self.m_selObject objectForKey:@"name"];
    [self.m_txtTitle setText:title];
    
    NSString *description = [self.m_selObject objectForKey:@"description"];
    [self.m_txtDescription setText:description];
    
    
    
    CGFloat price = [[self.m_selObject objectForKey:@"price"] floatValue];
    NSString *strPrice = [NSString stringWithFormat:@"%.02f", price];
    [self.m_txtPrice setText:strPrice];
    
    
    
    initimageCount = 1;
    
    NSString *imageUrl5 = [self.m_selObject valueForKey:@"image5"];
    if (imageUrl5 != nil) {
        [self.ImageView5 sd_setImageWithURL:[NSURL URLWithString:imageUrl5]
                           placeholderImage:[UIImage imageNamed:@"placeholder"] options:SDWebImageRefreshCached];
        initimageCount++;
        [self.imageUrlArray addObject:imageUrl5];
        
    }else
        [self.imageUrlArray addObject:@""];
        
    
    
    NSString *imageUrl4 = [self.m_selObject valueForKey:@"image4"];
    
    if (imageUrl4 != nil) {
        [self.ImageView4 sd_setImageWithURL:[NSURL URLWithString:imageUrl4]
                           placeholderImage:[UIImage imageNamed:@"placeholder"] options:SDWebImageRefreshCached];
        initimageCount++;
        [self.imageUrlArray addObject:imageUrl4];
        
    }else
        [self.imageUrlArray addObject:@""];
    
    
    NSString *imageUrl3 = [self.m_selObject valueForKey:@"image3"];
    if (imageUrl3 != nil) {
        [self.ImageView3 sd_setImageWithURL:[NSURL URLWithString:imageUrl3]
                           placeholderImage:[UIImage imageNamed:@"placeholder"] options:SDWebImageRefreshCached];
        initimageCount++;
        [self.imageUrlArray addObject:imageUrl3];
        
    }else
        [self.imageUrlArray addObject:@""];
    
    
    NSString *imageUrl2 = [self.m_selObject valueForKey:@"image2"];
    if (imageUrl2 != nil) {
        [self.ImageView2 sd_setImageWithURL:[NSURL URLWithString:imageUrl2]
                           placeholderImage:[UIImage imageNamed:@"placeholder"] options:SDWebImageRefreshCached];
        initimageCount++;
        [self.imageUrlArray addObject:imageUrl2];
    }else
        [self.imageUrlArray addObject:@""];
    
    
    
    NSString *imageUrl = [self.m_selObject valueForKey:@"image"];
    self.imageData1 = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:imageUrl]];
    
    [self.ImageView1 sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                   placeholderImage:[UIImage imageNamed:@"placeholder"] options:SDWebImageRefreshCached];
    
    [self.imageUrlArray addObject:imageUrl];
   
    
    NSString *imagethumbUrl = [self.m_selObject valueForKey:@"thumbimage"];
    
    [self.imageUrlArray addObject:imagethumbUrl];
    
    
    
    
   
    
    
 
    
 
    
    

    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)validateFields
{
    if (self.m_txtContact.text.length == 0) {
        [self.m_txtContact becomeFirstResponder];
        return NO;
    }
    if (self.m_txtTitle.text.length == 0) {
        [self.m_txtTitle becomeFirstResponder];
        return NO;
    }
    if (self.m_txtPrice.text.length == 0) {
        [self.m_txtPrice becomeFirstResponder];
        return NO;
    }
    
    return YES;
}

- (IBAction)saveProduct:(id)sender {
    if (![self validateFields]) {
        [[[UIAlertView alloc] initWithTitle:@"Hmm weird you forgot to fill out a few things.."
                                     message:nil
                                    delegate:nil
                           cancelButtonTitle:@"Cancel"
                           otherButtonTitles:nil] show];
        return;

    } else if (self.imageData1 == nil && self.m_selObject == nil) {
        [[[UIAlertView alloc] initWithTitle:@"Please select at least one product photos"
                                     message:nil
                                    delegate:nil
                           cancelButtonTitle:@"Cancel"
                           otherButtonTitles:nil]  show];
        return;

    } else {
    static PFFile *imageFile = nil;
    
        [SVProgressHUD showWithStatus:@"Saving..."
                             maskType:SVProgressHUDMaskTypeClear];
        
        [NSThread detachNewThreadSelector:@selector(uploadProducts) toTarget:self withObject:nil];
        
        

    }
}

-(void)uploadProducts
{
    
    void (^block)(PFFile *file) = ^(PFFile *file)
    {
        PFObject *product = nil;
        
        if (self.m_selObject == nil) {
            product = [PFObject objectWithClassName:@"Product"];
        }else
            product = self.m_selObject;
        
        
        [product setObject:[PFUser currentUser].username forKey:@"contact"];
        [product setObject:self.m_txtTitle.text forKey:@"name"];
        [product setObject:self.m_txtDescription.text forKey:@"description"];
        
        [product setObject:[NSNumber numberWithFloat:self.m_txtPrice.text.floatValue] forKey:@"price"];
        
        [product setObject:[NSNumber numberWithBool:self.btnShipping.selected] forKey:@"shipping"];
        

        
        PFGeoPoint* userLocation = [PFGeoPoint geoPointWithLatitude:self.location.coordinate.latitude longitude:self.location.coordinate.longitude];
        
        [product setObject:userLocation forKey:@"location"];
        
        
        [product setObject:self.m_txtContact.text forKey:@"phone"];
        for (int i=imageCount-1; i>=0; i--)
        {
            if (i==imageCount-1) {
                [product setObject:[self.imageUrlArray objectAtIndex:i] forKey:@"thumbimage"];
            }else if(i == imageCount-2)
            {
                [product setObject:[self.imageUrlArray objectAtIndex:i] forKey:@"image"];
            }else if(i == imageCount -3)
            {
                [product setObject:[self.imageUrlArray objectAtIndex:i] forKey:@"image2"];
            }else if(i == imageCount -4)
            {
                [product setObject:[self.imageUrlArray objectAtIndex:i] forKey:@"image3"];
            }else if(i == imageCount -5)
            {
                [product setObject:[self.imageUrlArray objectAtIndex:i] forKey:@"image4"];
            }else if(i == imageCount -6)
            {
                [product setObject:[self.imageUrlArray objectAtIndex:i] forKey:@"image5"];
            }
            
        }
        
        
        [product setObject:[NSNumber numberWithBool:NO] forKey:@"sold"];
        PFRelation *relation = [product relationforKey:@"user"];
        [relation addObject:[PFUser currentUser]];
        
        [product saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                self.m_txtTitle.text = nil;
                self.m_txtContact.text = nil;
                self.m_txtPrice.text = nil;
                [self.imageUrlArray removeAllObjects];
                [SVProgressHUD showSuccessWithStatus:@"Successfully saved！"];
                [self dismissModalViewControllerAnimated:YES];
            }
            else {
                [SVProgressHUD showErrorWithStatus:@"Save failed！"];
            }
        }];
    };
    
    PFFile *imageFile = nil;
    
    
    NSData* tmp;
    if (self.m_selObject == nil) {
        
        
        imageCount = 0;
        if (self.imageData5 != nil)
        {
            imageFile = [PFFile fileWithData:self.imageData5];
            
            [imageFile save];
            [self.imageUrlArray addObject:imageFile.url];
            tmp = self.imageData5;
            imageCount++;
        }
        
        if (self.imageData4 != nil)
        {
            imageFile = [PFFile fileWithData:self.imageData4];
            
            [imageFile save];
            [self.imageUrlArray addObject:imageFile.url];
            tmp = self.imageData4;
            imageCount++;
        }
        if (self.imageData3 != nil)
        {
            imageFile = [PFFile fileWithData:self.imageData3];
            
            [imageFile save];
            [self.imageUrlArray addObject:imageFile.url];
            tmp = self.imageData3;
            imageCount++;
        }
        if (self.imageData2 != nil)
        {
            imageFile = [PFFile fileWithData:self.imageData2];
            
            [imageFile save];
            [self.imageUrlArray addObject:imageFile.url];
            tmp = self.imageData2;
            imageCount++;
        }
        
        if (self.imageData1 != nil)
        {
            imageFile = [PFFile fileWithData:self.imageData1];
            
            [imageFile save];
            [self.imageUrlArray addObject:imageFile.url];
            tmp = self.imageData1;
            imageCount++;
        }
        
        
        
        UIImage*image = [[UIImage alloc]initWithData:tmp];
        
        CGSize newSize = CGSizeMake(150, 150*image.size.height/image.size.width);
        
        UIGraphicsBeginImageContext(newSize);
        [image drawInRect:CGRectMake(0, 0,newSize.width,newSize.height)];
        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        NSData* newData = UIImageJPEGRepresentation(newImage, 1);
        
        
        imageFile = [PFFile fileWithData:newData];
        
        [imageFile save];
        
        [self.imageUrlArray addObject:imageFile.url];
        
        imageCount++;
        
        block(imageFile);
    }else{
        
        
        
        
        if (self.imageData5 != nil)
        {
            imageFile = [PFFile fileWithData:self.imageData5];
            
            [imageFile save];
            
            [self.imageUrlArray replaceObjectAtIndex:0 withObject:imageFile.url];
            
            tmp = self.imageData5;
            
            
        }
        
        if (self.imageData4 != nil)
        {
            imageFile = [PFFile fileWithData:self.imageData4];
            
            [imageFile save];
            [self.imageUrlArray replaceObjectAtIndex:1 withObject:imageFile.url];
            
            tmp = self.imageData4;
           
            
        }
        if (self.imageData3 != nil)
        {
            imageFile = [PFFile fileWithData:self.imageData3];
            
            [imageFile save];
            [self.imageUrlArray replaceObjectAtIndex:2 withObject:imageFile.url];
            
            tmp = self.imageData3;
         
            
        }
        if (self.imageData2 != nil)
        {
            imageFile = [PFFile fileWithData:self.imageData2];
            
            [imageFile save];
            [self.imageUrlArray replaceObjectAtIndex:3 withObject:imageFile.url];
            
            tmp = self.imageData2;
            
            
        }
        
        if (self.imageData1 != nil)
        {
            imageFile = [PFFile fileWithData:self.imageData1];
            
            [imageFile save];
            [self.imageUrlArray replaceObjectAtIndex:4 withObject:imageFile.url];
            tmp = self.imageData1;
            
            
        }
        
        if (self.imageData1 != nil) {
            UIImage*image = [[UIImage alloc]initWithData:tmp];
            
            CGSize newSize = CGSizeMake(150, 150*image.size.height/image.size.width);
            
            UIGraphicsBeginImageContext(newSize);
            [image drawInRect:CGRectMake(0, 0,newSize.width,newSize.height)];
            UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            NSData* newData = UIImageJPEGRepresentation(newImage, 1);
            
            
            imageFile = [PFFile fileWithData:newData];
            
            [imageFile save];
            [self.imageUrlArray replaceObjectAtIndex:5 withObject:imageFile.url];
        }
        
        
        
        imageCount =  6;
        
        
        block(imageFile);
        
    }
    
    
    
    
    
}
- (IBAction)onCancel:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

# pragma mark - UITextField Delegate Implementation
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"Text Delegate");
    [self.m_txtContact resignFirstResponder];
    [self.m_txtPrice resignFirstResponder];
    [self.m_txtTitle resignFirstResponder];
    
    return YES;
}

#pragma mark - UIImagePicker Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    
    
    UIImage *resizedImage = image;
    CGFloat width = 300;
    CGFloat height = image.size.height / image.size.width * width;
    if (image.size.width > width) {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, [UIScreen mainScreen].scale);
        [image drawInRect:CGRectMake(0, 0, width, height)];
        resizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
   
    NSData* tmpimageData = UIImageJPEGRepresentation(resizedImage, 0.75);
    
    switch (currentIndex) {
        case 0:
            self.imageData1 =tmpimageData;
            [self.ImageView1 setImage:resizedImage];
            break;
        case 1:
            self.imageData2 =tmpimageData;
            [self.ImageView2 setImage:resizedImage];
            break;
        case 2:
            self.imageData3 =tmpimageData;
            [self.ImageView3 setImage:resizedImage];
            break;
        case 3:
            self.imageData4 =tmpimageData;
            [self.ImageView4 setImage:resizedImage ];
            break;
        case 4:
            self.imageData5 =tmpimageData;
            [self.ImageView5 setImage:resizedImage];
            break;
            
            
    }
    
    
    
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}

- (IBAction)onPickImage:(id)sender {
 
    
    currentIndex = 0;
    UIActionSheet *actions = [[UIActionSheet alloc] initWithTitle:@"Adding product main image"
                                                         delegate:self
                                                cancelButtonTitle:@"Cancel"
                                           destructiveButtonTitle:nil
                                                otherButtonTitles:@"Take Photo",@"Choose Existing", nil];
    [actions showInView:self.view.window];
}
- (IBAction)onPickImage1:(id)sender {
    
    
    currentIndex = 1;
    UIActionSheet *actions = [[UIActionSheet alloc] initWithTitle:@"Adding product image 2"
                                                         delegate:self
                                                cancelButtonTitle:@"Cancel"
                                           destructiveButtonTitle:nil
                                                otherButtonTitles:@"Take Photo",@"Choose Existing", nil];
    [actions showInView:self.view.window];
}
- (IBAction)onPickImage2:(id)sender {
    
    
    currentIndex = 2;
    UIActionSheet *actions = [[UIActionSheet alloc] initWithTitle:@"Adding product image 3"
                                                         delegate:self
                                                cancelButtonTitle:@"Cancel"
                                           destructiveButtonTitle:nil
                                                otherButtonTitles:@"Take Photo",@"Choose Existing", nil];
    [actions showInView:self.view.window];
}
- (IBAction)onPickImage3:(id)sender {
    
    
    currentIndex = 3;
    UIActionSheet *actions = [[UIActionSheet alloc] initWithTitle:@"Adding product image 4"
                                                         delegate:self
                                                cancelButtonTitle:@"Cancel"
                                           destructiveButtonTitle:nil
                                                otherButtonTitles:@"Take Photo",@"Choose Existing", nil];
    [actions showInView:self.view.window];
}
- (IBAction)onPickImage4:(id)sender {
    
    
    currentIndex = 4;
    UIActionSheet *actions = [[UIActionSheet alloc] initWithTitle:@"Adding product image 5"
                                                         delegate:self
                                                cancelButtonTitle:@"Cancel"
                                           destructiveButtonTitle:nil
                                                otherButtonTitles:@"Take Photo",@"Choose Existing", nil];
    [actions showInView:self.view.window];
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        if (buttonIndex == 0) {
            if (![UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
                [[[UIAlertView alloc] initWithTitle:@"Your device does not support photos！"
                                             message:nil
                                            delegate:nil
                                   cancelButtonTitle:@"Cancel"
                                   otherButtonTitles:nil]show];
                return;
            }
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.delegate = self;
            picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            picker.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
            [self presentModalViewController:picker
                                    animated:YES];
        }
        else {
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                [[[UIAlertView alloc] initWithTitle:@"Your device does not support！"
                                             message:nil
                                            delegate:nil
                                   cancelButtonTitle:@"Cancel"
                                   otherButtonTitles:nil] show];
                return;
            }
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentModalViewController:picker
                                    animated:YES];
        }
    }
}

@end
