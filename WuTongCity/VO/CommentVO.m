//
//  CommentVO.m
//  WuTongCity
//
//  Created by alan  on 13-9-1.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "CommentVO.h"

@implementation CommentVO

@synthesize commentId;
@synthesize userId;//id
@synthesize avatar;//用户头像
@synthesize nickName;//用户昵称
@synthesize signature;//个性签名
@synthesize msgId;//父信息id
@synthesize content;//内容
@synthesize status;//状态
@synthesize createTime;//创建时间
@synthesize modifyTime;//最后修改时间


-(id)initWityCommentId:(NSString *)_commentId
                userId:(NSString *)_userId
                avatar:(NSString *)_avatar
              nickName:(NSString *)_nickName
             signature:(NSString *)_signature
                 msgId:(NSString *)_msgId
               content:(NSString *)_content
                status:(NSString *)_status
            createTime:(NSString *)_createTime
            modifyTime:(NSString *)_modifyTime{
    if (self = [super init]) {
        self.commentId = _commentId;
        self.avatar = _avatar;
        self.nickName = _nickName;
        self.signature = _signature;
        self.userId = _userId;
        self.msgId =  _msgId;
        self.content =  _content;
        self.status =  _status;
        self.createTime =  _createTime;
        self.modifyTime =  _modifyTime;
    }
    return self;


    
}

@end
