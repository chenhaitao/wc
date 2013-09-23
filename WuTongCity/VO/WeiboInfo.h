//
//  WeiboInfo.h
//  WuTongCity
//
//  Created by alan  on 13-8-8.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeiboInfo : NSObject

@property (assign, nonatomic) NSString *loginId;//用户id
@property (strong, nonatomic) NSString *nickname;//用户昵称
@property (strong, nonatomic) NSString *userImg;//用户头像
@property (strong, nonatomic) NSString *title;//标题
@property (strong, nonatomic) NSString *details;//内容
@property (strong, nonatomic) NSString *pubTime;//发布时间

@property (strong, nonatomic) NSMutableArray *imgArray;//图片集合


@end
