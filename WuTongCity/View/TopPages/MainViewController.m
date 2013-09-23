//
//  HelpViewController.m
//  WuTongCity
//
//  Created by alan  on 13-7-29.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad{
    
    screenSize = [[UIScreen mainScreen] bounds];
    
//    [self.navigationController setNavigationBarHidden:YES];
    
    //背景图
    UIImage *pic = [UIImage imageNamed:@"topBG.png"];
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:pic];
    backgroundImage.frame = CGRectMake(0, 0, screenSize.size.width, screenSize.size.height);
    [self.view addSubview:backgroundImage];
    
    //去登录页面
    UIButton *loginFuc = [[UIButton alloc]initWithFrame:CGRectMake(25,300,120,40)];
    [loginFuc setBackgroundImage:[UIImage imageNamed:@"loginFuc.png"] forState:UIControlStateNormal];
    [loginFuc addTarget:self action:@selector(toLoginPage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginFuc];
    
    //去注册页面
    UIButton *registerFuc = [[UIButton alloc]initWithFrame:CGRectMake(175,300,120,40)];
    [registerFuc setBackgroundImage:[UIImage imageNamed:@"registerFuc.png"] forState:UIControlStateNormal];
    [registerFuc addTarget:self action:@selector(toRegisterPage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerFuc];
    
    //快速浏览
    UIButton *startFuc = [[UIButton alloc]initWithFrame:CGRectMake(25,370,270,40)];
    [startFuc setBackgroundImage:[UIImage imageNamed:@"startFuc.png"] forState:UIControlStateNormal];
    [startFuc addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchDown];
    //    [loginSubmitButton addTarget:self action:@selector(userLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startFuc];
    

    [super viewDidLoad];
}


-(void) toLoginPage{
    // 获取故事板
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    // 获取故事板中某个View
    UIViewController *next = [board instantiateViewControllerWithIdentifier:@"Login"];
    [self presentViewController:next animated:YES completion:nil];
}

-(void) toRegisterPage{
    // 获取故事板
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    // 获取故事板中某个View
    UIViewController *next = [board instantiateViewControllerWithIdentifier:@"Register"];
//    [self presentViewController:next animated:YES completion:nil];
    [self.navigationController pushViewController:next animated:YES];
}

//快速浏览
-(void)start{
//    // 获取故事板
//    UIStoryboard *board = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
//    // 获取故事板中某个View
//    UIViewController *next = [board instantiateViewControllerWithIdentifier:@"TopView"];
////    [self presentViewController:next animated:NO completion:nil];
//    UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:next];
//    [self.navigationController presentViewController:navCtrl animated:NO completion:nil];
    
    TableBarViewController *tabbar = [[TableBarViewController alloc]init];
    [self presentViewController:tabbar animated:NO completion:nil];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
