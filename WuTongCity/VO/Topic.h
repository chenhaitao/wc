//
//  Topic.h
//  WuTongCity
//
//  Created by alan  on 13-8-21.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Topic : NSObject

@property (strong, nonatomic) NSString *uuid;
@property (strong, nonatomic) NSString *villageId;//小区id
@property (strong, nonatomic) NSString *groupId;//圈子id
@property (strong, nonatomic) NSString *title;//标题
@property (strong, nonatomic) NSString *content;//内容
@property (strong, nonatomic) NSString *isStick;//是否置顶
@property (strong, nonatomic) User *author;//发布者
@property (strong, nonatomic) NSString *shares;//共享次数
@property (strong, nonatomic) NSString *comments;//评论数量
@property (strong, nonatomic) NSString *praies;//赞的次数
@property (strong, nonatomic) NSString *status;//状态
@property (strong, nonatomic) NSString *createTime;//创建时间
@property (strong, nonatomic) NSString *modifyTime;//最后修改时间

@property (strong, nonatomic) NSMutableArray *imageArray;//图片集合
@property (strong, nonatomic) NSMutableArray *commentArray;//评论集合

-(id) initWithUuid:(NSString *)_uuid
         villageId:(NSString *)_villageId
           groupId:(NSString *)_groupId
             title:(NSString *)_title
           content:(NSString *)_content
           isStick:(NSString *)_isStick
            author:(User *)_author
            shares:(NSString *)_shares
          comments:(NSString *)_comments
            praies:(NSString *)_praies
            status:(NSString *)_status
        createTime:(NSString *)_createTime
        modifyTime:(NSString *)_modifyTime;

@end
