//
//  WutongCityViewController.h
//  WutongCity
//
//  Created by alan  on 13-7-7.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MIN_Y 100.0
#define MAX_Y 150.0

@interface LoginViewController : UIViewController<UITextFieldDelegate, MBProgressHUDDelegate>{
    UITextField *userNameText;//账号输入框
    UITextField *userPassWordText;//密码输入框
    UIView *loginView;
    MBProgressHUD *HUD;//透明指示层
    
    

    BOOL isLogin;//openfire
}
@end
