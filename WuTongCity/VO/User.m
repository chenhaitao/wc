//
//  UserEntity.m
//  CampaignPro
//
//  Created by alan on 12-10-13.
//  Copyright (c) 2012年 my conpany. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize uuid;//登录密码
@synthesize userPersonalityId;
@synthesize avatar;//用户头像
@synthesize nickName;//用户昵称
@synthesize signature;//个性签名
@synthesize address;//用户地址
@synthesize realName;//真实姓名
@synthesize certified;//认证状态
@synthesize createTime;//创建时间
@synthesize idType;//证件类型
@synthesize idNo;//证件号码
@synthesize position;//职位
@synthesize employer;//工作单位
@synthesize sex;//性别
@synthesize mobile;//用户电话
@synthesize email;//电子邮箱
@synthesize birthday;//生日
@synthesize industry;//行业
@synthesize mobileVerified;//移动电话认证状态
@synthesize emailVerified;//邮箱认证状态
@synthesize modifyTime;//修改时间

@synthesize album;
@synthesize userType;//用户类型

@synthesize isChecked;




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
              album:(NSString *)_album{
    if(self = [super init]){
        self.uuid = _uuid;
        self.userPersonalityId = _userPersonalityId;
        self.avatar = _avatar;
        self.nickName = _nickName;
        self.signature = _signature;
        self.createTime = _createTime;
        self.idType = _idType;
        self.idNo = _idNo;
        self.position = _position;
        self.employer = _employer;
        self.sex = _sex;
        self.mobile = _mobile;
        self.email = _email;
        self.birthday = _birthday;
        self.industry = _industry;
        self.mobileVerified = _mobileVerified;
        self.emailVerified = _emailVerified;
        self.modifyTime = _modifyTime;
        self.album = _album;
        self.isChecked = NO;
    }
    return self;
}


-(NSMutableDictionary *)getUserDcit{
    NSMutableDictionary *userSection = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *userDict = [[NSMutableDictionary alloc]init];
    NSMutableArray *userArray = [[NSMutableArray alloc]init];
    
    //头像---将头像放入第一个分组
    [userDict setValue:self.avatar forKey:@"content"];
    [userDict setValue:AVATAR forKey:@"title"];
    [userDict setValue:AVATAR_MARK forKey:@"mark"];
    [userArray addObject:userDict];
    [userSection setValue:userArray forKey:[NSString stringWithFormat:@"%d",1]];
    
    //将昵称、个性签名放入第二个分组
    userArray = [[NSMutableArray alloc]init];
    userDict = [[NSMutableDictionary alloc]init];
    [userDict setValue:self.nickName forKey:@"content"];
    [userDict setValue:NICKNAME forKey:@"title"];
    [userDict setValue:NICKNAME_MARK forKey:@"mark"];
    [userArray addObject:userDict];
    
    userDict = [[NSMutableDictionary alloc]init];
    [userDict setValue:self.signature forKey:@"content"];
    [userDict setValue:SIGNATURE forKey:@"title"];
    [userDict setValue:SIGNATURE_MARK forKey:@"mark"];
    [userArray addObject:userDict];
    [userSection setValue:userArray forKey:[NSString stringWithFormat:@"%d",2]];
    
    //将姓名、电话、住址放入第三个分组
    userArray = [[NSMutableArray alloc]init];
    userDict = [[NSMutableDictionary alloc]init];
    [userDict setValue:self.realName forKey:@"content"];
    [userDict setValue:REALNAME forKey:@"title"];
    [userDict setValue:REALNAME_MARK forKey:@"mark"];
    [userArray addObject:userDict];
    
    userDict = [[NSMutableDictionary alloc]init];
    [userDict setValue:self.mobile forKey:@"content"];
    [userDict setValue:MOBILE forKey:@"title"];
    [userDict setValue:MOBILE_MARK forKey:@"mark"];
    [userArray addObject:userDict];
    
    userDict = [[NSMutableDictionary alloc]init];
    [userDict setValue:self.address forKey:@"content"];
    [userDict setValue:ADDRESS forKey:@"title"];
    [userDict setValue:ADDRESS_MARK forKey:@"mark"];
    [userArray addObject:userDict];
    [userSection setValue:userArray forKey:[NSString stringWithFormat:@"%d",3]];
    
    //将性别、职业、生日放入第四个分组
    userArray = [[NSMutableArray alloc]init];
    userDict = [[NSMutableDictionary alloc]init];
    [userDict setValue:self.sex forKey:@"content"];
    [userDict setValue:SEX forKey:@"title"];
    [userDict setValue:SEX_MARK forKey:@"mark"];
    [userArray addObject:userDict];
    
    userDict = [[NSMutableDictionary alloc]init];
    [userDict setValue:self.employer forKey:@"content"];
    [userDict setValue:EMPLOYER forKey:@"title"];
    [userDict setValue:EMPLOYER_MARK forKey:@"mark"];
    [userArray addObject:userDict];
    
    userDict = [[NSMutableDictionary alloc]init];
    [userDict setValue:self.birthday forKey:@"content"];
    [userDict setValue:BIRTHDAY forKey:@"title"];
    [userDict setValue:BIRTHDAY_MARK forKey:@"mark"];
    [userArray addObject:userDict];
    [userSection setValue:userArray forKey:[NSString stringWithFormat:@"%d",4]];

    return userSection;
}

-(void)dealloc{
    
}

@end
