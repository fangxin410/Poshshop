//
//  WebViewViewController.h
//  Dealo
//
//  Created by Jin on 4/23/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductItemDelegate.h"

@interface WebViewViewController : UIViewController<UIWebViewDelegate>
{
   id<ProductItemDelegate> _delegate;
    NSString *webString;
}
@property (strong, nonatomic) IBOutlet UIWebView *m_webView;
@property (nonatomic, retain) id<ProductItemDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;
- (IBAction)onCancel:(id)sender;
@end
