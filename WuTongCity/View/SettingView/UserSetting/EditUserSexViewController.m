//
//  EditUserSexViewController.m
//  WuTongCity
//
//  Created by alan  on 13-8-13.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "EditUserSexViewController.h"
#import "DataCenter.h"

@interface EditUserSexViewController ()

@end

@implementation EditUserSexViewController
@synthesize userVO, sexArray;
- (id)initWithUserVO:(UserVO *)_userVO{
    self = [super init];
    if (self) {
        self.userVO = _userVO;
        
        self.sexArray = [[NSMutableArray alloc]init];
        [self.sexArray addObject:MALE_VALUE];
        [self.sexArray addObject:FEMALE_VALUE];
        [self.sexArray addObject:ISSHOW];

    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //透明指示层
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.delegate = self;

    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(goback)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(save)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    editUserSexTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 420) style:UITableViewStyleGrouped];
    editUserSexTableView.dataSource = self;
    editUserSexTableView.delegate = self;
    [self.view addSubview:editUserSexTableView];
    
}

-(void)goback{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)save{
    [DataCenter sharedInstance].userVO.sex = sex;
    ASIFormDataRequest *editSexReq=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:[RequestLinkUtil getUrlByKey:PERSONAL_MODIFY]]];
    [editSexReq setPostValue:[NSString stringWithFormat:@"%d",sex] forKey:@"frf.UserInfo.sex"];
    [editSexReq setDelegate:self];
    [editSexReq setDidFinishSelector:@selector(editSexSuccess:)];
    [editSexReq setDidFailSelector:@selector(requestError:)];
    [editSexReq startAsynchronous];

    
    [self.navigationController popViewControllerAnimated:YES];
}


//每组显示的数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sexArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * tableIdentifier=@"EditUserSexCell";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
        
    }
    NSString *key = [self.sexArray objectAtIndex:[indexPath row]];
    if ([key isEqualToString:ISSHOW]) {
        cell.textLabel.text = ISSHOW;
        
        //创建开关控件
        UISwitch *isShow= [[UISwitch alloc] initWithFrame:CGRectMake(210, 10, 80, 20)];
        BOOL show = userVO.sexPrivacy;
        isShow.on = !show;
        [isShow addTarget:self action:@selector(getSwitchValue:) forControlEvents:UIControlEventValueChanged];
        cell.tag = 10;
        [cell.contentView addSubview:isShow];
        
    }else{
        if ([key isEqualToString:MALE_VALUE]) {
            cell.textLabel.text = MALE;//男
        }else{
            cell.textLabel.text = FEMALE;//女
        }
        
        //判断当前是否已经选择过性别
        if (self.userVO.sex == [key intValue] ) {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
        cell.tag = [key intValue];//将key值放入tag里，方便之后检索
    }
    
   
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    //    NSString *mysection = [self.settingArray objectAtIndex:section];
    return @"";
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = [tableView visibleCells];
    for (UITableViewCell *cell in array) {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        cell.textLabel.textColor=[UIColor blackColor];
        
    }
    UITableViewCell *cell=[editUserSexTableView cellForRowAtIndexPath:indexPath];
    if (cell.tag < 10) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        sex = cell.tag;
//        self.userVO.sex = cell.tag;
    }
    
    
    
    
}


//pragma mark  -------修改性别网络请求回调----------
-(void)editSexSuccess:(ASIFormDataRequest*)request{
    NSLog(@"blog回调结果:%@",request.responseString);
    if (request.responseString) {
        NSRange foundObj=[request.responseString rangeOfString:@"success" options:NSCaseInsensitiveSearch];
        if(foundObj.length>0) {
            
        }else{
            //shibai
        }
        
    }
}

#pragma mark  -------请求错误--------
- (void)requestError:(ASIFormDataRequest*)request{
    UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"梧桐邑" message:@"服务器异常" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
    [av show];
}

-(void)getSwitchValue:(UISwitch *) _switch{
    
    //1:设置隐私  2:取消隐私
    NSLog(@"switch ison :%d",!_switch.isOn);
    //yes:1 no:0
        [self setSexPrivacy:!_switch.isOn];
    
}


//设置隐私
-(void) setSexPrivacy:(int)_privacy{
    NSURL *url = [NSURL URLWithString:[RequestLinkUtil getUrlByKey:PERSONALITY_MODIFY]];
    ASIFormDataRequest *sexPrivacyReq = [ASIFormDataRequest requestWithURL:url];
    [sexPrivacyReq setPostValue:[NSString stringWithFormat:@"%d",_privacy] forKey:@"frf.UserPersonality.sexPrivacy"];
    [sexPrivacyReq setPostValue:[DataCenter sharedInstance].userVO.userPersonalityId forKey:@"frf.UserPersonality.uuid"];
    [sexPrivacyReq setCompletionBlock:^{
        NSLog(@"%@",[sexPrivacyReq responseString]);
        [DataCenter sharedInstance].userVO.sexPrivacy = _privacy;
        [HUD hide:YES];
    }];
    [sexPrivacyReq setFailedBlock:^{
        UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"梧桐邑" message:@"服务器异常" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [av show];
        [HUD hide:YES];
    }];
    [sexPrivacyReq startAsynchronous];
    [HUD show:YES];
}



@end
