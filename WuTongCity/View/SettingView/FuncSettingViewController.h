//
//  FuncSettingViewController.h
//  WuTongCity
//
//  Created by alan  on 13-8-27.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FuncSettingViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    DataCenter *dataCenter;
    UITableView *funcSettingTableView;
    
    NSMutableDictionary *funcSettingDict;//功能设置字典
    NSArray *funcSettingSectionArray;
    

}

@end
