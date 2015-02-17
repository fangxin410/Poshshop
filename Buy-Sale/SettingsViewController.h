//
//  SettingsViewController.h
//  Buy-Sale
//
//  Created by Jin on 4/18/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
@interface SettingsViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSArray * _pickerData;
    NSString *path ;
    BOOL flagchange;
}
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;
@property (strong, nonatomic) IBOutlet UIButton *btnLogout;
@property (strong, nonatomic) IBOutlet UIPickerView* picker;
@property (strong, nonatomic) IBOutlet UILabel* pickerlabel;
@property (strong, nonatomic) MainViewController* mainview;

- (IBAction)onLogout:(id)sender;

- (IBAction)onClose:(id)sender;
@end
