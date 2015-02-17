//
//  MainViewController.h
//  Buy-Sale
//
//  Created by Jin on 4/18/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

#import "SWTableViewCell.h"
#import "ChatUserViewController.h"
@interface MyListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,SWTableViewCellDelegate>
{
    
    PFObject *m_selObject;
    NSString *url;
    int flag_download;
}

@property (nonatomic, retain) PFQuery *productQuery;
@property (nonatomic, strong) NSString *keyWord;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableDictionary *unreadcounts;
@property (retain, nonatomic) IBOutlet UITableView *m_allProduct;
@property (retain, nonatomic) IBOutlet UIButton *btnCancel;

@property ( readwrite)BOOL flaginit;
- (IBAction)onCancel:(id)sender;
- (void)setupRefresh;
@end
