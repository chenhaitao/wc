//
//  BuildingActVO.h
//  CampaignPro
//
//  Created by alan on 12-11-30.
//  Copyright (c) 2012年 my conpany. All rights reserved.
// 

@interface UserVO : NSObject


@property (strong, nonatomic) NSString *loginId;
@property (strong, nonatomic) NSString *password;

@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *userPersonalityId;//个性化信息id
@property (strong, nonatomic) NSString *avatar;//用户头像
@property (strong, nonatomic) NSString *nickName;//用户昵称
@property (strong, nonatomic) NSString *signature;//个性签名
@property (strong, nonatomic) NSString *realName;//真实姓名
@property (assign, nonatomic) int realNamePrivacy;
@property (assign, nonatomic) int certified;//认证状态
@property (strong, nonatomic) NSString *createTime;//创建时间
@property (strong, nonatomic) NSString *employer;//工作单位
@property (assign, nonatomic) int employerPrivacy;
@property (assign, nonatomic) int sex;//性别
@property (assign, nonatomic) int sexPrivacy;
@property (strong, nonatomic) NSString *mobile;//用户电话
@property (assign, nonatomic) int mobilePrivacy;
@property (strong, nonatomic) NSString *birthday;//生日
@property (assign, nonatomic) int birthdayPrivacy;//生日
@property (strong, nonatomic) NSString *album;//相册
@property (strong, nonatomic) NSString *villageId;//小区id
@property (assign, nonatomic) int residencePrivacy;
@property (strong, nonatomic) NSString *userResidenceId;//小区id
@property (strong, nonatomic) NSString *residenceId;//住宅id
@property (strong, nonatomic) NSString *building;//门栋号
@property (strong, nonatomic) NSString *unit;//单元
@property (strong, nonatomic) NSString *room;//房间
@property (strong, nonatomic) NSString *house;//门栋号+单元+房间
@property (assign, nonatomic) int isRestrict;//是否限制
@property (assign, nonatomic) int isShield;//是否屏蔽
@property (assign, nonatomic) int isStick;//是否置顶
@property (assign, nonatomic) int isTempAcount;//是否是临时帐户
@property (strong, nonatomic) NSString *restrictId;//限制id
@property (strong, nonatomic) NSString *shieldId;//屏蔽id
@property (strong, nonatomic) NSString *stickId;//置顶id


//登录时间，保存本地
@property (strong ,nonatomic) NSDate *loginTime;


-(id) initNeighbourWithDict:(NSDictionary *)dict;

-(id) initLoginUserWithDict:(NSDictionary *)dict loginId:(NSString *)_loginId password:(NSString *)_password;


-(NSMutableDictionary *)getUserDcit;


@end
