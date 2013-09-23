//
//  WeiBoCell.m
//  WuTongCity
//
//  Created by alan  on 13-7-11.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "TopicCell.h"
#import "NSString.h"
#import "User.h"
#import "DateUtil.h"
#import "FormatUtil.h"



@interface TopicCell ()

@end

@implementation TopicCell

@synthesize avatarBtn,nickNameBtn,maskUserBtn,showMoreBtn,commentsBtn,tVO;

- (id)initWithTopicVO:(TopicVO *)_topicVO{
    
    if (self = [super init]) {
//        tVO = [[TopicVO alloc] init];
//        tVO = _topicVO;
//       
//        dataCenter = [DataCenter sharedInstance];
//        
//        //为查看其他用户邻居说页面的用户信息做准备
//        UserVO *u = [[UserVO alloc] init];
//        u.userId = tVO.userId;
//        u.avatar = tVO.avatar;
//        u.nickName = tVO.nickName;
//        u.signature = tVO.signature;
//        
//        
//        //用户头像
//        self.avatarBtn = [[ParamButton alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
//        NSString *avatarName = tVO.avatar;
//        if (![avatarName isEqualToString:@""]) {
//            NSString *avatarString= [[RequestLinkUtil getUrlByKey:DOWNLOAD_FILE] stringByAppendingFormat:@"%@",avatarName];
//            NSURL *avatarUrl=[NSURL URLWithString:avatarString];
//            [self.avatarBtn setBackgroundImageWithURL:avatarUrl
//                  placeholderImage:[UIImage imageNamed:@"defAvatar"]
//                           success:^(UIImage *image){
//                               [self.avatarBtn setBackgroundImage:image forState:UIControlStateNormal];
//                               [self.avatarBtn setBackgroundImage:image forState:UIControlStateHighlighted];
//                           }
//                           failure:^(NSError *error){}];
//        }else{
//            [self.avatarBtn setBackgroundImage:[UIImage imageNamed:@"defAvatar.png"] forState:UIControlStateNormal];
//            [self.avatarBtn setBackgroundImage:[UIImage imageNamed:@"defAvatar.png"] forState:UIControlStateHighlighted];
//        }
//        [self.avatarBtn.layer setMasksToBounds:YES];
//        [self.avatarBtn.layer setBorderWidth:2.0]; //边框宽度
//        [self.avatarBtn.layer setBorderColor:[[UIColor whiteColor] CGColor]];
//        [self.avatarBtn.param setValue:u forKey:@"userVO"];
//        [self.contentView addSubview:self.avatarBtn];
//        
//        
//        //用户昵称按钮(字数*18+5,保证昵称显示完成)
//        int nickNameLen = [tVO.nickName mixLength];//昵称字符长度
//        self.nickNameBtn = [[ParamButton alloc]initWithFrame:CGRectMake(60,10,nickNameLen*18,20)];
//        [self.nickNameBtn setTitle:tVO.nickName forState:UIControlStateNormal];
//        [self.nickNameBtn setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];//默认蓝色字
//        [self.nickNameBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];//字体大小
//        self.nickNameBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//居左
//        [self.nickNameBtn.param setValue:u forKey:@"userVO"];
//        [self.contentView addSubview:self.nickNameBtn];
//        
//        //屏蔽此人按钮
//        self.maskUserBtn = [[ParamButton alloc]initWithFrame:CGRectMake(self.nickNameBtn.bounds.size.width+60,10,60,20)];
//        [self.maskUserBtn setTitle:@"屏蔽此人" forState:UIControlStateNormal];
//        [self.maskUserBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];//默认黑色字
//        [self.maskUserBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];//字体大小
//        self.maskUserBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//居左
//        [self.maskUserBtn.param setValue:tVO.userId forKey:@"uuid"];
//        [self.contentView addSubview:self.maskUserBtn];
//        
//        //发布时间
//        NSString *pubTime = [NSString stringWithFormat:@"%@前",[DateUtil dateDifference:tVO.createTime]];
//        int pubTimeLen = [pubTime mixLength];
//        UILabel *pubTimeLab = [[UILabel alloc]initWithFrame:CGRectMake(300-pubTimeLen*15, 10, pubTimeLen*15, 20)];
//        [pubTimeLab setText:pubTime];
//        [pubTimeLab setFont:[UIFont systemFontOfSize:12]];
//        [pubTimeLab setTextColor:[UIColor blackColor]];
//        pubTimeLab.textAlignment = NSTextAlignmentRight;
//        [self.contentView addSubview:pubTimeLab];
//        
//        float imgX = 60, imgY = 35;
//        if (![tVO.title isEqualToString:@""]) {
//            //标题
//            UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(60, 30, 230, 20)];
//            [titleLab setText:tVO.title];
//            [titleLab setFont:[UIFont systemFontOfSize:16]];
//            [titleLab setTextColor:[UIColor blackColor]];
//            titleLab.textAlignment = NSTextAlignmentLeft;
//            [self.contentView addSubview:titleLab];
//            imgY = 55;
//        }
//        
//        if (tVO.imageArray.count > 0) {
//            int imageArrayCount = tVO.imageArray.count;
//            ParamButton *imageBtn;
//            
////            UIImageView *imageView;
//            for (int i=0; i<imageArrayCount; i++) {
//                NSString *imgName = [tVO.imageArray objectAtIndex:i];
//                NSString *imgString= [[RequestLinkUtil getUrlByKey:DOWNLOAD_FILE] stringByAppendingFormat:@"%@",imgName];
//                NSURL *imgUrl=[NSURL URLWithString:imgString];
////                imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imgX, imgY, 70, 70)];
//                imageBtn = [[ParamButton alloc]initWithFrame:CGRectMake(imgX, imgY, 70, 70)];
//                ParamButton *tempBtn = imageBtn;
//                [tempBtn setBackgroundImageWithURL:imgUrl
//                          placeholderImage:[UIImage imageNamed:@"defAvatar"]
//                                   success:^(UIImage *image){
//                                       [imageBtn setBackgroundImage:image forState:UIControlStateNormal];
////                                       [imageBtn setBackgroundImage:image forState:UIControlStateHighlighted];
//                                       [imageBtn.param setValue:tVO.imageArray forKey:@"imageArray"];
//                                   }
//                                   failure:^(NSError *error){}];
//                
//                if (imageArrayCount > 1) {
//                    if ((i+1)%3 == 0 && (i+1) < tVO.imageArray.count) {//每行3个，到第三个图片
//                        imgX = 60;
//                        imgY = imgY+imageBtn.bounds.size.height + 5;
//                    }else{
//                        imgX = imgX+imageBtn.bounds.size.width + 5;
//                    }
//                }
//                [self.contentView addSubview:imageBtn];
//                
//            }
//            imgY = imgY + imageBtn.bounds.size.height + 5;//准备图片下方的文字信息坐标
//        }
//        
//                      
//        //内容
//        bool isMore = NO;
//        if (tVO.content.length > 0) {
//            UILabel *contentLab = [[UILabel alloc]init];//详细信息Label
//            
//            //详细信息的高度
//            float contentHeight = [FormatUtil heightForString:tVO.content fontSize:14 andWidth:240];
//            if (contentHeight/18 > 3) {
//                isMore = YES;
//                if (tVO.isShow){
//                    contentLab.frame = CGRectMake(60, imgY, 240,contentHeight);
//                }else{
//                    contentLab.frame = CGRectMake(60, imgY, 240,54);
//                }
//            }else{
//                contentLab.frame = CGRectMake(60, imgY, 240, contentHeight);
//            }
//            contentLab.text = tVO.content;
//            contentLab.font = [UIFont systemFontOfSize:14];
//            contentLab.numberOfLines = 0;
//            contentLab.lineBreakMode = NSLineBreakByTruncatingTail;
//            [contentLab setTextColor:[UIColor blackColor]];
//            contentLab.textAlignment = NSTextAlignmentLeft;
//            contentLab.tag = 1;
//            [self.contentView addSubview:contentLab];
//            imgY = contentLab.frame.origin.y + contentLab.bounds.size.height + 5;
//        }
//                
//        
//        //显示更多按钮
//        if (isMore) {
//            self.showMoreBtn = [[ParamButton alloc]initWithFrame:CGRectMake(60,imgY,60,20)];
//            [self.showMoreBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];//默认黑色字
//            [self.showMoreBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];//字体大小
//            self.showMoreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//居左
//            [self.contentView addSubview:self.showMoreBtn];
//        }
//        
//        //赞数量按钮
//        self.praisesBtn = [[ParamButton alloc]initWithFrame:CGRectMake(165, imgY, 60, 29)];
//        [self.praisesBtn setBackgroundImage:[UIImage imageNamed:@"comment_ praise_bg"] forState:UIControlStateNormal];
//        [self.praisesBtn setTitle:[NSString stringWithFormat:@"赞(%d) ",tVO.praies] forState:UIControlStateNormal];
//        [self.praisesBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];//默认黑色字
//        [self.praisesBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];//字体大小
//        self.praisesBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;//居左
//        [self.praisesBtn.param setValue:tVO.topicId forKey:@"topicId"];
//        //赞图标
//        UIImage *praiseImage = [UIImage imageNamed:@"praise_mark"];
//        UIImageView *praiseImageView = [[UIImageView alloc] initWithImage:praiseImage];
//        praiseImageView.frame = CGRectMake(4, 4, praiseImage.size.width, praiseImage.size.height);
//        [self.praisesBtn addSubview:praiseImageView];
//        [self.contentView addSubview:self.praisesBtn];
//        
//        
//        //评论数按钮
//        self.commentsBtn = [[ParamButton alloc]initWithFrame:CGRectMake(235, imgY, 75, 29)];
//        [self.commentsBtn setBackgroundImage:[UIImage imageNamed:@"comment_ praise_bg"] forState:UIControlStateNormal];
//        [self.commentsBtn setTitle:[NSString stringWithFormat:@"评论(%d) ",tVO.comments] forState:UIControlStateNormal];
//        [self.commentsBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];//默认黑色字
//        [self.commentsBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];//字体大小
//        self.commentsBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;//居左//居左
//        [self.commentsBtn.param setValue:tVO forKey:@"topicVO"];
//        //评论图标
//        UIImage *commentImage = [UIImage imageNamed:@"comment_mark"];
//        UIImageView *commentImageView = [[UIImageView alloc] initWithImage:commentImage];
//        commentImageView.frame = CGRectMake(4, 4, commentImage.size.width, commentImage.size.height);
//        [self.commentsBtn addSubview:commentImageView];
//        [self.contentView addSubview:self.commentsBtn];
//
//        
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        
//        self.frame = CGRectMake(0, 0, 320, imgY + 34);
    }
    return self;
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
