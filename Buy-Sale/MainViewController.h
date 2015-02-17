//
//  MainViewController.h
//  Buy-Sale
//
//  Created by Jin on 4/18/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ProductItemDelegate.h"
#import "PendingOperations.h"
#import "ImageDownloader.h"
#import "ImageFiltration.h"

@interface MainViewController : UIViewController <ProductItemDelegate,UITabBarDelegate,ImageDownloaderDelegate, ImageFiltrationDelegate>
{
    BOOL isSelf;
    PFObject *m_selObject;
    NSIndexPath* m_selIndex;
    NSString *url;
    NSTimer * timer;
}

@property (nonatomic, strong) PFQuery *productQuery;
@property (nonatomic, strong) NSString *keyWord;
@property (nonatomic, strong) NSIndexPath* m_selIndex;
@property (nonatomic, strong) NSMutableArray *photos; // main data

@property IBOutlet UICollectionView* m_allProduct;



@property (strong, nonatomic) IBOutlet UISearchBar *search;
@property (nonatomic, strong) NSString *stSearchtext;


@property (strong, nonatomic) IBOutlet UITabBarItem *btnListing;
@property (strong, nonatomic) IBOutlet UIButton *btnSign;
@property (strong, nonatomic) IBOutlet UIButton *btnSettings;
// 5: This property is used to track pending operations.
@property (nonatomic, strong) PendingOperations *pendingOperations;


@property ( readwrite)BOOL flaginit;
- (IBAction)onListing:(id)sender;
- (IBAction)onSettings:(id)sender;
- (IBAction)onAddProduct:(id)sender;
- (void)setupRefresh;
@end
