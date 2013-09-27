//
//  NewWeiboCommentViewController.h
//  WuTongCity
//
//  Created by 陈 海涛 on 13-9-27.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicCell.h"
#import "DataCenter.h"
#import "Topic.h"
#import "CreateWeiboViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AdvertisementView.h"
#import "RequestLinkUtil.h"
#import "ConstantValue.h"
#import "CommentViewController.h"
#import "ParamButton.h"
#import "OtherWeiboViewController.h"
#import "TopicVO.h"
#import "PhotoDataSource.h"
#import "DateUtil.h"
#import "FormatUtil.h"
#import "KTPhotoScrollViewController.h"
#import "NSString+URLEncoding.h"
#import "NewWeiboCommentViewController.h"

@interface NewWeiboCommentViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
     NSMutableArray *_dataSource;
      NSString *moreTitle;
}

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@end
