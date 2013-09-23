//
//  CommentVO.h
//  WuTongCity
//
//  Created by alan  on 13-9-1.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentVO : NSObject

@property (strong, nonatomic) NSString *commentId;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *avatar;//用户头像
@property (strong, nonatomic) NSString *nickName;//用户昵称
@property (strong, nonatomic) NSString *signature;//个性签名
@property (strong, nonatomic) NSString *msgId;//父信息id
@property (strong, nonatomic) NSString *content;//内容
@property (strong, nonatomic) NSString *status;//状态
@property (strong, nonatomic) NSString *createTime;//创建时间
@property (strong, nonatomic) NSString *modifyTime;//最后修改时间

-(id)initWityCommentId:(NSString *)_commentId
                userId:(NSString *)_userId
                avatar:(NSString *)_avatar
              nickName:(NSString *)_nickName
             signature:(NSString *)_signature
                 msgId:(NSString *)_msgId
               content:(NSString *)_content
                status:(NSString *)_status
            createTime:(NSString *)_createTime
            modifyTime:(NSString *)_modifyTime;

@end
