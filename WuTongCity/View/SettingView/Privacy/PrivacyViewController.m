//
//  PrivacyViewController.m
//  WuTongCity
//
//  Created by alan  on 13-8-27.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "PrivacyViewController.h"
#import "ShieldingViewController.h"
#import "LimitViewController.h"

@interface PrivacyViewController ()

@end

@implementation PrivacyViewController
- (id)init
{
    self = [super init];
    if (self) {
        dataCenter = [DataCenter sharedInstance];
        PrivacyDict = [[NSMutableDictionary alloc] init];
        PrivacySectionArray = [[NSMutableArray alloc] init];
        
        //设置消息通知----------------------------------------------
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        //头像---将头像放入第一个分组
        NSMutableArray *array = [[NSMutableArray alloc]init];
        [dict setObject:@"屏蔽用户名单" forKey:@"cellTitle"];
        [dict setObject:@"不显示该名单内用户的动态" forKey:@"sectionTitle"];
        [array addObject:dict];
        [PrivacyDict setObject:array forKey:[NSString stringWithFormat:@"%d",1]];
        
        //将昵称、个性签名放入第二个分组
        array = [[NSMutableArray alloc]init];
        dict = [[NSMutableDictionary alloc]init];
        [dict setObject:@"限制用户名单" forKey:@"cellTitle"];
        [dict setObject:@"被限制用户无法访问自己个人中心" forKey:@"sectionTitle"];
        [array addObject:dict];
        [PrivacyDict setObject:array forKey:[NSString stringWithFormat:@"%d",2]];

        PrivacySectionArray = [PrivacyDict allKeys];
    }
    return self;
}

- (void)viewDidLoad
{
    
    //用户信息列表
    PrivacyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height) style:UITableViewStyleGrouped];
    PrivacyTableView.dataSource = self;
    PrivacyTableView.delegate = self;
    PrivacyTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:PrivacyTableView];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

//返回分组数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [PrivacySectionArray count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *key=[PrivacySectionArray objectAtIndex:section];//返回当前分组对应neighbourDict的key值
    NSArray *sectionArray=[PrivacyDict objectForKey:key];//根据key，取得Array
    return [sectionArray count]; //返回Array的大小
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *key = [PrivacySectionArray objectAtIndex:[indexPath section]];
    NSArray *section = [PrivacyDict objectForKey:key];
    NSDictionary *dict = [[NSDictionary alloc]initWithDictionary:[section objectAtIndex:[indexPath row]]];
    
    static NSString * tableIdentifier=@"PrivacyTableViewCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
        
    }
    cell.textLabel.text = [dict objectForKey:@"cellTitle"];
    cell.tag = [key intValue];
    return cell;
}

//cell行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}

//分组的title
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *key = [PrivacySectionArray objectAtIndex:section];
    NSArray *s = [PrivacyDict objectForKey:key];
    NSDictionary *dict = [[NSDictionary alloc]initWithDictionary:[s objectAtIndex:0]];
    return [dict objectForKey:@"sectionTitle"];
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [PrivacyTableView cellForRowAtIndexPath:indexPath];
    switch (cell.tag) {
        case 1:{
            ShieldingViewController *shieldingViewController = [[ShieldingViewController alloc] init];
            [self.navigationController pushViewController:shieldingViewController animated:YES];
            shieldingViewController.title = @"屏蔽名单";
            break;
        }
        case 2:{
            LimitViewController *limitViewController = [[LimitViewController alloc] init];
            [self.navigationController pushViewController:limitViewController animated:YES];
            limitViewController.title = @"限制名单";
            break;
        }
    }
    
}

-(void)getSwitchValue:(UISwitch *) _switch{
    
    NSLog(@"switch ison :%d",_switch.isOn);
    
}
@end
