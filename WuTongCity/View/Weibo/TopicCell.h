//
//  WeiBoCell.h
//  WuTongCity
//
//  Created by alan  on 13-7-11.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicVO.h"
#import "DataCenter.h"
#import "ParamButton.h"


@interface TopicCell :  UITableViewCell{
    DataCenter *dataCenter;
    
    float imageWidth, imageHeight;
}

@property (strong, nonatomic) TopicVO *tVO;
@property (strong, nonatomic) ParamButton *avatarBtn;//头像按钮
@property (strong, nonatomic) ParamButton *nickNameBtn;//昵称按钮
@property (strong, nonatomic) ParamButton *maskUserBtn;//屏蔽此人按钮
@property (strong, nonatomic) ParamButton *praisesBtn;//赞数量按钮
@property (strong, nonatomic) ParamButton *commentsBtn;//评论数按钮
@property (strong, nonatomic) ParamButton *showMoreBtn;//显示更多按钮

- (id)initWithTopicVO:(TopicVO *)_topicVO;



@end
