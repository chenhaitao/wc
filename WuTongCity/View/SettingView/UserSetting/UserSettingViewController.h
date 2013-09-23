//
//  UserSettingViewController.h
//  WuTongCity
//
//  Created by alan  on 13-8-11.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditRealNameViewController.h"
#import "EditNickNameViewController.h"
#import "EditUserBirthdayViewController.h"
#import "EditSignatureViewController.h"
#import "EditUserSexViewController.h"
#import "EditUserTelViewController.h"
#import "EditUserAddressViewController.h"
#import "EditUserJobViewController.h"
#import "UserVO.h"

@interface UserSettingViewController :UIViewController<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    UITableView *UserSettingTableView;//个人信息设置列表
    UserVO *userVO;//当前登录用户信息
    DataCenter *dataCenter;
    
    UIImagePickerController* pickerController;
    
}
@property (strong,nonatomic) NSDictionary *userDict;
@property (strong,nonatomic) NSArray *userSectionArray;

@property(strong, nonatomic) EditRealNameViewController *editRealNameViewController;//修改姓名页面
@property(strong, nonatomic) EditNickNameViewController *editNickNameViewController;//修改昵称页面
@property(strong, nonatomic) EditUserBirthdayViewController *editUserBirthdayViewController;//修改生日页面
@property(strong, nonatomic) EditSignatureViewController *editSignatureViewController;//修改个人签名页面
@property(strong, nonatomic) EditUserSexViewController *editUserSexViewController;//修改用户性别页面
@property(strong, nonatomic) EditUserTelViewController *editUserTelViewController;//修改手机页面
@property(strong, nonatomic) EditUserAddressViewController *editUserAddressViewController;//修改地址页面
@property(strong, nonatomic) EditUserJobViewController *editUserJobViewController;//修改地址页面


//@property (strong, nonatomic)NSString *imagePath;


@end
