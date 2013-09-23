//
//  ResetPasswordViewController.h
//  WuTongCity
//
//  Created by chen  on 13-9-23.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataCenter.h"
#import "WZUser.h"


@interface ResetPasswordViewController : UITabBarController
{
    DataCenter *dataCenter;
    
}
@property (strong, nonatomic)UILabel *userName;//标题
@property (strong, nonatomic)UILabel *oldPass;
@property (strong, nonatomic)UILabel *newPass;
@property (strong, nonatomic)UITextField *userNameField;@property (strong, nonatomic)UITextField *oldPassword;@property (strong, nonatomic)UITextField *newPassword;
@property (strong, nonatomic) WZUser *user;

-(id) initWithUser:(WZUser *)user;
@end
