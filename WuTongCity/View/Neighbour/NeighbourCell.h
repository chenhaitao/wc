//
//  NeighbourCell.h
//  WuTongCity
//
//  Created by alan  on 13-8-14.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserVO.h"

@interface NeighbourCell : UITableViewCell{
    UIImageView *avatarView;//头像
    UILabel *nickNameLab;//昵称
}

@property (strong, nonatomic) UserVO *userVO;
//@property (strong, nonatomic)UILabel *nickNameLab;//昵称

- (id)initWithUserVO:(UserVO *) _userVO;

@end
