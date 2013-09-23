//
//  ChatViewController.h
//  WuTongCity
//
//  Created by alan  on 13-7-9.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatMessageController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_msgArr;
    UITableView *_messageTable;
}

//	NSMutableArray *_dataSource;
//    NSInteger _totalNumberOfRows;
//    NSInteger _refreshCount;
//    NSInteger _loadMoreCount;
//    
//    NSMutableArray *_msgArr;
//}

@end