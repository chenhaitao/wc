//
//  ChatSendMessageCell.h
//  WuTongCity
//
//  Created by alan  on 13-8-28.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import <UIKit/UIKit.h>
//头像大小
#define HEAD_SIZE 50.0f
#define TEXT_MAX_HEIGHT 500.0f
//间距
#define INSETS 8.0f


@interface ChatSendMessageCell : UITableViewCell{
    UIImageView *_userHead;
    UIImageView *_bubbleBg;
    UIImageView *_headMask;
    UILabel *_messageConent;
}
@property (nonatomic) enum kWCMessageCellStyle msgStyle;
@property (nonatomic) int height;
-(void)setMessageObject:(WCMessageObject*)aMessage;
-(void)setHeadImageWithName:(NSString *)imageName;

@end
