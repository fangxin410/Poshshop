//
//  ChatUserViewController.h
//  Dealo
//
//  Created by admin on 8/20/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface ChatUserViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
     NSTimer * timer;
}
@property (nonatomic, strong) PFQuery *productQuery;
@property (strong, nonatomic) IBOutlet UITableView *m_allProduct;
@property (nonatomic, retain)NSString* productId;
@property (nonatomic, retain)NSMutableArray* userarray;
@end
