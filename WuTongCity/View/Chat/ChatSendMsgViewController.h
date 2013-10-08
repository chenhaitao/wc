//
//  ChatSendMsgViewController.h
//  WuTongCity
//
//  Created by alan  on 13-8-23.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataCenter.h"
#import "FaceToolBar.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "EGORefreshTableView.h"


@interface ChatSendMsgViewController : EGORefreshTableView <FaceToolBarDelegate>
{
    DataCenter *dataCenter;
    //    IBOutlet UITableView *msgRecordTable;
//    UITableView *msgRecordTable;
    NSMutableArray *msgRecords;
    //    IBOutlet UITextField *messageText;
    UITextField *messageText;
    //    IBOutlet UIView *inputBar;
    UIView *inputBar;
    UIImage *_myHeadImage,*_userHeadImage;
}
//- (IBAction)sendIt:(id)sender;
@property (nonatomic,retain) WCUserObject *chatPerson;

@property (nonatomic,assign)BOOL isLoading;
@property (nonatomic,assign) int pageNu;
@end
