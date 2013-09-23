//
//  TableBarViewController.m
//  WuTongCity
//
//  Created by alan  on 13-8-15.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "TableBarViewController.h"
#import "SettingViewController.h"
#import "WeiBoViewController.h"
#import "NeighbourViewController.h"
#import "ChatMessageController.h"

@interface TableBarViewController ()

@end

@implementation TableBarViewController

- (void)viewDidLoad{    
    //微博页面
    WeiBoViewController * weiboView = [[WeiBoViewController alloc]init];
    weiboView.title = @"邻居说";
    UINavigationController *weiboNav=[[UINavigationController alloc]initWithRootViewController:weiboView];
    weiboNav.navigationBar.barStyle = UIBarStyleBlack;
//    [weiboNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBG.png"] forBarMetrics:UIBarMetricsDefault];

    //邻居页面
    NeighbourViewController * neighbourView = [[NeighbourViewController alloc]init];
    neighbourView.title = @"邻居";
    UINavigationController *neighbourNav=[[UINavigationController alloc]initWithRootViewController:neighbourView];
    neighbourNav.navigationBar.barStyle = UIBarStyleBlack;
//    [neighbourNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBG.png"] forBarMetrics:UIBarMetricsDefault];
//
    //邻居页面
    ChatMessageController * chatView = [[ChatMessageController alloc]init];
    chatView.title = @"聊天";
    UINavigationController *chatNav=[[UINavigationController alloc]initWithRootViewController:chatView];
    chatNav.navigationBar.barStyle = UIBarStyleBlack;
//    [chatNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBG.png"] forBarMetrics:UIBarMetricsDefault];
    
    //设置页面
    SettingViewController * settingView = [[SettingViewController alloc]init];
    settingView.title = @"设置";
    UINavigationController *settingNav=[[UINavigationController alloc]initWithRootViewController:settingView];
    settingNav.navigationBar.barStyle = UIBarStyleBlack;
//    [settingNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBG.png"] forBarMetrics:UIBarMetricsDefault];
    
    //将页面加入一个数组
    NSArray *controllerArray =[[NSArray alloc] initWithObjects:weiboNav,neighbourNav, chatNav,settingNav, nil];
    
    //初始化tabbarController--------------------------
    //[tabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"db_navbar_bg.png"]];
    //设置UITabBarController控制器的viewControllers属性为之前生成的数组controllerArray
    self.viewControllers = controllerArray;
    //默认选择第一个视图选项卡（索引从0开始）
    
    //设置TabBarItem的标题与图片
//    [(UITabBarItem *)[self.tabBar.items objectAtIndex:0] setTitle:@"第一页"];
    [(UITabBarItem *)[self.tabBar.items objectAtIndex:0] setImage:[UIImage imageNamed:@"tabbar_discover.png"]];
//    [(UITabBarItem *)[self.tabBar.items objectAtIndex:1] setTitle:@"第二页"];
    [(UITabBarItem *)[self.tabBar.items objectAtIndex:1] setImage:[UIImage imageNamed:@"tabbar_contacts.png"]];
    [(UITabBarItem *)[self.tabBar.items objectAtIndex:2] setImage:[UIImage imageNamed:@"tabbar_chat.png"]];
//    [(UITabBarItem *)[self.tabBar.items objectAtIndex:2] setTitle:@"第三页"];
    [(UITabBarItem *)[self.tabBar.items objectAtIndex:3] setImage:[UIImage imageNamed:@"tabbar_me.png"]];
    
    tabBarController.selectedIndex=0;

    //接受新消息广播,并刷新tableview
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(newMsgCome:) name:MESSAGE_NOTIFACTION object:nil];
    [super viewDidLoad];
}

#pragma mark  接受新消息广播
-(void)newMsgCome:(NSNotification *)notifacation{
    chatMsgCount++;
//    UIViewController *tController = [self.tabBarController.viewControllers objectAtIndex:0];
//    int badgeValue = 2;
//    tController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",badgeValue+1];
    [[self.tabBar.items objectAtIndex:2] setBadgeValue:[NSString stringWithFormat:@"%d",chatMsgCount]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
