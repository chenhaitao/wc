//
//  CommentHeaderView.h
//  WuTongCity
//
//  Created by alan  on 13-8-21.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "TopicVO.h"
#import "ParamButton.h"
#import "NSString.h"
#import "LocalDirectory.h"

@interface CommentHeaderView : UIView{
    UIImageView *avatarView;//头像
    UILabel *nickNameLabel;//昵称
    
}

@property (strong, nonatomic) TopicVO *tVO;
@property (strong, nonatomic) UILabel *commentsLab;
@property (strong, nonatomic) ParamButton *showMoreBtn;//显示更多按钮

-(id)initWithTopicVO:(TopicVO *)topicVO isShow:(BOOL)_isShow;

-(void) updateComments;

@end
