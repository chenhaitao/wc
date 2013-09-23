//
//  OtherHeaderView.h
//  WuTongCity
//
//  Created by alan  on 13-8-22.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParamButton.h"
#import "UserVO.h"

@interface OtherHeaderView : UIView{
    UIImageView *avatarView;//头像
}

//@property (strong, nonatomic) ParamButton *avatarBtn;

- (id)initWithFrame:(CGRect)_frame userVO:(UserVO *)_userVO;

@end
