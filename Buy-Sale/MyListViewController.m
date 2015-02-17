//
//  MainViewController.m
//  Buy-Sale
//
//  Created by Jin on 4/18/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "MyListViewController.h"
#import <Parse/Parse.h>
#import "ProductCell.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "SettingsViewController.h"
#import "ProductViewController.h"
#import "AddProductViewController.h"
#import "MyListViewController.h"
#import "MYViewController.h"
#import "WebViewViewController.h"
#import "MJRefresh.h"
#import "PhotoRecord.h"
#import "ChatView.h"

@interface MyListViewController ()
@property (strong, nonatomic) IBOutlet UIProgressView *progressdownload;
@property (nonatomic) BOOL useCustomCells;
@property (nonatomic, weak) UIRefreshControl *refreshControl;


@end

@implementation MyListViewController
@synthesize photos = _photos;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
- (IBAction)onCancel:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"ProductCell" bundle:nil];
    [self.m_allProduct registerNib:nib forCellReuseIdentifier:@"ProductCellIdentifier"];
    
     [self setupGestureRecognizers];
    [self setupRefresh];
    
    [self initParse];
    [self initUI];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.progressdownload setProgress:0];
    
    
    [self loadAllProduct];
    

    
}
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.m_allProduct addHeaderWithTarget:self action:@selector(headerRereshing)];
#warning 自动刷新(一进入程序就下拉刷新)
    [self.m_allProduct headerBeginRefreshing];
    
    
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.m_allProduct.headerPullToRefreshText = @"refresh all product";
    self.m_allProduct.headerReleaseToRefreshText = @"refresh data";
    self.m_allProduct.headerRefreshingText = @"pulling data.";
    
}

- (void)headerRereshing
{
    [self loadAllProduct];
}


- (void)initParse
{
    
    PFACL *defaultACL = [PFACL ACL];
    
    [defaultACL setPublicReadAccess:YES];
    [defaultACL setPublicWriteAccess:YES];
    
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    
    [[PFInstallation currentInstallation] saveEventually];
}



-(void)viewWillDisappear:(BOOL)animated
{
    
}
- (void) initUI
{
    [self.btnCancel setFont:[UIFont fontWithName:@"Nexa Bold" size:12.0f]];
    
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

- (void) loadAllProduct
{
    self.unreadcounts = [NSMutableDictionary dictionary];
    
    
    self.productQuery = [PFQuery queryWithClassName:@"Product"];

    
    [self.productQuery whereKey:@"contact"
                        equalTo:[PFUser currentUser].username];
    
    [self.productQuery orderByDescending:@"createAt"];
    
    [self.progressdownload setHidden:NO];
    [self.progressdownload setProgress:0.3];
    
    static countcheck=0;
    
    
    [self.productQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects) {
            
            NSMutableArray *records = [NSMutableArray array];
            
            for (PFObject *o in objects) {
                PhotoRecord *record = [[PhotoRecord alloc] init];
                
                record.m_Object =  o;
                
                NSString *imageUrl = [o valueForKey:@"image"];
                NSString *imageUrl2 = [o valueForKey:@"image2"];
                NSString *imageUrl3 = [o valueForKey:@"image3"];
                NSString *thumbUrl = [o valueForKey:@"thumbimage"];
                
                NSString *distance = [o valueForKey:@"contact"];
                //                [cell.btnUser addTarget:self action:@selector(onWebView:) forControlEvents:UIControlEventTouchUpInside];
                
                NSString *title = [o valueForKey:@"name"];
                
                CGFloat price = [[o  objectForKey:@"price"] floatValue];
                NSString *strPrice = [NSString stringWithFormat:@"$%.02f", price];
                
                //                record.nID =[tmp objectForKey:@"id"];
                record.URL = imageUrl;
                record.URL2 = imageUrl2;
                record.URL3 = imageUrl3;
                record.name = title;
                record.contact = distance;
                record.price = strPrice;
                record.ThumbURL = thumbUrl;
                record.objectId =[o valueForKey:@"objectId"];
                
                //                record.saleprice = [tmp objectForKey:@"saleprice"];
                //                NSString* sizeindex = [tmp objectForKey:@"sizeid"];
                
                //                record.itemsize = [app.sizeArray objectAtIndex:sizeindex.intValue];
                
                NSLog(@"url - %@", record.URL);
                
                [records addObject:record];
                record = nil;
                
                
                
                PFQuery * countunreadquery = [PFQuery queryWithClassName:@"Chat"];
                
                
                [countunreadquery whereKey:@"touser"
                                    equalTo:[PFUser currentUser].username];
                [countunreadquery whereKey:@"ProductId" equalTo:[o valueForKey:@"objectId"]];
                [countunreadquery whereKey:@"unread" equalTo:@"1"];
                
                [countunreadquery findObjectsInBackgroundWithBlock:^(NSArray *objects1, NSError *error) {
                    if (objects1 && objects1.count > 0) {
                        NSString* strcount = [NSString stringWithFormat:@"%d",objects1.count];
                        NSString* strkey = [objects1.firstObject objectForKey:@"ProductId"];
                        
                        [self.unreadcounts setObject:strcount forKey:strkey];
                        countcheck++;
                        
                        if (countcheck == objects.count) {
                            [self.m_allProduct reloadData];
                        }
                    }
                }];
            }
            
            
            self.photos = records;
            

            [self.m_allProduct reloadData];
            [self.progressdownload setProgress:1.0];
            [self.progressdownload setHidden:YES];
        }
        self.productQuery = nil;
        
        [self.m_allProduct headerEndRefreshing];
        
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - All Product Table Delategate and Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.photos.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ProductCellIdentifier";
   
    
    
    ProductCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
   
    
    PhotoRecord *aRecord = [self.photos objectAtIndex:indexPath.row];
    
    
    [cell.btnUser setTitle:aRecord.contact forState:UIControlStateNormal];
   
    
    cell.ObjectId =aRecord.objectId;
    cell.parentView = self;
    
    NSString* strcountmsg = [self.unreadcounts objectForKey:cell.ObjectId];
    if (strcountmsg == nil || strcountmsg == [NSNull null]) {
        strcountmsg = @"0";
    }
    cell.countunreadmessage.text = [NSString stringWithFormat:@"(%@)", strcountmsg];
    
    [cell.lblTitle setText:aRecord.name];
    
    
    
    
    [cell.lblPrice setText:aRecord.price];
    
 
    
    
    [cell.m_productImage sd_setImageWithURL:[NSURL URLWithString:aRecord.ThumbURL]
                           placeholderImage:[UIImage imageNamed:@"placeholder"] options:indexPath.row == 0 ? SDWebImageRefreshCached : 0];
    
        
        
   [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:58.0f];
   cell.delegate = self;

    
    
    
    return cell;
}




- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
   
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"Delete"];
    
    return rightUtilityButtons;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    PhotoRecord *aRecord = [self.photos objectAtIndex:indexPath.row];
    

    
    AddProductViewController *apvc = [[AddProductViewController alloc] initWithNibName:@"AddProductViewController" bundle:nil];
    apvc.m_selObject = aRecord.m_Object;
    [self presentModalViewController:apvc animated:YES];
    
}

#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state
{
    switch (state) {
        case 0:
            NSLog(@"utility buttons closed");
            break;
        case 1:
            NSLog(@"left utility buttons open");
            break;
        case 2:
            NSLog(@"right utility buttons open");
            break;
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            NSLog(@"left button 0 was pressed");
            break;
        case 1:
            NSLog(@"left button 1 was pressed");
            break;
        case 2:
            NSLog(@"left button 2 was pressed");
            break;
        case 3:
            NSLog(@"left btton 3 was pressed");
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        
        case 0:
        {
            // Delete button was pressed
            NSIndexPath *cellIndexPath = [self.m_allProduct indexPathForCell:cell];
            
            m_selObject = ((PhotoRecord*)[self.photos objectAtIndex:cellIndexPath.row]).m_Object;
            [m_selObject delete];
            
            [self.photos removeObjectAtIndex:cellIndexPath.row];
            
            
            [self.m_allProduct deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
            break;
        }
        default:
            break;
    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    // allow just one cell's utility button to be open at once
    return YES;
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state
{
    switch (state) {
        case 1:
            // set to NO to disable all left utility buttons appearing
            return YES;
            break;
        case 2:
            // set to NO to disable all right utility buttons appearing
            return YES;
            break;
        default:
            break;
    }
    
    return YES;
}


@end
