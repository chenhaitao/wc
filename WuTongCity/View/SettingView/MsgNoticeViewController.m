//
//  MsgNoticeViewController.m
//  WuTongCity
//
//  Created by alan  on 13-8-27.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "MsgNoticeViewController.h"

@interface MsgNoticeViewController ()

@end

@implementation MsgNoticeViewController

- (id)init
{
    self = [super init];
    if (self) {
        dataCenter = [DataCenter sharedInstance];
        msgNoticeDict = [DataCenter sharedInstance].msgNoticeDict;
        msgNoticeSectionArray = [msgNoticeDict allKeys];
    }
    return self;
}

- (void)viewDidLoad{
    
    //用户信息列表
    msgNoticeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 44) style:UITableViewStyleGrouped];
    msgNoticeTableView.dataSource = self;
    msgNoticeTableView.delegate = self;
    msgNoticeTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:msgNoticeTableView];
    [super viewDidLoad];
}

//返回分组数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [msgNoticeSectionArray count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *key=[msgNoticeSectionArray objectAtIndex:section];//返回当前分组对应neighbourDict的key值
    NSArray *sectionArray=[msgNoticeDict objectForKey:key];//根据key，取得Array
    return [sectionArray count]; //返回Array的大小
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *key = [msgNoticeSectionArray objectAtIndex:[indexPath section]];
    NSArray *section = [msgNoticeDict objectForKey:key];
    NSDictionary *dict = [[NSDictionary alloc]initWithDictionary:[section objectAtIndex:[indexPath row]]];
    
    static NSString * tableIdentifier=@"msgNoticeCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
        
    }
    cell.textLabel.text = [dict objectForKey:@"title"];
    //创建开关控件
    UISwitch *isShow= [[UISwitch alloc] initWithFrame:CGRectMake(210, 10, 80, 20)];
    if ([cell.textLabel.text isEqualToString:@"有人评论通知"]) {
        isShow.tag = 2013;
    }else{
        isShow.tag = 2014;
    }
    [isShow setOn:[dict objectForKey:@"content"]];
    [isShow addTarget:self action:@selector(getSwitchValue:) forControlEvents:UIControlEventValueChanged];
    
    [cell.contentView addSubview:isShow];
    return cell;
}

//cell行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}

//分组的title
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"";
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(void)getSwitchValue:(UISwitch *) _switch{
    
    NSLog(@"switch ison :%d",_switch.isOn);
    if (_switch.tag == 2013 && _switch.isOn) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"commentKey"];
    } else if(_switch.tag == 2013 && !_switch.isOn){
         [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"commentKey"];
    }
}

@end
