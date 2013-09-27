//
//  BuildingActVO.m
//  CampaignPro
//
//  Created by alan on 12-11-30.
//  Copyright (c) 2012年 my conpany. All rights reserved.
//

#import "UserVO.h"
#import "DateUtil.h"

@implementation UserVO

@synthesize loginId;
@synthesize password;

@synthesize userId;
@synthesize userPersonalityId;//个性化信息id
@synthesize avatar;//用户头像
@synthesize nickName;//用户昵称
@synthesize signature;//个性签名
@synthesize realName;//真实姓名
@synthesize realNamePrivacy;
@synthesize birthdayPrivacy;
@synthesize certified;//认证状态
@synthesize createTime;//创建时间
@synthesize employer;//工作单位
@synthesize employerPrivacy;
@synthesize sex;//性别
@synthesize sexPrivacy;
@synthesize mobile;//用户电话
@synthesize mobilePrivacy;
@synthesize birthday;//生日
@synthesize album;//相册
@synthesize villageId;//小区id
@synthesize userResidenceId;
@synthesize residencePrivacy;
@synthesize residenceId;//用户住宅id
@synthesize building;//门栋号
@synthesize unit;//单元
@synthesize room;//房间
@synthesize house;
@synthesize isRestrict;//是否限制
@synthesize isShield;//是否屏蔽
@synthesize isStick;//是否置顶
@synthesize restrictId;//限制id
@synthesize shieldId;//屏蔽id
@synthesize stickId;//置顶id

//登录时间，保存本地
@synthesize loginTime;

-(id) initNeighbourWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        self.userId = [dict objectForKey:@"userId"];
        self.userPersonalityId = [dict objectForKey:@"uuid"];
        self.avatar = [dict objectForKey:@"avatar"];
        self.nickName = [dict objectForKey:@"nickName"];
        self.signature = [dict objectForKey:@"signature"];
        self.realName = [dict objectForKey:@"realName"];
        self.employer = [dict objectForKey:@"employer"];
        self.sex = [[dict objectForKey:@"sex"]intValue];
        self.mobile = [dict objectForKey:@"mobile"];
        //生日
        
        if (![[dict objectForKey:@"birthday"] isEqualToString:@""]) {
            self.birthday = [DateUtil StringFromString:[dict objectForKey:@"birthday"] format:@"yyyy年MM月d日"];
        }else{
            self.birthday = @"";
        }
        self.villageId = [DataCenter sharedInstance].village.uuid;
        self.building = [dict objectForKey:@"building"];
        self.unit = [dict objectForKey:@"unit"];
        self.room = [dict objectForKey:@"room"];
        self.house = @"";
        if (![self.building isEqualToString:@""]) {
            NSMutableString *userResidence = [[NSMutableString alloc] init];
            if (self.building > 0) {
                [userResidence appendFormat:@"%@栋",self.building];
                if (self.unit > 0) {
                    [userResidence appendFormat:@"%@单元",self.building];
                    if (![self.room isEqualToString:@""]) {
                        [userResidence appendFormat:@"%@室",self.room];
                    }
                }
            }
            self.house = userResidence;
        }
        self.isRestrict = [[dict objectForKey:@"isRestrict"] intValue];
        self.isShield = [[dict objectForKey:@"isShield"] intValue];
        self.isStick = [[dict objectForKey:@"isStick"] intValue];
        self.restrictId = [dict objectForKey:@"restrictId"];
        self.shieldId = [dict objectForKey:@"shieldId"];
        self.stickId = [dict objectForKey:@"stickId"];
        
        
        self.album = @"defablum.png";
        
    }
    return self;
}

-(id) initLoginUserWithDict:(NSDictionary *)dict loginId:(NSString *)_loginId password:(NSString *)_password{
    if (self = [super init]) {
        self.loginId = [dict objectForKey:@"loginId"];
        self.password = [dict objectForKey:@"loginPassword"];
        //用户个性化设置字典
        NSArray *userPersonalityArray = [dict objectForKey:@"userPersonality"];
        NSDictionary*userPersonalityDict = [userPersonalityArray objectAtIndex:0];//个性化设置信息
        NSDictionary *userResidencesDict = [[dict objectForKey:@"userResidences"] objectAtIndex:0];//用户住宅信息
        NSDictionary *residenceDict = [userResidencesDict objectForKey:@"residence"];//用户门栋号信息
        
        
        self.userId = [dict objectForKey:@"uuid"];
        self.userPersonalityId = [userPersonalityDict objectForKey:@"uuid"];
        self.avatar = [userPersonalityDict objectForKey:@"avatar"];
        self.nickName = [userPersonalityDict objectForKey:@"nickName"];
        self.signature = [userPersonalityDict objectForKey:@"signature"];
        self.realName = [dict objectForKey:@"realName"];
        self.realNamePrivacy = [[userPersonalityDict objectForKey:@"realNamePrivacy"] intValue];
        self.certified = [[dict objectForKey:@"certified"]intValue];
        self.createTime = [dict objectForKey:@"createTime"];
        self.employer = [dict objectForKey:@"employer"];
        self.employerPrivacy = [[userPersonalityDict objectForKey:@"employerPrivacy"] intValue];
        self.sex = [[dict objectForKey:@"sex"]intValue];
        self.sexPrivacy = [[userPersonalityDict objectForKey:@"sexPrivacy"]intValue];
        self.mobile = [dict objectForKey:@"mobile"];
        self.mobilePrivacy = [[userPersonalityDict objectForKey:@"mobilePrivacy"] intValue];
        //生日
        NSString *_birthday = [dict objectForKey:@"birthday"];
        if (![_birthday isEqualToString:@""]) {
            NSDate *date = [DateUtil dateFromString:_birthday format:@"yyyy-MM-dd HH:mm:ss"];
            self.birthday = [DateUtil stringFromDate:date format:@"yyyy年MM月d日"];
        }else{
            self.birthday = @"";
        }
        self.birthdayPrivacy = [[userPersonalityDict objectForKey:@"birthDayPrivacy"] intValue];
        self.userResidenceId = [userResidencesDict objectForKey:@"uuid"];
        self.residencePrivacy = [[userPersonalityDict objectForKey:@"residencePrivacy"] intValue];
        self.residenceId = [residenceDict objectForKey:@"uuid"];
        self.building = @"";
        self.unit = @"";
        self.room = @"";
        self.house = @"";
        self.building = [NSString stringWithFormat:@"%@",[residenceDict objectForKey:@"building"]];
        self.unit = [NSString stringWithFormat:@"%@",[residenceDict objectForKey:@"unit"]];
        self.room = [residenceDict objectForKey:@"room"];
        NSMutableString *userResidence = [[NSMutableString alloc] init];
        if (self.building > 0) {
            [userResidence appendFormat:@"%@栋",self.building];
            if (self.unit > 0) {
                [userResidence appendFormat:@"%@单元",self.building];
                if (![self.room isEqualToString:@""]) {
                    [userResidence appendFormat:@"%@室",self.room];
                }
            }
        }
        self.house = userResidence;
        
        self.album = @"defablum.png";
        self.loginTime = [NSDate date];
    }
    return self;
}

-(NSMutableDictionary *)getUserDcitForView{
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
    [userDict setValue:[NSString stringWithFormat:@"%d",self.mobilePrivacy] forKey:@"mark"];
    [userArray addObject:userDict];
    
    userDict = [[NSMutableDictionary alloc]init];
    [userDict setValue:house forKey:@"content"];
    [userDict setValue:ADDRESS forKey:@"title"];
    [userDict setValue:ADDRESS_MARK forKey:@"mark"];
    [userArray addObject:userDict];
    [userSection setValue:userArray forKey:[NSString stringWithFormat:@"%d",3]];
    
    //将性别、职业、生日放入第四个分组
    userArray = [[NSMutableArray alloc]init];
    userDict = [[NSMutableDictionary alloc]init];
    [userDict setValue:[NSString stringWithFormat:@"%d",self.sex]  forKey:@"content"];
    [userDict setValue:SEX forKey:@"title"];
    [userDict setValue:[NSString stringWithFormat:@"%d",self.sexPrivacy] forKey:@"mark"];
    [userArray addObject:userDict];
    
    userDict = [[NSMutableDictionary alloc]init];
    [userDict setValue:self.employer forKey:@"content"];
    [userDict setValue:EMPLOYER forKey:@"title"];
    [userDict setValue:[NSString stringWithFormat:@"%d",self.employerPrivacy] forKey:@"mark"];
    [userArray addObject:userDict];
    
    userDict = [[NSMutableDictionary alloc]init];
    [userDict setValue:self.birthday forKey:@"content"];
    [userDict setValue:BIRTHDAY forKey:@"title"];
    [userDict setValue:[NSString stringWithFormat:@"%d",self.birthdayPrivacy] forKey:@"mark"];
    [userArray addObject:userDict];
    [userSection setValue:userArray forKey:[NSString stringWithFormat:@"%d",4]];
    
    return userSection;
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
    [userDict setValue:house forKey:@"content"];
    [userDict setValue:ADDRESS forKey:@"title"];
    [userDict setValue:ADDRESS_MARK forKey:@"mark"];
    [userArray addObject:userDict];
    [userSection setValue:userArray forKey:[NSString stringWithFormat:@"%d",3]];
    
    //将性别、职业、生日放入第四个分组
    userArray = [[NSMutableArray alloc]init];
    userDict = [[NSMutableDictionary alloc]init];
    [userDict setValue:[NSString stringWithFormat:@"%d",self.sex]  forKey:@"content"];
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


@end
