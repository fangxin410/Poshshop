//
//  ProductViewController.h
//  Buy-Sale
//
//  Created by Jin on 4/20/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <Parse/Parse.h>
#import "ProductItemDelegate.h"



@interface ProductViewController : UIViewController <UIActionSheetDelegate, MFMessageComposeViewControllerDelegate>
{
    PFObject *m_selProduct;
    int currentIndex;
    int countimage;
    id<ProductItemDelegate> _delegate;
}
@property (weak, nonatomic) IBOutlet UIButton *btnPin;

@property (strong, nonatomic) IBOutlet UIView *rootview;
@property (strong, nonatomic) IBOutlet UILabel *lblDistance;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblPrice;
@property ( readwrite)  BOOL shipped;
@property (strong, nonatomic) IBOutlet UIPageControl *pagecontrol;

@property (strong, nonatomic) IBOutlet UIImageView *image1;
@property (strong, nonatomic) IBOutlet UIImageView *image2;
@property (strong, nonatomic) IBOutlet UIImageView *image3;
@property (strong, nonatomic) IBOutlet UIImageView *image4;
@property (strong, nonatomic) IBOutlet UIImageView *image5;

- (IBAction)onCancel:(id)sender;
- (IBAction)onContact:(id)sender;
- (IBAction)onMore:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnCancel;
@property (strong, nonatomic) IBOutlet UIButton *btnContact;
@property (nonatomic, retain) id<ProductItemDelegate> delegate;

@end
