//
//  CommentCell.m
//  WuTongCity
//
//  Created by alan  on 13-8-22.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "CommentCell.h"
#import "NSString.h"
#import "DateUtil.h"
#import "FormatUtil.h"
#import "UIImageView+WebCache.h"


@implementation CommentCell
@synthesize isShow;
@synthesize showMoreBtn;

-(id)initWithCommentVO:(CommentVO *)_commentVO isShow:(BOOL)_isShow{
    if (self = [super init]) {

        self.isShow = _isShow;
        
        avatarView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
        NSString *avatarName = _commentVO.avatar;
        if (avatarName.length > 0) {
            NSString *avatarString= [[RequestLinkUtil getUrlByKey:DOWNLOAD_FILE] stringByAppendingFormat:@"%@",avatarName];
            NSURL *avatarUrl=[NSURL URLWithString:avatarString];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
            [imageView setImageWithURL:avatarUrl
                      placeholderImage:[UIImage imageNamed:@"defAvatar"]
                               success:^(UIImage *image){
                                   avatarView.image = image;
                               }
                               failure:^(NSError *error){}];
        }else{
            avatarView.image = [UIImage imageNamed:@"defAvatar"];
        }
        [self.contentView addSubview:avatarView];


        //用户昵称按钮(字数*12+5,保证昵称显示完成)
        int nickNameLen = [_commentVO.nickName mixLength];//昵称字符长度
        if (nickNameLen > 8) {
            nickNameLen = 8;
        }
        nickNameBtn = [[ParamButton alloc]initWithFrame:CGRectMake(60,10,nickNameLen*20,20)];
        [nickNameBtn setTitle:_commentVO.nickName forState:UIControlStateNormal];
        [nickNameBtn setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];//默认蓝色字
        [nickNameBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];//字体大小
        nickNameBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//居左
        [nickNameBtn.param setValue:_commentVO.userId forKey:@"uuid"];
        [self.contentView addSubview:nickNameBtn];
        
        //发布时间
        NSString *pubTime = [NSString stringWithFormat:@"%@前",[DateUtil dateDifference:_commentVO.createTime]];
        int pubTimeLen = [pubTime mixLength];
        UILabel *pubTimeLab = [[UILabel alloc]initWithFrame:CGRectMake(300-pubTimeLen*15, 10, pubTimeLen*15, 20)];
        [pubTimeLab setText:pubTime];
        [pubTimeLab setFont:[UIFont systemFontOfSize:12]];
        [pubTimeLab setTextColor:[UIColor blackColor]];
        [pubTimeLab setBackgroundColor:[UIColor clearColor]];
        pubTimeLab.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:pubTimeLab];

        
        //内容
        int height = 25;
        bool isMore = NO;
        if (_commentVO.content.length > 0) {
            UILabel *_commentLab = [[UILabel alloc]init];//详细信息Label
            
            //详细信息的高度
            float contentHeight = [FormatUtil heightForString:_commentVO.content fontSize:14 andWidth:240];
            if (contentHeight/18 > 2) {
                isMore = YES;
                if (self.isShow){
                    _commentLab.frame = CGRectMake(60, 30, 240,contentHeight);
                }else{
                    _commentLab.frame = CGRectMake(60, 30, 240,36);
                }
            }else{
                _commentLab.frame = CGRectMake(60, 30, 240, contentHeight);
            }
            _commentLab.text = _commentVO.content;
            _commentLab.font = [UIFont systemFontOfSize:14];
            _commentLab.numberOfLines = 0;
            _commentLab.lineBreakMode = NSLineBreakByTruncatingTail;
            [_commentLab setTextColor:[UIColor blackColor]];
            _commentLab.textAlignment = NSTextAlignmentLeft;
            _commentLab.tag = 1;
            [self.contentView addSubview:_commentLab];
            height = _commentLab.frame.origin.y + _commentLab.bounds.size.height + 5;
        }
        
        //显示更多按钮
        if (isMore) {
            self.showMoreBtn = [[ParamButton alloc]initWithFrame:CGRectMake(60,height,60,20)];
            [self.showMoreBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];//默认黑色字
            [self.showMoreBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];//字体大小
            self.showMoreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//居左
            [self.contentView addSubview:self.showMoreBtn];
            height = self.showMoreBtn.frame.origin.y + self.showMoreBtn.bounds.size.height + 5;
        }


        
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.frame = CGRectMake(0, 0, 320, height);
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
