//
//  ChatCellViewController.m
//  WuTongCity
//
//  Created by alan  on 13-7-9.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "ChatMessageCell.h"
#import "UIImageView+WebCache.h"
//头像大小
#define HEAD_SIZE 50.0f
//间距
#define INSETS 8.0f

#define CELL_HEIGHT self.contentView.frame.size.height
#define CELL_WIDTH self.contentView.frame.size.width

@interface ChatMessageCell ()

@end

@implementation ChatMessageCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _userHead =[[UIImageView alloc]initWithFrame:CGRectZero];
        _userNickname=[[UILabel alloc]initWithFrame:CGRectZero];
        _messageConent=[[UILabel alloc]initWithFrame:CGRectZero];
        _timeLable=[[UILabel alloc]initWithFrame:CGRectZero];
        _cellBkg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MessageListCellBkg"]];
        
        [_userHead.layer setCornerRadius:8.0f];
        [_userHead.layer setMasksToBounds:YES];
        
        [_userNickname setFont:[UIFont boldSystemFontOfSize:15]];
        [_userNickname setBackgroundColor:[UIColor clearColor]];
        [_messageConent setFont:[UIFont systemFontOfSize:15]];
        [_messageConent setTextColor:[UIColor lightGrayColor]];
        [_messageConent setBackgroundColor:[UIColor clearColor]];
        
        [_timeLable setTextColor:[UIColor lightGrayColor]];
        [_timeLable setFont:[UIFont systemFontOfSize:15]];
        [_timeLable setBackgroundColor:[UIColor clearColor]];
        
        // [self.contentView addSubview:_cellBkg];
        [self setBackgroundView:_cellBkg];
        [self.contentView addSubview:_userHead];
        [self.contentView addSubview:_userNickname];
        [self.contentView addSubview:_messageConent];
        [self.contentView addSubview:_timeLable];
        
        //[self setAccessoryView:_timeLable];
        
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
    }
    return self;
}

-(void)layoutSubviews
{
    
    [super layoutSubviews];
    
    
    [_userHead setFrame:CGRectMake(INSETS, (CELL_HEIGHT-HEAD_SIZE)/2,HEAD_SIZE , HEAD_SIZE)];
    [_userNickname setFrame:CGRectMake(2*INSETS+HEAD_SIZE, (CELL_HEIGHT-HEAD_SIZE)/2, (CELL_WIDTH-HEAD_SIZE-INSETS*3), (CELL_HEIGHT-3*INSETS)/2)];
    [_messageConent setFrame:CGRectMake(2*INSETS+HEAD_SIZE, (CELL_HEIGHT-HEAD_SIZE)/2+_userNickname.frame.size.height+INSETS, (CELL_WIDTH-HEAD_SIZE-INSETS*3), (CELL_HEIGHT-3*INSETS)/2)];
    [_timeLable setFrame:CGRectMake(CELL_WIDTH-80, (CELL_HEIGHT-HEAD_SIZE)/2, 80, (CELL_HEIGHT-3*INSETS)/2)];
    _cellBkg.frame=self.contentView.frame;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setUnionObject:(WCMessageUserUnionObject*)aUnionObj
{
    [_userNickname setText:aUnionObj.user.userNickname];
    [_messageConent setText:aUnionObj.message.messageContent];
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setAMSymbol:@"上午"];
    [formatter setPMSymbol:@"下午"];
    [formatter setDateFormat:@"a HH:mm"];
    
    [_timeLable setText:[formatter stringFromDate:aUnionObj.message.messageDate]];
    [self setHeadImage:aUnionObj.user.userHead];
}
-(void)setHeadImage:(NSString*)imageName{
    //用户头像
    if (imageName.length > 0) {
        NSString *avatarString= [[RequestLinkUtil getUrlByKey:DOWNLOAD_FILE] stringByAppendingFormat:@"%@",imageName];
        NSURL *avatarUrl=[NSURL URLWithString:avatarString];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(INSETS, (CELL_HEIGHT-HEAD_SIZE)/2,HEAD_SIZE , HEAD_SIZE)];
        [imageView setImageWithURL:avatarUrl
                  placeholderImage:[UIImage imageNamed:@"defAvatar.png"]
                           success:^(UIImage *image){
                               _userHead.image = image;
                           }
                           failure:^(NSError *error){}];
    }else{
        _userHead.image = [UIImage imageNamed:@"defAvatar.png"];
    }

}

@end
