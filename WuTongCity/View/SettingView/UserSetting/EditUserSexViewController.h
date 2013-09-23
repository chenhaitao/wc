//
//  EditUserSexViewController.h
//  WuTongCity
//
//  Created by alan  on 13-8-13.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditUserSexViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, MBProgressHUDDelegate>{
    UITableView *editUserSexTableView;
    
    MBProgressHUD *HUD;//透明指示层
    
    int sex;
    
}

@property (strong,nonatomic) UserVO *userVO;
@property (strong, nonatomic) NSMutableArray *sexArray;


- (id)initWithUserVO:(UserVO *)_userVO;

@end
