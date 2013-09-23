//
//  TocicVO.h
//  WuTongCity
//
//  Created by alan  on 13-8-29.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDWebImageManagerDelegate.h"
#import "UIImageView+WebCache.h"


@interface TopicVO : NSObject<SDWebImageManagerDelegate>

@property (strong, nonatomic) NSString *topicId;//微博id
@property (assign, nonatomic) int msgType;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *avatar;//用户头像
@property (strong, nonatomic) NSString *nickName;//用户昵称
@property (strong, nonatomic) NSString *signature;//个性签名
@property (strong, nonatomic) NSString *title;//标题
@property (strong, nonatomic) NSString *content;//内容
//@property (strong, nonatomic) NSString *isStick;//是否置顶
//@property (strong, nonatomic) NSString *shares;//共享次数
@property (assign, nonatomic) int comments;//评论数量
@property (assign, nonatomic) int praies;//赞的次数
//@property (strong, nonatomic) NSString *status;//状态
@property (strong, nonatomic) NSString *createTime;//创建时间
//@property (strong, nonatomic) NSString *modifyTime;//最后修改时间
@property (strong, nonatomic) NSMutableArray *imageArray;//图片集合
//@property (strong, nonatomic) NSMutableArray *commentArray;//评论集合

@property (assign, nonatomic) BOOL isShow;

//-(id)initWityTopicId:(NSString *)_topicId
//             msgType:(NSString *)_msgType
//              userId:(NSString *)_userId
//              avatar:(NSString *)_avatar
//            nickName:(NSString *)_nickName
//           signature:(NSString *)_signature
//               title:(NSString *)_title
//             content:(NSString *)_content
//            comments:(NSString *)_comments
//              praies:(NSString *)_praies
//          createTime:(NSString *)_createTime
//          imageArray:(NSArray *)_imageArray;

-(id) initTopicVOWithDict:(NSDictionary *)dict;


@end
