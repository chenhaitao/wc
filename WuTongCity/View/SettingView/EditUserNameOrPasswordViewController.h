//
//  EditUserNameOrPasswordViewController.h
//  WuTongCity
//
//  Created by 陈 海涛 on 13-9-23.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZUser.h"

@interface EditUserNameOrPasswordViewController : UIViewController<UITextFieldDelegate>
{
MBProgressHUD *HUD;
}
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;

@property (nonatomic,strong) WZUser *user;
@end
