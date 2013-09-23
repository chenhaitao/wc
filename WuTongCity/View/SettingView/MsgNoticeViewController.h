//
//  MsgNoticeViewController.h
//  WuTongCity
//
//  Created by alan  on 13-8-27.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MsgNoticeViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    DataCenter *dataCenter;
    UITableView *msgNoticeTableView;
    
    NSMutableDictionary *msgNoticeDict;//消息信息字典
    NSArray *msgNoticeSectionArray;
}

@end
