//
//  MsgComment.h
//  WuTongCity
//
//  Created by alan  on 13-8-21.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface MsgComment : NSObject

@property (strong, nonatomic) NSString *uuid;
@property (strong, nonatomic) NSString *msgId;//父信息id
@property (strong, nonatomic) NSString *content;//内容
@property (strong, nonatomic) User *author;//发布者
@property (strong, nonatomic) NSString *status;//状态
@property (strong, nonatomic) NSString *createTime;//创建时间
@property (strong, nonatomic) NSString *modifyTime;//最后修改时间

-(id) initWithUuid:(NSString *)_uuid
             msgId:(NSString *)_msgId
           content:(NSString *)_content
            author:(User *)_author
            status:(NSString *)_status
        createTime:(NSString *)_createTime
        modifyTime:(NSString *)_modifyTime;

@end
