//
//  MsgComment.m
//  WuTongCity
//
//  Created by alan  on 13-8-21.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "MsgComment.h"

@implementation MsgComment
@synthesize uuid;
@synthesize msgId;//父信息id
@synthesize content;//内容
@synthesize author;//发布者
@synthesize status;//状态
@synthesize createTime;//创建时间
@synthesize modifyTime;//最后修改时间

-(id) initWithUuid:(NSString *)_uuid
             msgId:(NSString *)_msgId
           content:(NSString *)_content
            

            author:(User *)_author
            status:(NSString *)_status
        createTime:(NSString *)_createTime
        modifyTime:(NSString *)_modifyTime{
    if (self = [super init]) {
        self.uuid = _uuid;
        self.msgId =  _msgId;
        self.content =  _content;
        self.author =  _author;
        self.status =  _status;
        self.createTime =  _createTime;
        self.modifyTime =  _modifyTime;
    }
    return self;
}

@end
