//
//  OtherHeaderView.m
//  WuTongCity
//
//  Created by alan  on 13-8-22.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "OtherHeaderView.h"
//#import "DataCenter.h"
//#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"


@implementation OtherHeaderView

- (id)initWithFrame:(CGRect)_frame userVO:(UserVO *)_userVO {
    self = [super initWithFrame:_frame];
    if (self) {
        // Initialization code
        
        //相册
        UIButton *albumBtn = [[ParamButton alloc]initWithFrame:CGRectMake(0, 0, 320, 220)];
        [albumBtn setBackgroundImage:[UIImage imageNamed:@"defablum.png"] forState:UIControlStateNormal];
        [albumBtn setBackgroundImage:[UIImage imageNamed:@"defablum.png"] forState:UIControlStateHighlighted];
        [self addSubview:albumBtn];
        
        
        //昵称
        UILabel *nickNameLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 190, 190, 30)];
        [nickNameLab setText:_userVO.nickName];
        [nickNameLab setFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:18]];
        [nickNameLab setTextColor:[UIColor whiteColor]];
        [nickNameLab setBackgroundColor:[UIColor clearColor]];
        nickNameLab.textAlignment = NSTextAlignmentRight;
        [self addSubview:nickNameLab];
        
        
        //签名
        UILabel *signatureLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 220, 190, 30)];
        [signatureLab setText:_userVO.signature];
        [signatureLab setFont:[UIFont fontWithName:@"TrebuchetMS" size:14]];
        [signatureLab setTextColor:[UIColor blackColor]];
        [signatureLab setBackgroundColor:[UIColor clearColor]];
        signatureLab.textAlignment = NSTextAlignmentRight;
        [self addSubview:signatureLab];
        
        
        

        
        //用户头像
        avatarView = [[UIImageView alloc]initWithFrame:CGRectMake(220, 170, 80, 80)];
        NSString *avatarName = _userVO.avatar;
        if (avatarName.length > 0) {
        NSString *avatarString= [[RequestLinkUtil getUrlByKey:DOWNLOAD_FILE] stringByAppendingFormat:@"%@",avatarName];
        NSURL *avatarUrl=[NSURL URLWithString:avatarString];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(220, 170, 80, 80)];
        [imageView setImageWithURL:avatarUrl
                  placeholderImage:[UIImage imageNamed:@"defAvatar.png"]
                           success:^(UIImage *image){
                               avatarView.image = image;
                           }
                           failure:^(NSError *error){}];
        }else{
            avatarView.image = [UIImage imageNamed:@"defAvatar.png"];
        }
        [avatarView.layer setMasksToBounds:YES];
        [avatarView.layer setBorderWidth:2.0]; //边框宽度
        [avatarView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
//        [self.avatarBtn.param setValue:_user.uuid forKey:@"uuid"];
        [self addSubview:avatarView];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
