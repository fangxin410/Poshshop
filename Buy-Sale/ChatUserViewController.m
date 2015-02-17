//
//  ChatUserViewController.m
//  Dealo
//
//  Created by admin on 8/20/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "ChatUserViewController.h"

#import "ChatView.h"
#import "AppConstant.h"

@interface ChatUserViewController ()

@end

@implementation ChatUserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.userarray = [NSMutableArray array];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(loadAllUser) userInfo:nil repeats:YES];
    
    
    // Do any additional setup after loading the view from its nib.
}
-(void) viewWillAppear:(BOOL)animated
{
    [self loadAllUser];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.userarray count];
}

- (void) loadAllUser
{
    
    
    
    self.productQuery = [PFQuery queryWithClassName:PF_CHAT_CLASS_NAME];
    [self.productQuery whereKey:@"touser"
                        equalTo:[PFUser currentUser].username];
     [self.productQuery whereKey:@"ProductId" equalTo:self.productId];
    
    PFQuery *userquery = [PFUser query];
    [userquery whereKey:@"username" matchesKey:@"fromuser" inQuery:self.productQuery];
    
    
    
    [userquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects) {
            
            [self.userarray removeAllObjects];
            
            for (PFObject *o in objects) {
                
                [self.userarray addObject:o];
                
            }
            
            
            
            [self.m_allProduct reloadData];
            
        }
        
        
        
        
    }];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    PFObject* userdata = [self.userarray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [userdata objectForKey:@"username"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PFObject* userdata = [self.userarray objectAtIndex:indexPath.row];
    
    ChatView* chatviewController = [[ChatView alloc]init];
    chatviewController.touser =[userdata objectForKey:@"username"];
    chatviewController.objectId =self.productId;
    
    
    [self presentModalViewController:chatviewController animated:YES];
    
    
}



-(IBAction)clickClose:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}
@end
