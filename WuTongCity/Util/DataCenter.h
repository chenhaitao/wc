//
//  DataCenter.h
//  CampaignPro
//
//  Created by alan on 12-9-12.
//  Copyright (c) 2012年 my conpany. All rights reserved.
//

#import "Village.h"
#import "UserVO.h"


@interface DataCenter : NSObject

//小区集合
@property (strong, nonatomic) NSMutableArray *villageArray;

//用户信息
@property (strong, nonatomic) UserVO *userVO;
@property (strong, nonatomic) Village *village;
//用户信息字典
@property (strong, nonatomic) NSMutableDictionary *userSettingDict;
//邻居说列表数据
@property (strong, nonatomic) NSMutableArray *weiboArray;
//邻居列表
@property (strong, nonatomic) NSMutableArray *neighborArray;


//广告imageArray
@property (strong, nonatomic) NSMutableArray *advertisementArray;

//消息通知字典
@property (strong, nonatomic) NSMutableDictionary *msgNoticeDict;

@property (strong, nonatomic) NSMutableArray *accList;

@property (strong, nonatomic) NSDictionary *errorDict;



+(DataCenter *) sharedInstance;

//登录后设置本地账号
-(void) setLocalAccount;

//当用户选择小区时，通过小区id在本地查找登录过的用户
-(NSDictionary *) searchLoaclAccountByVillageId;

//通过登录时间找到最近一次登录的本地用户
-(NSDictionary *) searchLocalAccountByTime;

@end
