//
//  UserSettingCell.h
//  WuTongCity
//
//  Created by alan  on 13-8-11.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface UserSettingCell : UITableViewCell{
    
//    UIImage *userImg;//头像图片
    
    

}

@property (strong, nonatomic)UILabel *titleLab;//标题
@property (strong, nonatomic)UIImageView *avatarImageView;//头像按钮
@property (strong, nonatomic)UILabel *valueLab;//内容
@property (strong, nonatomic)NSString *mark;//标记(标记是哪一个属性)

- (id)initWithTitle:(NSString *) _title content:(NSString *)_content mark:(NSString *)_mark;

@end
