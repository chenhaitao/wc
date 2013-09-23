//
//  HahaViewController.h
//  WuTongCity
//
//  Created by alan  on 13-8-11.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataCenter.h"


@interface EditRealNameViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate, MBProgressHUDDelegate>{
    UITableView *editrealNameTableView;
    UITextField *realNameTextField;
    MBProgressHUD *HUD;//透明指示层
    
}

//@property(strong,nonatomic)NSArray *settingArray;
@property (strong,nonatomic) UserVO *userVO;
@property (strong, nonatomic) NSMutableArray *realNameArray;


- (id)initWithUserVO:(UserVO *)_userVO;

@end
