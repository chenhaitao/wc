//
//  ShieldingViewController.h
//  WuTongCity
//
//  Created by alan  on 13-8-27.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "ParamButton.h"

@interface ShieldingViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate>{
    UITableView *shieldingTableView;//屏蔽用户列表
    NSMutableArray *shieldingArray;
    DataCenter *dataCenter;
    
    MBProgressHUD *HUD;
}

@end
