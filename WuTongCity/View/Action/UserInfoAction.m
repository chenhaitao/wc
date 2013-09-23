////
////  UserInfoAction.m
////  CampaignPro
////
////  Created by alan on 12-9-9.
////  Copyright (c) 2012年 my conpany. All rights reserved.
////
//
//#import "UserInfoAction.h"
//#import "MD5.h"
//
//@implementation UserInfoAction
//
////设置静态类
//static UserInfoAction *userInfoAction = nil;
//+(UserInfoAction *) sharedInstance
//{
//    if (userInfoAction == nil) {
//        userInfoAction = [[UserInfoAction alloc]init];
//    }
//    return userInfoAction;
//}
//
//-(id)init{
//    if(self = [super init]){
////        sendRequestData = [[SendRequestData alloc]init];
////        requestDic = [[NSMutableDictionary alloc]init];
//        //userImie = [[UIDevice currentDevice] uniqueIdentifier];//获取手机imei码
//        // CCLOG(@"IMEI  %@",userImie);
//    }
//    return self;
//}
//
//-(void)userLogin:(NSString *)_username password:(NSString *)_password villageId:(NSString *)_villageId{
//    //发送登录请求
//    ASIFormDataRequest *loginReq=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:[RequestLinkUtil getUrlByKey:USER_LOGIN_URL]]];
//    [loginReq setPostValue:_username forKey:LOGIN_ID];//账号
//    [loginReq setPostValue:[MD5 md5:_username] forKey:LOGIN_PASSWORD];//密码
//    [loginReq setPostValue:IPHONE forKey:LOGIN_TYPE];//访问类型
//    [loginReq setPostValue:_villageId forKey:@"villageId"];
//    [loginReq setDelegate:self];
//    [loginReq setDidFinishSelector:@selector(loginSuccess:)];
//    [loginReq setDidFailSelector:@selector(requestError:)];
//    [loginReq startAsynchronous];
//    
//    NSError *error = [loginReq error];
//    
//    //返回结果没有出错，且不为空
//    
//    if (!error && [loginReq responseString]!=nil) {
//        NSDictionary *reqDict = [loginReq.responseString JSONValue];
//        if ([reqDict objectForKey:@"userInfo"]) {
//            NSDictionary*userInfoDict = [reqDict objectForKey:@"userInfo"];
//            
//            //初始化用户信息
//            UserVO *userVO = [[UserVO alloc] initLoginUserWithDict:userInfoDict];
//            [DataCenter sharedInstance].userVO = userVO;//放入数据中心
//            
//            
//            if([[NSUserDefaults standardUserDefaults] objectForKey:@"userList"]){//有就取
//                NSMutableArray *userList = [[NSUserDefaults standardUserDefaults] objectForKey:@"userList"];
//                [userList addObject:localDict];
//            }
//
//            
//            //以用户uuid和账号密码注册openfire服务器
//            XMPPManager *xmppManager = [XMPPManager sharedInstance];
//            if (isLogin)//登录为真
//                xmppManager.isLoginOperation = YES;
//            else
//                xmppManager.isLoginOperation = NO;
//            
//            if ([xmppManager connect]) {
//                //进入主菜单
//                TableBarViewController *tabbar = [[TableBarViewController alloc]init];
//                [self.navigationController presentViewController:tabbar animated:NO completion:nil];
//            }else{
//                [[[UIAlertView alloc]initWithTitle:@"梧桐邑" message:@"登陆失败" delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil] show];
//            }
//        }else{
//            UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"梧桐邑" message:@"登陆失败" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
//            [av show];
//            
//        }
//        [HUD hide:YES];
//    }else {
//        //        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:PROMPT
//        //                                                       message:SERVICE_ERROR
//        //                                                      delegate:self
//        //                                             cancelButtonTitle:OK
//        //                                             otherButtonTitles:nil];
//        //        [alert show];
//        
//    }
//}
//
////用户注册
//-(NSString *) userRegister:(NSString *)_loginName
//                       pwd:(NSString *)_pwd
//                  nickName:(NSString *)_nickName
//                     vCode:(NSString *)_vCode
//                 villageId:(NSString *)_villageId{
//    //发送注册请求
//    NSURL *url = [NSURL URLWithString:[RequestLinkUtil getUrlByKey:USER_REGISTER_URL]];
//    ASIFormDataRequest *registerReq=[ASIFormDataRequest requestWithURL:url];
//    [registerReq setPostValue:_loginName forKey:@"loginId"];//账号
//    [registerReq setPostValue:[MD5 md5:_pwd] forKey:@"loginPassword"];//密码
//    [registerReq setPostValue:_nickName forKey:@"nickName"];//昵称
//    [registerReq setPostValue:_vCode forKey:@"vCode"];//验证码
//    [registerReq setPostValue:_villageId forKey:@"villageId"];//小区id
////    [registerReq setDelegate:self];
//    [registerReq setCompletionBlock:^{
//        NSLog(@"%@",[registerReq responseString]);
//        //        NSString *responseStr = [limitUserReq responseString];
//        //        if (responseStr.length > 0) {
//        //            NSArray *arr = [[responseStr JSONValue] objectForKey:@"result"];
//        //            for (NSDictionary *dict in arr) {
//        //                [limitArray addObject:[[UserVO alloc] initLimitUserWithDict:dict]];
//        //            }
//        //        }else{
//        //            UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"安全隐私" message:@"限制用户读取失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        //            [av show];
//        //        }
//        
//    }];
//    [registerReq setFailedBlock:^{
//        UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"梧桐邑" message:@"服务器异常" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        [av show];
//    }];
//    [registerReq startAsynchronous];
//    
//    
//
//
//
//}
//////注册
////-(NSString *)registerByLoginId:(NSString *)loginId
////                 loginPassword:(NSString *)loginPassword
////                     villageId:(NSString *)villageId
////                      nickName:(NSString *)nickName
////                         vCode:(NSString *)vCode{
////    sendRequestData.urlBykey = USER_REGISTER_URL;
////    [requestDic setValue:loginId forKey:@"loginId"];
////    [requestDic setValue:loginPassword forKey:@"loginPassword"];
////    [requestDic setValue:villageId forKey:@"villageId"];
////    [requestDic setValue:nickName forKey:@"nickName"];
////    [requestDic setValue:vCode forKey:@"vCode"];
////    sendRequestData.dataDic = requestDic;
////    return [sendRequestData sendRequestBySyn];
////    
//////    String loginId = activityContext.getString("loginId");
//////    String loginPassword = activityContext.getString("loginPassword");
//////    String villageId = activityContext.getString("villageId");
//////    String residenceId = activityContext.getString("residenceId");
//////    String roleId = activityContext.getString("roleId");
//////    String vCode = activityContext.getString("vCode");
//////    String nickName = activityContext.getString("nickName");
//////    villageId=402881ef402989de0140298c70e30001
////}
////
//////登录游戏
////-(NSString *) userLogin:(NSString *)_username password:(NSString *)_password{
////    //根据用户名，密码，IMEI码进行注册
////    sendRequestData.urlBykey = 1;
////    [requestDic setObject:@"login" forKey:@"method"];
////    [requestDic setObject:_username forKey:@"username"];
////    [requestDic setObject:_password forKey:@"password"];
////    sendRequestData.dataDic = requestDic;
////    return [sendRequestData sendRequestBySyn];
////}
////
//////查找用户
////-(NSString *) searchUser:(int)_userid{
////    //根据用户id查找用户信息
////    sendRequestData.urlBykey = 4;
////    [requestDic setObject:@"searchUser" forKey:@"method"];
////    [requestDic setObject:[NSString stringWithFormat:@"%d",_userid] forKey:@"userID"];
////    sendRequestData.dataDic = requestDic;
////    return [sendRequestData sendRequestBySyn];
////}
//
//
//@end
