////
////  VillageAction.m
////  WuTongCity
////
////  Created by alan  on 13-8-19.
////  Copyright (c) 2013年 alan. All rights reserved.
////
//
//#import "VillageAction.h"
//#import "SBJson.h"
//#import "Village.h"
//#import "DataCenter.h"
//#import "RequestLinkUtil.h"
//
//@implementation VillageAction
//
////设置静态类
//static VillageAction *villageAction = nil;
//+(VillageAction *) sharedInstance
//{
//    if (villageAction == nil) {
//        villageAction = [[VillageAction alloc]init];
//    }
//    return villageAction;
//}
//
//-(id)init{
//    if(self = [super init]){
//        requestDic = [[NSMutableDictionary alloc]init];
//        result = [[NSString alloc]init];
//    }
//    return self;
//}
//
//
//
////小区列表信息
//-(NSString *) getVillageList{
//    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:[RequestLinkUtil getUrlByKey:VILLAGE_LIST]]];
//    [request setDelegate:self];
//    [request setDidFinishSelector:@selector(requestSuccess:)];
//    [request setDidFailSelector:@selector(requestError:)];
//    [request startAsynchronous];
//
//    
//    
//    
//    
//    
////    DataCenter *dataCenter = [DataCenter sharedInstance];
////    sendRequestData.urlBykey = VILLAGE_LIST;
////    sendRequestData.dataDic = requestDic;
////    result = [sendRequestData sendRequestBySyn];
////    NSArray *villageArray = [[result JSONValue] objectForKey:@"result"];
////    NSLog(@"%d",villageArray.count);
////    
////    for (NSDictionary *villageDict in villageArray) {
////        Village * v = [[Village alloc]init];
////        v.uuid = [villageDict objectForKey:@"uuid"];
////        v.name = [villageDict objectForKey:@"name"];
////        [dataCenter.villageArray addObject:v];
////    }
//    
//    
////    Class cls = NSClassFromString(@"Village");
////    id obj = [[cls alloc]init];
//////    SEL selector = NSSelectorFromString(@"uuid");
////    [obj performSelector:NSSelectorFromString(@"setName:") withObject:@"sdfsdf"];
////    
////    NSLog(@"%@",[obj name]);
////    
////    NSMutableArray *array = [[NSMutableArray alloc]initWithObjects:obj, nil];
////    
////    
////    Village *v = [array objectAtIndex:0];
////    NSLog(@"%@",[v name]);
//    
//    
//    
//    return nil;
//}
//
//
//
//
//@end
