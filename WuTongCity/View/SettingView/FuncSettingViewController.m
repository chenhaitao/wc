//
//  FuncSettingViewController.m
//  WuTongCity
//
//  Created by alan  on 13-8-27.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "FuncSettingViewController.h"

@interface FuncSettingViewController ()

@end

@implementation FuncSettingViewController

- (id)init
{
    self = [super init];
    if (self) {
        funcSettingDict = [[NSMutableDictionary alloc] init];
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        //功能设置-------------------------------------------------------
        NSMutableDictionary *funcDict = [[NSMutableDictionary alloc]init];
        [funcDict setObject:@"开机是否自动登录" forKey:@"title"];
        [funcDict setObject:@"0" forKey:@"content"];
        [tempArray addObject:funcDict];
        [funcSettingDict setObject:tempArray forKey:[NSString stringWithFormat:@"%d",1]];
        
        //将清空图片缓存、清空所有聊天记录放入第二个分组
        tempArray = [[NSMutableArray alloc]init];
        funcDict = [[NSMutableDictionary alloc]init];
        [funcDict setObject:@"清空图片缓存" forKey:@"title"];
        [funcDict setObject:@"1" forKey:@"content"];
        [tempArray addObject:funcDict];
        
        funcDict = [[NSMutableDictionary alloc]init];
        [funcDict setObject:@"清空所有聊天记录" forKey:@"title"];
        [funcDict setObject:@"2" forKey:@"content"];
        [tempArray addObject:funcDict];
        [funcSettingDict setObject:tempArray forKey:[NSString stringWithFormat:@"%d",2]];
        
        funcSettingSectionArray = [funcSettingDict allKeys];
        
        
    }
    return self;
}

- (void)viewDidLoad{
    //用户信息列表
    funcSettingTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 44) style:UITableViewStyleGrouped];
    funcSettingTableView.dataSource = self;
    funcSettingTableView.delegate = self;
    funcSettingTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:funcSettingTableView];
    [super viewDidLoad];
}

//返回分组数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [funcSettingSectionArray count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *key=[funcSettingSectionArray objectAtIndex:section];//返回当前分组对应neighbourDict的key值
    NSArray *sectionArray=[funcSettingDict objectForKey:key];//根据key，取得Array
    return [sectionArray count]; //返回Array的大小
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *key = [funcSettingSectionArray objectAtIndex:[indexPath section]];
    NSArray *section = [funcSettingDict objectForKey:key];
    NSDictionary *dict = [[NSDictionary alloc]initWithDictionary:[section objectAtIndex:[indexPath row]]];
    
    static NSString * tableIdentifier=@"funcSettingTableViewCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
        
        cell.tag = [[dict objectForKey:@"content"] intValue];
        if (!cell.tag > 0) {
            cell.textLabel.text = [dict objectForKey:@"title"];
            //创建开关控件
            UISwitch *isShow= [[UISwitch alloc] initWithFrame:CGRectMake(210, 10, 80, 20)];
            isShow.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"autoLogin"];
            [isShow addTarget:self action:@selector(getSwitchValue:) forControlEvents:UIControlEventValueChanged];
            
            [cell.contentView addSubview:isShow];
        }else{
            cell.textLabel.text = [dict objectForKey:@"title"];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
        }
        
        
    }
    
    return cell;
}

////cell行高
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 50.0;
//}

//分组的title
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"";
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    
    
    
    switch (cell.tag) {
        case 1:
            [self deleteAllImage];
            break;
        case 2:
            [WCMessageObject deleteMessage];
            [WCUserObject deleteUser];
            break;
        }
    
    
}

- (void) deleteAllImage{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *diskCachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"ImageCache"];
    
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    
    if ([fileMgr fileExistsAtPath:diskCachePath]){
        NSArray* tempArray = [fileMgr contentsOfDirectoryAtPath:diskCachePath error:nil];
        for (NSString* fileName in tempArray) {
            //删除文件
            [fileMgr removeItemAtPath:[diskCachePath stringByAppendingPathComponent:fileName] error:nil];           
        }
    }
    UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"邻居说" message:@"图片缓存已清除" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
    [av show];
}

-(void)getSwitchValue:(UISwitch *) _switch{
    
    NSLog(@"switch ison :%d",_switch.isOn);
    BOOL autoLogin = _switch.isOn;
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"autoLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setBool:autoLogin forKey:@"autoLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



@end
