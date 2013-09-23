//
//  PrivacyViewController.h
//  WuTongCity
//
//  Created by alan  on 13-8-27.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrivacyViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    DataCenter *dataCenter;
    UITableView *PrivacyTableView;
    
    NSMutableDictionary *PrivacyDict;//消息信息字典
    NSArray *PrivacySectionArray;
}

@end
