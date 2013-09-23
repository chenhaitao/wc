//
//  NeighbourCell.m
//  WuTongCity
//
//  Created by alan  on 13-8-14.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "NeighbourCell.h"
#import "UIImageView+WebCache.h"

@implementation NeighbourCell
@synthesize userVO;

- (id)initWithUserVO:(UserVO *) _userVO{
    self = [super init];
    if (self) {
        userVO = _userVO;
        
        //用户头像
        avatarView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 40, 40)];
        NSString *avatarName = _userVO.avatar;
        if (![avatarName isEqualToString:@""]) {
            NSLog(@"%@",avatarName);
            NSString *avatarString= [[RequestLinkUtil getUrlByKey:DOWNLOAD_FILE] stringByAppendingFormat:@"%@",avatarName];
            NSURL *avatarUrl=[NSURL URLWithString:avatarString];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 40, 40)];
            [imageView setImageWithURL:avatarUrl
                      placeholderImage:[UIImage imageNamed:@"defAvatar.png"]
                               success:^(UIImage *image){
                                    avatarView.image = image;
                               }
                               failure:^(NSError *error){}];
        }else{
            avatarView.image = [UIImage imageNamed:@"defAvatar.png"];
        }
        
        [self.contentView addSubview:avatarView];

        
        

        //昵称
        nickNameLab = [[UILabel alloc]initWithFrame:CGRectMake(60, 10, 200, 40)];
        [nickNameLab setText:_userVO.nickName];
        [nickNameLab setFont:[UIFont systemFontOfSize:16]];
        [nickNameLab setTextColor:[UIColor blackColor]];
        [nickNameLab setBackgroundColor:[UIColor clearColor]];
        nickNameLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:nickNameLab];
        
         self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
