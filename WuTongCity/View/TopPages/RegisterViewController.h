//
//  RegisterViewController.h
//  WutongCity
//
//  Created by alan  on 13-7-8.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCheckBox.h"
#import "AboutWTYViewController.h"

@interface RegisterViewController : UIViewController<UITextFieldDelegate,QCheckBoxDelegate, MBProgressHUDDelegate>{

    CGRect screenSize;//屏幕尺寸
    //账号输入框
    UITextField *userNameText;
    //昵称输入框
    UITextField *nickNameText;
    //密码输入框
    UITextField *userPassWordText;
    //确认密码输入框
    UITextField *aUserPassWordText;
    //验证码输入框
    UITextField *checkingCodeText;
    //验证码图片
    UIImageView *ccImageView;
    //checkbox值
    BOOL isChecked;
    
    
    MBProgressHUD *HUD;//透明指示层
    
    BOOL isCheckCode;//验证码文本框是否被点击
    
    AboutWTYViewController *aboutWTYViewController;
    
}



@end
