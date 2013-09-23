//
//  ChatCellViewController.h
//  WuTongCity
//
//  Created by alan  on 13-7-9.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatMessageCell :  UITableViewCell
{
    UIImageView *_userHead;
    UILabel *_userNickname;
    UILabel *_messageConent;
    UILabel *_timeLable;
    UIImageView *_cellBkg;
}

-(void)setUnionObject:(WCMessageUserUnionObject*)aUnionObj;
-(void)setHeadImage:(NSString*)imageName;

@end
