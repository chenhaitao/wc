//
//  CommentHeaderView.m
//  WuTongCity
//
//  Created by alan  on 13-8-21.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "CommentHeaderView.h"
#import "DateUtil.h"
#import "FormatUtil.h"
#import "UIImageView+WebCache.h"

@implementation CommentHeaderView
@synthesize tVO;

-(id)initWithTopicVO:(TopicVO *)topicVO isShow:(BOOL)_isShow{
    self = [super init];
    if (self) {
        tVO = topicVO;
       
        tVO.isShow = _isShow;
        
        //用户头像
        avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        NSString *avatarName = tVO.avatar;
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
        [self addSubview:avatarView];
        
        //用户昵称按钮(字数*18+5,保证昵称显示完成)        
        int nickNameLen = [tVO.nickName mixLength];
        if (nickNameLen > 10) {
            nickNameLen = 10;
        }
        nickNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(60,10,nickNameLen*18,20)];
        [nickNameLabel setText:tVO.nickName];
        [nickNameLabel setFont:[UIFont systemFontOfSize:14]];
        [nickNameLabel setTextColor:[UIColor blackColor]];
        nickNameLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:nickNameLabel];

        
        //发布时间
        NSString *pubTime = [NSString stringWithFormat:@"%@前",[DateUtil dateDifference:tVO.createTime]];
        int pubTimeLen = [pubTime mixLength];
        UILabel *pubTimeLab = [[UILabel alloc]initWithFrame:CGRectMake(300-pubTimeLen*15, 10, pubTimeLen*15, 20)];
        [pubTimeLab setText:pubTime];
        [pubTimeLab setFont:[UIFont systemFontOfSize:12]];
        [pubTimeLab setTextColor:[UIColor blackColor]];
        [pubTimeLab setBackgroundColor:[UIColor clearColor]];
        pubTimeLab.textAlignment = NSTextAlignmentRight;
        [self addSubview:pubTimeLab];
        
        //标题
        float imgX = 60, imgY = 35;
        if (![tVO.title isEqualToString:@""]) {
            //标题
            UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(60, 30, 230, 20)];
            [titleLab setText:tVO.title];
            [titleLab setFont:[UIFont systemFontOfSize:16]];
            [titleLab setTextColor:[UIColor blackColor]];
            titleLab.textAlignment = NSTextAlignmentLeft;
            [self addSubview:titleLab];
            imgY = 55;
        }
        
        //图片
        if (tVO.imageArray.count > 0) {
            int imageArrayCount = tVO.imageArray.count;
            UIImageView *imageView , *tempView;
            for (int i=0; i<imageArrayCount; i++) {
                NSString *imgName = [tVO.imageArray objectAtIndex:i];
                NSString *imgString= [[RequestLinkUtil getUrlByKey:DOWNLOAD_FILE] stringByAppendingFormat:@"%@",imgName];
                NSURL *imgUrl=[NSURL URLWithString:imgString];
                imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imgX, imgY, 70, 70)];
                tempView = [[UIImageView alloc] initWithFrame:CGRectMake(imgX, imgY, 70, 70)];
                //            __block UIImageView *tempView = imageView;
                [tempView setImageWithURL:imgUrl
                          placeholderImage:[UIImage imageNamed:@"defAvatar"]
                                   success:^(UIImage *image){
                                       imageView.image = image;
                                   }
                                   failure:^(NSError *error){}];
                
                if (imageArrayCount > 1) {
                    if ((i+1)%3 == 0 && (i+1) < tVO.imageArray.count) {//每行3个，到第三个图片
                        imgX = 60;
                        imgY = imgY+imageView.bounds.size.height + 5;
                    }else{
                        imgX = imgX+imageView.bounds.size.width + 5;
                    }
                }
                [self addSubview:imageView];
                
            }
            imgY = imgY + imageView.bounds.size.height + 5;//准备图片下方的文字信息坐标
        }

        
        
        //内容
        bool isMore = NO;
        if (tVO.content.length > 0) {
            UILabel *contentLab = [[UILabel alloc]init];//详细信息Label
            
            //详细信息的高度
            float contentHeight = [FormatUtil heightForString:tVO.content fontSize:14 andWidth:240];
            if (contentHeight/18 > 3) {
                isMore = YES;
                if (tVO.isShow){
                    contentLab.frame = CGRectMake(60, imgY, 240,contentHeight);
                }else{
                    contentLab.frame = CGRectMake(60, imgY, 240,54);
                }
            }else{
                contentLab.frame = CGRectMake(60, imgY, 240, contentHeight);
            }
            contentLab.text = tVO.content;
            contentLab.font = [UIFont systemFontOfSize:14];
            contentLab.numberOfLines = 0;
            contentLab.lineBreakMode = NSLineBreakByTruncatingTail;
            [contentLab setTextColor:[UIColor blackColor]];
            contentLab.textAlignment = NSTextAlignmentLeft;
            contentLab.tag = 1;
            [self addSubview:contentLab];
            imgY = contentLab.frame.origin.y + contentLab.bounds.size.height + 10;
        }
        
        
        //显示更多按钮
        if (isMore) {
            self.showMoreBtn = [[ParamButton alloc]initWithFrame:CGRectMake(240,imgY,60,20)];
            [self.showMoreBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];//默认黑色字
            [self.showMoreBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];//字体大小
            self.showMoreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;//居左
            [self addSubview:self.showMoreBtn];
        }
        
        
        //评论数
        self.commentsLab = [[UILabel alloc]initWithFrame:CGRectMake(10, imgY, 100, 20)];
        [self.commentsLab setText:[NSString stringWithFormat:@"评论(%d)",tVO.comments]];
        [self.commentsLab setFont:[UIFont systemFontOfSize:12]];
        [self.commentsLab setTextColor:[UIColor blackColor]];
        [self.commentsLab setBackgroundColor:[UIColor clearColor]];
        self.commentsLab.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.commentsLab];
        imgY += self.commentsLab.bounds.size.height +5;
        
        
        self.frame = CGRectMake(0, 0, 320, imgY);
        
        
        
    }
    return self;
}


-(void) updateComments{
//    NSLog(@"%@",)
    [self.commentsLab setText:[NSString stringWithFormat:@"评论(%d)",tVO.comments+1]];
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
