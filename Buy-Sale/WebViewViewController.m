//
//  WebViewViewController.m
//  Dealo
//
//  Created by Jin on 4/23/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "WebViewViewController.h"
#import "SVProgressHUD.h"

@interface WebViewViewController ()

@end

@implementation WebViewViewController
@synthesize delegate;

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
    [self initUI];
}

- (void) initUI
{
    
    
    webString = [delegate getUrl];
    NSString *string = [NSString stringWithFormat:@"http://www.google.com/search?q=%@",webString];
    [self.btnCancel setFont:[UIFont fontWithName:@"Nexa Bold" size:12.0f]];
    NSURL *url=[NSURL URLWithString:string];
    NSURLRequest *requestObj=[NSURLRequest requestWithURL:url];
    [self.m_webView loadRequest:requestObj];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onCancel:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

-(void)webViewDidFinishLoad:(UIWebView *)webVieww
{
   [SVProgressHUD dismiss];
}
@end
