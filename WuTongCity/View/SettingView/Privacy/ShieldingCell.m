//
//  ShieldingCell.m
//  WuTongCity
//
//  Created by alan  on 13-9-13.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "ShieldingCell.h"
#import "UIImageView+WebCache.h"

@implementation ShieldingCell
@synthesize shieldingBtn;

- (id)initWithUserVO:(UserVO *)userVO{
    self = [super init];
    if (self) {
        
        //用户头像
        UIImageView *userImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 40, 40)];
        NSString *avatarName = userVO.avatar;
        if (avatarName.length > 0) {
            NSString *avatarString= [[RequestLinkUtil getUrlByKey:DOWNLOAD_FILE] stringByAppendingFormat:@"%@",avatarName];
            NSURL *avatarUrl=[NSURL URLWithString:avatarString];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 40, 40)];
            [imageView setImageWithURL:avatarUrl
                      placeholderImage:[UIImage imageNamed:@"defAvatar.png"]
                               success:^(UIImage *image){
                                   userImgView.image = image;
                               }
                               failure:^(NSError *error){}];
        }else{
            userImgView.image = [UIImage imageNamed:@"defAvatar.png"];
        }
        [self.contentView addSubview:userImgView];
        
        //昵称
        UILabel *nickNameLab = [[UILabel alloc]initWithFrame:CGRectMake(60, 10, 170, 40)];
        [nickNameLab setText:userVO.nickName];
        [nickNameLab setFont:[UIFont systemFontOfSize:14]];
        [nickNameLab setTextColor:[UIColor blackColor]];
        [nickNameLab setBackgroundColor:[UIColor clearColor]];
        nickNameLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:nickNameLab];
        
        
        NSString *title = @"屏蔽用户";
        NSLog(@"userVO.isShield====%d",userVO.isShield);
        if (userVO.isShield > 0) {
            title = @"取消屏蔽";
        }
        self.shieldingBtn = [[ParamButton alloc]initWithFrame:CGRectMake(240, 10, 70, 30)];
        [self.shieldingBtn setBackgroundImage:[UIImage imageNamed:@"backgroud_btn.png"] forState:UIControlStateNormal];
        [self.shieldingBtn setTitle:title forState:UIControlStateNormal];
        [self.shieldingBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self.shieldingBtn.param setValue:userVO forKey:@"userVO"];
        [self.contentView addSubview:self.shieldingBtn];
    }
    return self;
}

@end
