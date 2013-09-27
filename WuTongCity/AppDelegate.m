//
//  WutongCityAppDelegate.m
//  WutongCity
//
//  Created by alan  on 13-7-7.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "AppDelegate.h"
#import "SelectVillagelViewController.h"
#import "MD5.h"
#import "TableBarViewController.h"
#import "SelectVillagelViewController.h"

@implementation AppDelegate






- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    //add
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"addData.sqlite"];
    NSArray  *us = [WZUser MR_findAll];
    for (WZUser *u in us) {
        NSLog(@"%@:%@",u.nickName,u.loginTime);
    }
    
    NSArray *users =[WZUser   MR_findAllSortedBy:@"loginTime" ascending:NO];
    if (users.count > 0) {
        WZUser *user = [users objectAtIndex:0];
        BOOL flag = [[NSUserDefaults standardUserDefaults]  boolForKey:@"autoLogin"];
        if (user.loginId.length >0 && user.password.length >0 && flag) {
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:user.loginId,@"loginId",user.password,@"password",user.villageId,@"villageId", nil];
            [self login:dic];
        }else{
            SelectVillagelViewController *controller = [[SelectVillagelViewController alloc] init];
            UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:controller];
            navCtrl.navigationBar.barStyle = UIBarStyleBlack;
            self.window.rootViewController = navCtrl;
        }
    }else{
        SelectVillagelViewController *controller = [[SelectVillagelViewController alloc] init];
        UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:controller];
        navCtrl.navigationBar.barStyle = UIBarStyleBlack;
        self.window.rootViewController = navCtrl;
    }
    [self.window makeKeyAndVisible];
    
    //是否自动登录
   /* BOOL autoLogin = YES;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"%d",[userDefaults boolForKey:@"autoLogin"]);
    if([userDefaults boolForKey:@"autoLogin"] || (![userDefaults boolForKey:@"autoLogin"])){
        autoLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"autoLogin"];
        NSLog(@"%d",autoLogin);
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:autoLogin forKey:@"autoLogin"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    
    //自动登录
    if (autoLogin) {
        //如果当前本地已经右登录
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"accList"];
        NSDictionary *dict = [[NSDictionary alloc] init];
        dict = [[DataCenter sharedInstance] searchLocalAccountByTime];
        
        if(dict){
            [self login:dict];
        }else{
            SelectVillagelViewController *controller = [[SelectVillagelViewController alloc] init];
            UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:controller];
            navCtrl.navigationBar.barStyle = UIBarStyleBlack;
            self.window.rootViewController = navCtrl;
            [self.window makeKeyAndVisible];
        }
    }else{
        SelectVillagelViewController *controller = [[SelectVillagelViewController alloc] init];
        UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:controller];
        navCtrl.navigationBar.barStyle = UIBarStyleBlack;
        self.window.rootViewController = navCtrl;
        [self.window makeKeyAndVisible];
    }
    */

    // 监测网络情况
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    hostReach = [Reachability reachabilityWithHostName:@"http://www.baidu.com"];
    [hostReach startNotifier];
    return YES;
}

- (void)reachabilityChanged:(NSNotification *)note {
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    NSLog(@"%d",status);
    if (status == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"梧桐邑"
                                                        message:@"网络连接失败,请检查网络"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}


-(void) login:(NSDictionary *)_dict{
    //发送登录请求
    ASIFormDataRequest *autologinReq=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:[RequestLinkUtil getUrlByKey:USER_LOGIN_URL]]];
    [autologinReq setPostValue:[_dict objectForKey:@"loginId"] forKey:@"loginId"];//账号
    [autologinReq setPostValue:[_dict objectForKey:@"password"] forKey:@"loginPassword"];//密码
    [autologinReq setPostValue:IPHONE forKey:LOGIN_TYPE];//访问类型
    [autologinReq setPostValue:[_dict objectForKey:@"villageId"] forKey:@"villageId"];
    [autologinReq setDelegate:self];
    [autologinReq setCompletionBlock:^{
        NSDictionary *reqDict = [autologinReq.responseString JSONValue];
        if ([reqDict objectForKey:@"userInfo"]) {
            NSDictionary*userInfoDict = [reqDict objectForKey:@"userInfo"];
            //初始化用户信息
            UserVO *userVO = [[UserVO alloc] initLoginUserWithDict:userInfoDict loginId:[_dict objectForKey:@"loginId"] password:[_dict objectForKey:@"password"]];
            //add
            NSDictionary *dic = [userInfoDict objectForKey:@"account"];
            if (userVO.loginId.length == 0) {
                userVO.loginId = [dic objectForKey:@"loginId"];
                userVO.password = [dic objectForKey:@"loginPassword"];
                 userVO.isTempAcount = [dic objectForKey:@"isTempAcco"];
            }
            [DataCenter sharedInstance].userVO = userVO;//放入数据中心
           
            Village *village = [Village new];
            NSArray *userResidences = [userInfoDict objectForKey:@"userResidences"];
            NSDictionary *villagedic = [ [userResidences lastObject] objectForKey:@"village"];
            village.uuid = [villagedic objectForKey:@"uuid"];
            village.name = [villagedic objectForKey:@"name"];
            [DataCenter sharedInstance].village = village;//将选择的小区信息放入数据中心
            
            [[DataCenter sharedInstance] setLocalAccount];//登录后设置本地账号
            
            
            //以用户uuid和账号密码登录openfire服务器
            XMPPManager *xmppManager = [XMPPManager sharedInstance];
            xmppManager.isLoginOperation = YES;
            if ([xmppManager connect]) {
                //进入主菜单
                TableBarViewController *tabbar = [[TableBarViewController alloc]init];
                self.window.rootViewController = tabbar;
                [self.window makeKeyAndVisible];
                
                
                
                
            }else{
                [[[UIAlertView alloc]initWithTitle:@"梧桐邑" message:@"登陆失败" delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil] show];
            }
        }else{
            UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"梧桐邑" message:@"登陆失败" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
            [av show];
                SelectVillagelViewController *controller = [[SelectVillagelViewController alloc] init];
                UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:controller];
                navCtrl.navigationBar.barStyle = UIBarStyleBlack;
                self.window.rootViewController = navCtrl;
            
        }
    }];
    [autologinReq setFailedBlock:^{
        UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"梧桐邑"
                                                  message:@"服务器异常"
                                                 delegate:nil
                                        cancelButtonTitle:@"好的"
                                        otherButtonTitles: nil];
        [av show];
        
    }];
    [autologinReq startAsynchronous];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [MagicalRecord cleanUp];
}

@end
