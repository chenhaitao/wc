//
//  UserInfoAction.m
//  CampaignPro
//
//  Created by alan on 12-9-9.
//  Copyright (c) 2012年 my conpany. All rights reserved.
//

#import "UserInfoAction.h"

@implementation UserInfoAction

//设置静态类
static UserInfoAction *userInfoAction = nil;
+(UserInfoAction *) sharedInstance
{
    if (userInfoAction == nil) {
        userInfoAction = [[UserInfoAction alloc]init];
    }
    return userInfoAction;
}

-(id)init{
    if(self = [super init]){
        sendRequestData = [[SendRequestData alloc]init];
        requestDic = [[NSMutableDictionary alloc]init];
        //userImie = [[UIDevice currentDevice] uniqueIdentifier];//获取手机imei码
        // CCLOG(@"IMEI  %@",userImie);
    }
    return self;
}

//快速开始游戏(根据imei码判断当前勇士是登录或者匿名注册游戏)
-(NSString *) startGame{
    sendRequestData.urlBykey = 1;
    [requestDic setObject:@"startGame" forKey:@"method"];
    [requestDic setObject:userImie forKey:@"imei"];
    sendRequestData.dataDic = requestDic;
    return [sendRequestData sendRequestBySyn];
}

//注册
-(NSString *)registerByLoginId:(NSString *)loginId
                 loginPassword:(NSString *)loginPassword
                     villageId:(NSString *)villageId
                      nickName:(NSString *)nickName
                         vCode:(NSString *)vCode{
    sendRequestData.urlBykey = USER_REGISTER_URL;
    [requestDic setValue:loginId forKey:@"loginId"];
    [requestDic setValue:loginPassword forKey:@"loginPassword"];
    [requestDic setValue:villageId forKey:@"villageId"];
    [requestDic setValue:nickName forKey:@"nickName"];
    [requestDic setValue:vCode forKey:@"vCode"];
    sendRequestData.dataDic = requestDic;
    return [sendRequestData sendRequestBySyn];
    
//    String loginId = activityContext.getString("loginId");
//    String loginPassword = activityContext.getString("loginPassword");
//    String villageId = activityContext.getString("villageId");
//    String residenceId = activityContext.getString("residenceId");
//    String roleId = activityContext.getString("roleId");
//    String vCode = activityContext.getString("vCode");
//    String nickName = activityContext.getString("nickName");
//    villageId=402881ef402989de0140298c70e30001
}

//登录游戏
-(NSString *) userLogin:(NSString *)_username password:(NSString *)_password{
    //根据用户名，密码，IMEI码进行注册
    sendRequestData.urlBykey = 1;
    [requestDic setObject:@"login" forKey:@"method"];
    [requestDic setObject:_username forKey:@"username"];
    [requestDic setObject:_password forKey:@"password"];
    sendRequestData.dataDic = requestDic;
    return [sendRequestData sendRequestBySyn];
}

//查找用户
-(NSString *) searchUser:(int)_userid{
    //根据用户id查找用户信息
    sendRequestData.urlBykey = 4;
    [requestDic setObject:@"searchUser" forKey:@"method"];
    [requestDic setObject:[NSString stringWithFormat:@"%d",_userid] forKey:@"userID"];
    sendRequestData.dataDic = requestDic;
    return [sendRequestData sendRequestBySyn];
}


@end
