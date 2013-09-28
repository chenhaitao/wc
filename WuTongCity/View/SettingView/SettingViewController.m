//
//  SettingViewController.m
//  WuTongCity
//
//  Created by alan  on 13-8-11.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "SettingViewController.h"
#import "UserSettingViewController.h"
#import "MsgNoticeViewController.h"
#import "FuncSettingViewController.h"
#import "PrivacyViewController.h"
#import "AccountMgrViewController.h"
#import "LoginViewController.h"
#import "SelectVillagelViewController.h"
#import "AppDelegate.h"

@interface SettingViewController ()

@end

@implementation SettingViewController
@synthesize sectionDict,settingArray;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    aboutWTYViewController = [[AboutWTYViewController alloc] init];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    UIButton *shieldingUserBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 300, 40)];
    [shieldingUserBtn setBackgroundImage:[UIImage imageNamed:@"redBtn"] forState:UIControlStateNormal];
    [shieldingUserBtn setTitle:@"退 出 登 录" forState:UIControlStateNormal];
    [shieldingUserBtn.titleLabel setFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:20]];
    [shieldingUserBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//
    [shieldingUserBtn addTarget:self action:@selector(logOut) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:shieldingUserBtn];
    
   
    settingTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 480) style:UITableViewStyleGrouped];
    settingTableView.dataSource = self;
    settingTableView.delegate = self;
    [settingTableView setTableFooterView:footView];
    [self.view addSubview:settingTableView];
    
        
    //取得sortednames.plist绝对路径
    //sortednames.plist本身是一个NSDictionary,以键-值的形式存储字符串数组
    NSString *path=[[NSBundle mainBundle] pathForResource:@"SysSetting" ofType:@"plist"];
    //转换成NSDictionary对象
    self.sectionDict=[[NSDictionary alloc] initWithContentsOfFile:path];

    
    self.settingArray=[[sectionDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.sectionDict=nil;
    self.self.settingArray=nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //返回分组数量,即Array的数量
    return [self.settingArray count];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //返回第section个分组的行数
    NSString *key=[self.settingArray objectAtIndex:section];
    //取得key
    NSArray *sectionName=[sectionDict objectForKey:key];
    //根据key，取得Array
    return [sectionName count];
    //返回Array的大小
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * tableIdentifier=@"SettingCell";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
        
    }
    NSString *key = [self.settingArray objectAtIndex:[indexPath section]];
    NSArray *section = [self.sectionDict objectForKey:key];
    NSDictionary *dict = [[NSDictionary alloc]initWithDictionary:[section objectAtIndex:[indexPath row]]];

    cell.textLabel.text=[dict objectForKey:@"title"];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.tag = [[dict objectForKey:@"tag"] intValue];
        
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    NSString *mysection = [self.settingArray objectAtIndex:section];
    return @"";

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    int index = cell.tag;
    switch (index) {
        case 1:{
            UserSettingViewController *uSettingViewController = [[UserSettingViewController alloc]init];
            uSettingViewController.navigationItem.title = @"个人信息";
            uSettingViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:uSettingViewController animated:YES];
            break;
        }
        case 2:{//消息通知
            MsgNoticeViewController *msgNoticeViewController = [[MsgNoticeViewController alloc] init];
            msgNoticeViewController.title = @"消息通知";
            msgNoticeViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:msgNoticeViewController animated:YES];
            break;
        }
        case 3:{//功能设置
            FuncSettingViewController *funcSettingViewController= [[FuncSettingViewController alloc]init];
            funcSettingViewController.title = @"功能设置";
            funcSettingViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:funcSettingViewController animated:YES];
            break;
        }
        case 4:{//安全隐私
            PrivacyViewController *privacyViewController= [[PrivacyViewController alloc]init];
            privacyViewController.title = @"安全隐私";
            privacyViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:privacyViewController animated:YES];
            break;
        }
        case 5:{//账号管理
            AccountMgrViewController *accountMgrViewController = [[AccountMgrViewController alloc]init];
            accountMgrViewController.title = @"账号管理";
            [self.navigationController pushViewController:accountMgrViewController animated:YES];
            
            break;
        }
        case 6://关于梧桐邑
            [self.navigationController pushViewController:aboutWTYViewController animated:YES];
//            self.editUserAddressViewController= [[EditUserAddressViewController alloc]initWithUserAdress:[DataCenter sharedInstance].user.address];
//            [self.navigationController pushViewController:self.editUserAddressViewController animated:YES];
//            self.editUserAddressViewController.title = @"地址";
            break;
       
    }
}

-(void) logOut{
    SelectVillagelViewController *selectVillagelViewController = [[SelectVillagelViewController alloc] init];
    UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:selectVillagelViewController];
    navCtrl.navigationBar.barStyle = UIBarStyleBlack;
    
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.window.rootViewController = navCtrl; 
    //通知服务端清session
    NSString *url = [NSString stringWithFormat:@"http://v2.wutongyi.com/logoff.do"];
    ASIFormDataRequest *req = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [req setCompletionBlock:^{
        NSLog(@"success");
    }];
    
    [req  setFailedBlock:^{
        NSLog(@"error");

    }];
    [req startAsynchronous];
    [self.view removeFromSuperview];
}




@end
