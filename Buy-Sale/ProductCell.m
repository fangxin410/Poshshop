//
//  ProductCell.m
//  Buy-Sale
//
//  Created by Jin on 4/18/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "ProductCell.h"
#import "WebViewViewController.h"
#import "ChatView.h"
#import "ChatUserViewController.h"
@implementation ProductCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}
-(IBAction)seeMessage:(id)sender
{
    
    ChatUserViewController* chatviewController = [[ChatUserViewController alloc]initWithNibName:@"ChatUserViewController" bundle:nil];
    
    chatviewController.productId = self.ObjectId;
    
    [self.parentView presentModalViewController:chatviewController animated:YES];
    
}

@end
