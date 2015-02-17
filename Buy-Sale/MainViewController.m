//
//  MainViewController.m
//  Buy-Sale
//
//  Created by Jin on 4/18/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "MainViewController.h"
#import <Parse/Parse.h>
#import "ProductCell.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "UIImageView+WebCache.h"
#import "SettingsViewController.h"
#import "ProductViewController.h"
#import "AddProductViewController.h"
#import "MyListViewController.h"
#import "MYViewController.h"
#import "WebViewViewController.h"
#import "MJRefresh.h"
#import "PhotoRecord.h"
#import "GalleryCell.h"



@interface MainViewController ()
@property (strong, nonatomic) IBOutlet UIProgressView *progressdownload;

@end

@implementation MainViewController
@synthesize photos = _photos;



- (void)searchBar:(UISearchBar *)sBar textDidChange:(NSString *)searchText
{
    if ([searchText isEqualToString:@""]) {
        self.keyWord = nil;
    }else
    {
        self.keyWord = searchText;
    }
    
    [self loadAllProduct];
    
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    
    [self.m_allProduct registerNib:[UINib nibWithNibName:@"GalleryCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    
    
    
    [self.progressdownload setProgress:0];
    
   
    [self initParse];
    [self initUI];
    [self loadAllProduct];
    [self setupRefresh];
    
    
   
    
    

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
    if ([PFUser currentUser] != nil) {
         [[PFInstallation currentInstallation] setObject:[PFUser currentUser] forKey:@"user"];
        [[PFInstallation currentInstallation] saveInBackground];
        
    }
   
    
    
    [[PFInstallation currentInstallation] saveEventually];
}

- (void) viewWillAppear:(BOOL)animated
{
    int badgenumber = [UIApplication sharedApplication].applicationIconBadgeNumber;
    if (badgenumber != 0) {
        [self.btnListing setBadgeValue:[NSString stringWithFormat:@"%d" ,badgenumber]];
    }else
    {
        [self.btnListing setBadgeValue:nil];
    }

    [self loadAllProduct];
}
- (void) initUI
{
    
    
}
- (void) loadAllProduct
{
    
    
    
    
    self.productQuery = [PFQuery queryWithClassName:@"Product"];
    [self.productQuery whereKey:@"sold"
                     notEqualTo:[NSNumber numberWithBool:YES]];
    
    // Incluse own product list.
//    if ([PFUser currentUser].isAuthenticated)
//        [self.productQuery whereKey:@"user"
//                         notEqualTo:[PFUser currentUser]];
    if (self.keyWord)
        [self.productQuery whereKey:@"name"
                     containsString:self.keyWord];
    [self.productQuery orderByDescending:@"createAt"];
    
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [self.productQuery setLimit:10000];
    
    PFGeoPoint* userLocation = [PFGeoPoint geoPointWithLatitude:app.location.coordinate.latitude longitude:app.location.coordinate.longitude];
    
    
    //load from savedStock example int value
    int displaymiles = [[app.savedUserSetting objectForKey:@"displaymiles"] intValue];
    
    double nearMiles = -1;
    
    
    switch (displaymiles) {
        case 0:
            nearMiles = 3;
            break;
        case 1:
            nearMiles = 5;
            break;
        case 2:
            nearMiles = 10;
            break;
        case 3:
            nearMiles = 15;
            break;
        case 4:
            nearMiles = 25;
            break;
        case 5:
            nearMiles = 50;
            break;
        case 6:
            nearMiles = 100;
            break;
        case 7:
            nearMiles = 250;
            break;
        case 8:
            nearMiles = 500;
            break;
        case 9:
            nearMiles = -1;
            break;
            
    }
    if (nearMiles != -1) {
        [self.productQuery whereKey:@"location" nearGeoPoint:userLocation withinMiles:nearMiles];
    }
    [self.progressdownload setHidden:NO];
    [self.progressdownload setProgress:0.3];
    timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(progressForDownload) userInfo:nil repeats:YES];
    
    
    
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
                record.shipped = [[o objectForKey:@"shipping"] boolValue];
                
                //                record.saleprice = [tmp objectForKey:@"saleprice"];
                //                NSString* sizeindex = [tmp objectForKey:@"sizeid"];
                
                //                record.itemsize = [app.sizeArray objectAtIndex:sizeindex.intValue];
                
                NSLog(@"url - %@", record.URL);
                
                [records addObject:record];
                record = nil;
                
                
            }
            
            
            self.photos = records;
            
            NSLog(@"count - %d", self.photos.count);
            NSLog(@"count - %d", objects.count);
            
            
            
            [SDWebImageManager sharedManager].imageDownloader.username = @"httpwatch";
            [SDWebImageManager sharedManager].imageDownloader.password = @"httpwatch01";

            [SDWebImageManager.sharedManager.imageDownloader setValue:@"SDWebImage Demo" forHTTPHeaderField:@"AppName"];
            SDWebImageManager.sharedManager.imageDownloader.executionOrder = SDWebImageDownloaderLIFOExecutionOrder;
            
            
            
            
            [self.m_allProduct reloadData];
            [self.progressdownload setProgress:1.0];
            [self.progressdownload setHidden:YES];
        }
        self.productQuery = nil;
        
        [self.m_allProduct headerEndRefreshing];

    }];
    
}
-(void)progressForDownload
{
    [self.progressdownload setProgress:(self.progressdownload.progress+0.01)];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - All Product Table Delategate and Datasource

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section { return UIEdgeInsetsMake(10, 10, 10, 10); }


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    NSInteger count = self.photos.count;
    return count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {	return CGSizeMake(140, 216); }



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GalleryCell *cell = [self.m_allProduct dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

    
    
    
    PhotoRecord *aRecord = [self.photos objectAtIndex:indexPath.row];
    
    
    
    
    [cell.loadIndicatorView stopAnimating];
    [cell.picView sd_setImageWithURL:[NSURL URLWithString:aRecord.ThumbURL]
                          placeholderImage:[UIImage imageNamed:@"placeholder"] options:indexPath.row == 0 ? SDWebImageRefreshCached : 0];

    
    cell.itemtitle.text = aRecord.name;
    cell.postuser.text = [NSString stringWithFormat:@"by %@",aRecord.contact];
    
    cell.saleprice.text = [NSString stringWithFormat:@"$%@",aRecord.price];
        
        
    
//    
//    
//    [cell.m_productImage sd_setImageWithURL:[NSURL URLWithString:aRecord.URL]
//                      placeholderImage:[UIImage imageNamed:@"placeholder"] options:indexPath.row == 0 ? SDWebImageRefreshCached : 0];
    
    
    return cell;
}


#pragma mark -
#pragma mark - Operations

// 1: To keep it simple, you pass in an instance of PhotoRecord that requires operations, along with its indexPath.
- (void)startOperationsForPhotoRecord:(PhotoRecord *)record atIndexPath:(NSIndexPath *)indexPath {
    
    // 2: You inspect it to see whether it has an image; if so, then ignore it.
    if (!record.hasImage) {
        
        // 3: If it does not have an image, start downloading the image by calling startImageDownloadingForRecord:atIndexPath: (which will be implemented shortly). Youíll do the same for filtering operations: if the image has not yet been filtered, call startImageFiltrationForRecord:atIndexPath: (which will also be implemented shortly).
        [self startImageDownloadingForRecord:record atIndexPath:indexPath];
        
    }
    
    
    
}

- (void)startImageDownloadingForRecord:(PhotoRecord *)record atIndexPath:(NSIndexPath *)indexPath {
    
    // 1: First, check for the particular indexPath to see if there is already an operation in downloadsInProgress for it. If so, ignore it.
    if (![self.pendingOperations.downloadsInProgress.allKeys containsObject:indexPath]) {
        
        // 2: If not, create an instance of ImageDownloader by using the designated initializer, and set ListViewController as the delegate. Pass in the appropriate indexPath and a pointer to the instance of PhotoRecord, and then add it to the download queue. You also add it to downloadsInProgress to help keep track of things.
        // Start downloading
        ImageDownloader *imageDownloader = [[ImageDownloader alloc] initWithPhotoRecord:record atIndexPath:indexPath delegate:self];
        [self.pendingOperations.downloadsInProgress setObject:imageDownloader forKey:indexPath];
        [self.pendingOperations.downloadQueue addOperation:imageDownloader];
    }
}


- (void)startImageFiltrationForRecord:(PhotoRecord *)record atIndexPath:(NSIndexPath *)indexPath {
    
    // 3: If not, create an instance of ImageDownloader by using the designated initializer, and set ListViewController as the delegate. Pass in the appropriate indexPath and a pointer to the instance of PhotoRecord, and then add it to the download queue. You also add it to downloadsInProgress to help keep track of things.
    if (![self.pendingOperations.filtrationsInProgress.allKeys containsObject:indexPath]) {
        
        // 4: If not, start one by using the designated initializer.
        // Start filtration
        ImageFiltration *imageFiltration = [[ImageFiltration alloc] initWithPhotoRecord:record atIndexPath:indexPath delegate:self];
        
        // 5: This one is a little tricky. You first must check to see if this particular indexPath has a pending download; if so, you make this filtering operation dependent on that. Otherwise, you donít need dependency.
        ImageDownloader *dependency = [self.pendingOperations.downloadsInProgress objectForKey:indexPath];
        if (dependency)
            [imageFiltration addDependency:dependency];
        
        [self.pendingOperations.filtrationsInProgress setObject:imageFiltration forKey:indexPath];
        [self.pendingOperations.filtrationQueue addOperation:imageFiltration];
    }
}

#pragma mark -
#pragma mark - ImageDownloader delegate


- (void)imageDownloaderDidFinish:(ImageDownloader *)downloader {
    
    // 1: Check for the indexPath of the operation, whether it is a download, or filtration.
    NSIndexPath *indexPath = downloader.indexPathInTableView;
    
    // 2: Get hold of the PhotoRecord instance.
    PhotoRecord *theRecord = downloader.photoRecord;
    
    // 3: Replace the updated PhotoRecord in the main data source (Photos array).
    [self.photos replaceObjectAtIndex:indexPath.row withObject:theRecord];
    
    // 4: Update UI.
    [self.m_allProduct reloadItemsAtIndexPaths: [NSArray arrayWithObject:indexPath]];
    
    // 5: Remove the operation from downloadsInProgress (or filtrationsInProgress).
    [self.pendingOperations.downloadsInProgress removeObjectForKey:indexPath];
}





- (void) onWebView:(id) sender
{
    
    UIButton *button = (UIButton *) sender;
    url = [button titleForState:UIControlStateNormal];
    
    if ([MFMailComposeViewController canSendMail]) {
        NSArray * toRecipents = [NSArray arrayWithObject:url];
        
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setToRecipients:toRecipents];
        [controller setSubject:@""];
        [controller setMessageBody:@"" isHTML:NO];
        if (controller) [self presentModalViewController:controller animated:YES];
    }
    
   
    
}



- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}


-(void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    PhotoRecord* selected =[self.photos objectAtIndex:indexPath.row];
    m_selObject = selected.m_Object;
    m_selIndex = indexPath;
    NSLog(@"%d", m_selIndex.row);
    ProductViewController *pvc = [[ProductViewController alloc] initWithNibName:@"ProductViewController" bundle:nil];
    pvc.delegate = self;
    pvc.shipped = selected.shipped;
    [self presentModalViewController:pvc animated:YES];

}

- (void)onListing {
    
    
    if(![PFUser currentUser].isAuthenticated) {
        LoginViewController *lvc = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        [self presentModalViewController:lvc animated:YES];
    } else {
        MyListViewController *mlvc = [[MyListViewController alloc] initWithNibName:@"MyListViewController" bundle:nil];
        [self presentModalViewController:mlvc animated:YES];
    }
}

- (void)onSettings {
    
    
    SettingsViewController *svc = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    svc.mainview = self;
    [self presentModalViewController:svc animated:YES];
}

- (void)onAddProduct{
 
    
    
    if(![PFUser currentUser].isAuthenticated || ![[PFUser currentUser][@"emailVerified"] boolValue]) {
        LoginViewController *lvc = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        [self presentModalViewController:lvc animated:YES];
    } else {
        
        
        AddProductViewController *apvc = [[AddProductViewController alloc] initWithNibName:@"AddProductViewController" bundle:nil];
        [self presentModalViewController:apvc animated:YES];
    }
}

#pragma mark - ProductItemDelegae
- (void) setProductItem:(PFObject *)obj {
    m_selObject = obj;
}

-(PFObject *) getProduct
{
    return m_selObject;
}
-(NSString *) getUrl
{
    return url;
}



-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    int selectedTag = tabBar.selectedItem.tag;
    
    if (selectedTag == 0) {
        
        [self onListing];
    }else if(selectedTag == 1)
    {
        [self onAddProduct];
        
    }else if(selectedTag ==2)
    {
        [self onSettings];
    }
}

@end
