//
//  AccountMgrViewController.h
//  WuTongCity
//
//  Created by alan  on 13-9-18.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountMgrViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    UITableView *accountTableView;//屏蔽用户列表
    NSMutableArray *accountArray;
}

@end
