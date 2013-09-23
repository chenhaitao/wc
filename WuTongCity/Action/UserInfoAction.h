//
//  UserInfoAction.h
//  CampaignPro
//
//  Created by alan on 12-9-9.
//  Copyright (c) 2012年 my conpany. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SendRequestData.h"
#import "ConstantValue.h"

@interface UserInfoAction : NSObject{
    SendRequestData *sendRequestData;
    NSString *userImie;//获取手机imei码
    NSMutableDictionary *requestDic;
}

+(UserInfoAction *) sharedInstance;

//快速开始游戏(根据imei码判断当前勇士是登录或者匿名注册游戏)
-(NSString *) startGame;

-(NSString *)registerByLoginId:(NSString *)loginId
             loginPassword:(NSString *)loginPassword
                 villageId:(NSString *)villageId
                  nickName:(NSString *)nickName
                     vCode:(NSString *)vCode;

//登录游戏
-(NSString *) userLogin:(NSString *)_username password:(NSString *)_password;

//查找用户
-(NSString *) searchUser:(int)_userid;

@end
