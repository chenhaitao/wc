//
//  EditUserTelViewController.h
//  WuTongCity
//
//  Created by alan  on 13-8-13.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditUserTelViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate,MBProgressHUDDelegate>{
    UITableView *editUserTelTableView;
    UITextField *userTelTextField;
    MBProgressHUD *HUD;//透明指示层
    
}

//@property(strong,nonatomic)NSArray *settingArray;
@property (strong,nonatomic) UserVO *userVO;
@property (strong, nonatomic) NSMutableArray *userTelArray;


- (id)initWithUserVO:(UserVO *)_userVO;

@end
