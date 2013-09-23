//
//  LimitViewController.h
//  WuTongCity
//
//  Created by alan  on 13-8-27.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LimitViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate>{
    UITableView *limitTableView;//限制用户列表
    NSMutableArray *limitArray;
    
    MBProgressHUD *HUD;
}

@end
