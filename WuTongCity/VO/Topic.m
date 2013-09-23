//
//  Topic.m
//  WuTongCity
//
//  Created by alan  on 13-8-21.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "Topic.h"

@implementation Topic
@synthesize uuid;
@synthesize villageId;//小区id
@synthesize groupId;//圈子id
@synthesize title;//标题
@synthesize content;//内容
@synthesize isStick;//是否置顶
@synthesize author;//发布者
@synthesize shares;//共享次数
@synthesize comments;//评论数量
@synthesize praies;//赞的次数
@synthesize status;//状态
@synthesize createTime;//创建时间
@synthesize modifyTime;//最后修改时间

@synthesize imageArray;//图片集合
@synthesize commentArray;//评论集合

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
        modifyTime:(NSString *)_modifyTime{
    if (self = [super init]) {
        self.uuid = _uuid;
        self.villageId =  _villageId;
        self.groupId =  _groupId;
        self.title =  _title;
        self.content =  _content;
        self.isStick =  _isStick;
        self.author =  _author;
        self.shares =  _shares;
        self.comments =  _comments;
        self.praies =  _praies;
        self.status =  _status;
        self.createTime =  _createTime;
        self.modifyTime =  _modifyTime;
        
        self.imageArray = [[NSMutableArray alloc] init];
        self.commentArray = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
