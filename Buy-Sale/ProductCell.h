//
//  ProductCell.h
//  Buy-Sale
//
//  Created by Jin on 4/18/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "SWTableViewCell.h"

@interface ProductCell : SWTableViewCell
{
    BOOL isMine;
}
@property (strong, nonatomic) IBOutlet PFImageView *m_productImage;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblPrice;
@property (strong, nonatomic) NSString *ObjectId;
@property (strong, nonatomic) IBOutlet UIButton *btnUser;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView 	*loadIndicatorView;
@property (strong, nonatomic) IBOutlet UIButton *btnShip;
@property (strong, nonatomic) IBOutlet UIButton *btnSeemessage;
@property (strong, nonatomic) IBOutlet UILabel *countunreadmessage;
@property (strong, nonatomic) UIViewController* parentView;
@end
