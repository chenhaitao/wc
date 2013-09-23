//
//  OtherTopicCell.m
//  WuTongCity
//
//  Created by alan  on 13-8-22.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "OtherTopicCell.h"
#import "UIImageView+WebCache.h"
#import "NSString.h"
#import "DateUtil.h"
#import "FormatUtil.h"

@implementation OtherTopicCell
@synthesize isShow;

-(id)initWithTopicVO:(TopicVO *)_topicVO isShow:(BOOL)_isShow{
    if (self = [super init]) {
        
        self.isShow = _isShow;
        
        int coordX = 20, coordY = 10;        
        
        //发布时间
        NSDate *date = [DateUtil dateFromString:_topicVO.createTime format:@"yyyy-MM-dd HH:mm:ss"];
        NSString *pubTime = [DateUtil stringFromDate:date format:@"YYYY年MM月d日"];
        int pubTimeLen = [pubTime mixLength];
        UILabel *pubTimeLab = [[UILabel alloc]initWithFrame:CGRectMake(coordX, 10, pubTimeLen*18, 20)];
        [pubTimeLab setText:pubTime];
        [pubTimeLab setFont:[UIFont systemFontOfSize:14]];
        [pubTimeLab setTextColor:[UIColor blackColor]];
        pubTimeLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:pubTimeLab];
        coordY += pubTimeLab.bounds.size.height +5;
       
        if (![_topicVO.title isEqualToString:@""]) {
            //标题
            UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(coordX, coordY, 230, 20)];
            [titleLab setText:_topicVO.title];
            [titleLab setFont:[UIFont systemFontOfSize:16]];
            [titleLab setTextColor:[UIColor blackColor]];
            titleLab.textAlignment = NSTextAlignmentLeft;
            [self.contentView addSubview:titleLab];
            coordY += titleLab.frame.origin.y + titleLab.bounds.size.height + 5;
        }

        
        
        if (_topicVO.imageArray.count > 0) {
            int imageArrayCount = _topicVO.imageArray.count;
            UIImageView *imageView;
            for (int i=0; i<imageArrayCount; i++) {
                NSString *imgName = [_topicVO.imageArray objectAtIndex:i];
                NSString *imgString= [[RequestLinkUtil getUrlByKey:DOWNLOAD_FILE] stringByAppendingFormat:@"%@",imgName];
                NSURL *imgUrl=[NSURL URLWithString:imgString];
                imageView = [[UIImageView alloc] initWithFrame:CGRectMake(coordX, coordY, 70, 70)];
                //            __block UIImageView *tempView = imageView;
                [imageView setImageWithURL:imgUrl
                          placeholderImage:[UIImage imageNamed:@"defAvatar"]
                                   success:^(UIImage *image){
                                       imageView.image = image;
                                   }
                                   failure:^(NSError *error){}];
                
                if (imageArrayCount > 1) {
                    if ((i+1)%3 == 0 && (i+1) < _topicVO.imageArray.count) {//每行3个，到第三个图片
                        coordX = 20;
                        coordY += imageView.bounds.size.height + 5;
                    }else{
                        coordX += imageView.bounds.size.width + 5;
                    }
                }
                [self.contentView addSubview:imageView];
                
            }
            coordY += imageView.bounds.size.height + 5;//准备图片下方的文字信息坐标
        }

        
        //内容
        bool isMore = NO;
        if (_topicVO.content.length > 0) {
            UILabel *contentLab = [[UILabel alloc]init];//详细信息Label
            
            //详细信息的高度
            float contentHeight = [FormatUtil heightForString:_topicVO.content fontSize:14 andWidth:280];
            if (contentHeight/18 > 3) {
                isMore = YES;
                if (self.isShow){
                    contentLab.frame = CGRectMake(20, coordY, 280,contentHeight);
                }else{
                    contentLab.frame = CGRectMake(20, coordY, 280,54);
                }
            }else{
                contentLab.frame = CGRectMake(20, coordY, 280, contentHeight);
            }
            contentLab.text = _topicVO.content;
            contentLab.font = [UIFont systemFontOfSize:14];
            contentLab.numberOfLines = 0;
            contentLab.lineBreakMode = NSLineBreakByTruncatingTail;
            [contentLab setTextColor:[UIColor blackColor]];
            contentLab.textAlignment = NSTextAlignmentLeft;
            contentLab.tag = 1;
            [self.contentView addSubview:contentLab];
            coordY = contentLab.frame.origin.y + contentLab.bounds.size.height + 5;
        }
        
        
        //显示更多按钮
        if (isMore) {
            self.showMoreBtn = [[ParamButton alloc]initWithFrame:CGRectMake(20,coordY,60,20)];
            [self.showMoreBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];//默认黑色字
            [self.showMoreBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];//字体大小
            self.showMoreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//居左
            [self.contentView addSubview:self.showMoreBtn];
            coordY += self.showMoreBtn.bounds.size.height + 5;
        }
        
    
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.frame = CGRectMake(0, 0, 320, coordY);
        
        
        
        NSLog(@"%f, %f",self.bounds.size.width,self.bounds.size.height);
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
