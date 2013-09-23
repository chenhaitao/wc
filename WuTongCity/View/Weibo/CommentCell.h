//
//  CommentCell.h
//  WuTongCity
//
//  Created by alan  on 13-8-22.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataCenter.h"
#import "ParamButton.h"
#import "CommentVO.h"

@interface CommentCell : UITableViewCell{
    DataCenter *dataCenter;
    UIImageView *avatarView;//头像
    ParamButton *nickNameBtn;//昵称按钮
    
}

@property (assign, nonatomic) BOOL isShow;
@property (strong, nonatomic) ParamButton *showMoreBtn;//显示更多按钮
//@property (strong, nonatomic) NSString *content;
//@property (strong, nonatomic) NSString *time;


-(id)initWithCommentVO:(CommentVO *)_commentVO isShow:(BOOL)_isShow;

@end
