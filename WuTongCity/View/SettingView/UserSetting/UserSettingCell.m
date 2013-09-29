//
//  UserSettingCell.m
//  WuTongCity
//
//  Created by alan  on 13-8-11.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "UserSettingCell.h"
#import "NSString.h"
#import "UIImageView+WebCache.h"
#import "DateUtil.h"

@implementation UserSettingCell
@synthesize titleLab, avatarImageView, valueLab, mark;

- (id)initWithTitle:(NSString *) _title content:(NSString *)_content mark:(NSString *)_mark{
    self = [super init];
    if (self) {
        self.mark = _mark;
        //标题
        self.titleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 80, 30)];
        [self.titleLab setText:_title];
        [self.titleLab setFont:[UIFont systemFontOfSize:14]];
        [self.titleLab setTextColor:[UIColor blackColor]];
        [self.titleLab setBackgroundColor:[UIColor clearColor]];
        self.titleLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.titleLab];
        
        if ([self.mark isEqualToString:AVATAR_MARK]) {
            //用户头像
            self.avatarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(230, 5, 40, 40)];
            if (_content.length > 0) {
                
                NSString *avatarString= [[RequestLinkUtil getUrlByKey:DOWNLOAD_FILE] stringByAppendingFormat:@"%@",_content];
                NSURL *avatarUrl=[NSURL URLWithString:avatarString];
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(230, 5, 40, 40)];
                [imageView setImageWithURL:avatarUrl
                          placeholderImage:[UIImage imageNamed:@"defAvatar.png"]
                                   success:^(UIImage *image){
                                       self.avatarImageView.image = image;
                                   }
                                   failure:^(NSError *error){}];
            }else{
                self.avatarImageView.image = [UIImage imageNamed:@"defAvatar.png"];
            }
           
            [self.contentView addSubview:self.avatarImageView];
        }
        else{
            if([self.mark isEqualToString:SEX_MARK]){
                if ([_content intValue] == [MALE_VALUE intValue]) {
                    _content = MALE;
                }else{
                    _content = FEMALE;
                }
            }
            
//            if ([self.mark isEqualToString:BIRTHDAY_MARK]) {
//                NSDate *date = [DateUtil dateFromString:_content format:@"yyyy-MM-dd HH:mm:ss"];
//                _content = [DateUtil stringFromDate:date format:@"YYYY年MM月d日"];
//            }
        
            self.valueLab = [[UILabel alloc]initWithFrame:CGRectMake(90, 10, 180, 30)];
            [self.valueLab setText:_content];
            [self.valueLab setFont:[UIFont systemFontOfSize:14]];
            [self.valueLab setTextColor:[UIColor blackColor]];
            [self.valueLab setBackgroundColor:[UIColor clearColor]];
            self.valueLab.textAlignment = NSTextAlignmentRight;
            [self.contentView addSubview:self.valueLab];
        }

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
