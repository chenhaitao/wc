//
//  SettingViewController.h
//  WuTongCity
//
//  Created by alan  on 13-8-11.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AboutWTYViewController.h"


@interface SettingViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    UITableView *settingTableView;
    AboutWTYViewController *aboutWTYViewController;
}

//@property(strong,nonatomic)NSArray *settingArray;
@property (strong,nonatomic) NSDictionary *sectionDict;
@property(strong,nonatomic)NSArray *settingArray;

//@property(strong, nonatomic) UserSettingViewController *uSettingViewController;

@end
