//
//  OtherTopicCell.h
//  WuTongCity
//
//  Created by alan  on 13-8-22.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataCenter.h"
#import "ParamButton.h"
#import "TopicVO.h"

@interface OtherTopicCell : UITableViewCell{
    //    UIImageView *operView;
    DataCenter *dataCenter;
}

@property (assign, nonatomic) BOOL isShow;
@property (strong, nonatomic) ParamButton *praisesBtn;//赞数量按钮
@property (strong, nonatomic) ParamButton *commentsBtn;//评论数按钮
@property (strong, nonatomic) ParamButton *showMoreBtn;//显示更多按钮



-(id)initWithTopicVO:(TopicVO *)_topicVO isShow:(BOOL)_isShow;
@end
