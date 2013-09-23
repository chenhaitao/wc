//
//  UserEntity.h
//  CampaignPro
//
//  Created by alan on 12-10-13.
//  Copyright (c) 2012年 my conpany. All rights reserved.
//


@interface User:NSObject

@property (strong, nonatomic) NSString *uuid;
@property (strong, nonatomic) NSString *userPersonalityId;//
@property (strong, nonatomic) NSString *avatar;//用户头像
@property (strong, nonatomic) NSString *nickName;//用户昵称
@property (strong, nonatomic) NSString *signature;//个性签名
@property (strong, nonatomic) NSString *address;//用户地址
@property (strong, nonatomic) NSString *realName;//真实姓名
@property (strong, nonatomic) NSString *certified;//认证状态
@property (strong, nonatomic) NSString *createTime;//创建时间
@property (strong, nonatomic) NSString *idType;//证件类型
@property (strong, nonatomic) NSString *idNo;//证件号码
@property (strong, nonatomic) NSString *position;//职位
@property (strong, nonatomic) NSString *employer;//工作单位
@property (strong, nonatomic) NSString *sex;//性别
@property (strong, nonatomic) NSString *mobile;//用户电话
@property (strong, nonatomic) NSString *email;//电子邮箱
@property (strong, nonatomic) NSString *birthday;//生日
@property (strong, nonatomic) NSString *industry;//行业
@property (strong, nonatomic) NSString *mobileVerified;//移动电话认证状态
@property (strong, nonatomic) NSString *emailVerified;//邮箱认证状态
@property (strong, nonatomic) NSString *modifyTime;//修改时间

@property (strong, nonatomic) NSString *album;//相册

@property (assign, nonatomic) int userType;//用户类型

@property (assign, nonatomic) BOOL isChecked;

-(NSMutableDictionary *)getUserDcit;

-(id)initUserByUuid:(NSString *)_uuid
  userPersonalityId:(NSString *)_userPersonalityId
             avatar:(NSString *)_avatar
           nickName:(NSString *)_nickName
          signature:(NSString *)_signature
         createTime:(NSString *)_createTime
             idType:(NSString *)_idType
               idNo:(NSString *)_idNo
           position:(NSString *)_position
           employer:(NSString *)_employer
                sex:(NSString *)_sex
             mobile:(NSString *)_mobile
              email:(NSString *)_email
           birthday:(NSString *)_birthday
           industry:(NSString *)_industry
     mobileVerified:(NSString *)_mobileVerified
      emailVerified:(NSString *)_emailVerified
         modifyTime:(NSString *)_modifyTime
              album:(NSString *)_album;

@end
