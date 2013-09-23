//
//  LimitCell.m
//  WuTongCity
//
//  Created by alan  on 13-8-27.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "LimitCell.h"
#import "UIImageView+WebCache.h"

@implementation LimitCell
@synthesize limitBtn;

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
        
        
        NSString *title = @"限制用户";
        if (userVO.isRestrict > 0) {
            title = @"取消限制";
        }
        self.limitBtn = [[ParamButton alloc]initWithFrame:CGRectMake(240, 10, 70, 30)];
        [self.limitBtn setBackgroundImage:[UIImage imageNamed:@"backgroud_btn.png"] forState:UIControlStateNormal];
        [self.limitBtn setTitle:title forState:UIControlStateNormal];
        [self.limitBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self.limitBtn.param setValue:userVO forKey:@"userVO"];
        [self.contentView addSubview:self.limitBtn];
    }
    return self;
}

@end
