//
//  AccountMgrCell.m
//  WuTongCity
//
//  Created by alan  on 13-9-18.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "AccountMgrCell.h"
#import "WZUser.h"

@implementation AccountMgrCell

-(id) initWithUser:(WZUser *)user{
    self = [super init];
    if (self) {

        //昵称
        UILabel *nickNameLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 170, 40)];
      //  [nickNameLab setText:[_dict objectForKey:@"nickName"]];
        nickNameLab.text =  user.nickName;
        [nickNameLab setFont:[UIFont systemFontOfSize:18]];
        [nickNameLab setTextColor:[UIColor blackColor]];
        [nickNameLab setBackgroundColor:[UIColor clearColor]];
        nickNameLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:nickNameLab];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
