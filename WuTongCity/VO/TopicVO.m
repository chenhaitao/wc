//
//  TocicVO.m
//  WuTongCity
//
//  Created by alan  on 13-8-29.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "TopicVO.h"
//#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"

@implementation TopicVO

@synthesize topicId;
@synthesize msgType;
@synthesize userId;//id
@synthesize avatar;//用户头像
@synthesize nickName;//用户昵称
@synthesize signature;//个性签名
//@synthesize villageId;//小区id
@synthesize title;//标题
@synthesize content;//内容
//@synthesize isStick;//是否置顶
//@synthesize shares;//共享次数
@synthesize comments;//评论数量
@synthesize praies;//赞的次数
//@synthesize status;//状态
@synthesize createTime;//创建时间
//@synthesize modifyTime;//最后修改时间
@synthesize imageArray;//图片集合
//@synthesize commentArray;//评论集合
@synthesize isShow;


//-(id)initWityTopicId:(NSString *)_topicId
//             msgType:(NSString *)_msgType
//              userId:(NSString *)_userId
//              avatar:(NSString *)_avatar
//            nickName:(NSString *)_nickName
//           signature:(NSString *)_signature
//               title:(NSString *)_title
//             content:(NSString *)_content
//            comments:(NSString *)_comments
//          createTime:(NSString *)_createTime
//          imageArray:(NSArray *)_imageArray{
//    if(self = [super init]){
//        self.topicId = _topicId;
//        self.msgType = _msgType;
//        self.userId = _userId;
//        self.avatar = _avatar;
//        self.nickName = _nickName;
//        self.signature = _signature;
//        self.title = _title;
//        self.content = _content;
//        self.comments = _comments;
//        self.createTime = _createTime;
//        self.imageArray = _imageArray;
//    }
//    return self;
//}

-(id) initTopicVOWithDict:(NSDictionary *)dict{

    if(self = [super init]){
        self.topicId = [dict objectForKey:@"uuid"];
        self.msgType = [dict objectForKey:@"msgType"];
        self.userId = [dict objectForKey:@"userId"];
        self.avatar = [dict objectForKey:@"avatar"];
        self.nickName = [dict objectForKey:@"nickName"];
        self.signature = [dict objectForKey:@"signature"];
        self.title = [dict objectForKey:@"title"];
        self.content = [dict objectForKey:@"content"];
        self.comments = [[dict objectForKey:@"comments"] intValue];
        self.praies = [[dict objectForKey:@"praises"] intValue];
        self.createTime = [dict objectForKey:@"createTime"];
        self.imageArray = [dict objectForKey:@"imageList"];
        
        self.isShow = NO;
    }
    return self;
}






@end
