//
//  EditUserAddressViewController.m
//  WuTongCity
//
//  Created by alan  on 13-8-13.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "EditUserAddressViewController.h"
#import "DataCenter.h"
#import "SelectResidenceViewController.h"

@interface EditUserAddressViewController ()

@end

@implementation EditUserAddressViewController
@synthesize userAddress;

//-(id)init{
//    if (self = [super init]) {
//        userAddressArray = [[NSMutableArray alloc] init];
//    }
//    return self;
//}


- (void)viewDidLoad
{
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
    
    
    editUserAddressTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 420) style:UITableViewStyleGrouped];
    editUserAddressTableView.dataSource = self;
    editUserAddressTableView.delegate = self;
    [self.view addSubview:editUserAddressTableView];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadEditUserAddressTableView];
    
}

-(void)goback{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)save{
    
//    if ([[DataCenter sharedInstance].residenceUUID isEqualToString:@""]) {
//        [DataCenter sharedInstance].userVO.building = @"";
//        [DataCenter sharedInstance].userVO.unit = @"";
//        UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"梧桐邑" message:@"请设置完整的个人住宅信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
//        
//        [av show];
//        
//        return;
//    }else{
        //
    
    if (![[DataCenter sharedInstance].userVO.residenceId isEqualToString:@""]) {
        ASIFormDataRequest *createAddressReq=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:[RequestLinkUtil getUrlByKey:RESIDENCE_MODIFY]]];
        [createAddressReq setPostValue:[DataCenter sharedInstance].userVO.residenceId forKey:@"residenceId"];
        [createAddressReq setPostValue:[DataCenter sharedInstance].userVO.userResidenceId forKey:@"userResidenceId"];
        [createAddressReq setPostValue:@"1" forKey:@"isPrimary"];//是否主住宅
        [createAddressReq setPostValue:@"0" forKey:@"occuType"];//是否业主
        [createAddressReq setDelegate:self];
        [createAddressReq setCompletionBlock:^{//成功
            NSString *respString = createAddressReq.responseString;
            NSDictionary *posterDict = [respString JSONValue];
            if ([@"success" isEqualToString:[posterDict objectForKey:@"resultCode"]]) {
                NSString *responseString = [createAddressReq responseString];
                NSLog(@"%@",responseString);
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                NSString *errorString = [posterDict objectForKey:@"error"];
                
                UIAlertView *av1=[[UIAlertView alloc]initWithTitle:@"梧桐邑"
                                                           message:[[DataCenter sharedInstance].errorDict objectForKey:errorString]
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles: nil];
                [av1 show];
                [HUD hide:YES];
            }
        }];
        [createAddressReq setFailedBlock:^{//失败
            UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"梧桐邑" message:@"服务器异常" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [av show];
            [HUD hide:YES];
        }];
        [createAddressReq startAsynchronous];
        [HUD show:YES];
    }
}


//每组显示的数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return userAddressArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * tableIdentifier=@"EditUserAddressCell";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    cell = nil;
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:tableIdentifier];
        NSDictionary *dict = [userAddressArray objectAtIndex:[indexPath row]];
        if (![[dict objectForKey:@"mark"] isEqualToString:@"0"]) {
            cell.textLabel.text = [dict objectForKey:@"title"];
            cell.detailTextLabel.text = [dict objectForKey:@"content"];
            cell.tag = [[dict objectForKey:@"mark"] intValue];
        }else{
            cell.textLabel.text = ISSHOW;
            //创建开关控件
            UISwitch *isShow= [[UISwitch alloc] initWithFrame:CGRectMake(210, 10, 80, 20)];
            BOOL show = [DataCenter sharedInstance].userVO.realNamePrivacy;
            isShow.on = !show;
            [isShow addTarget:self action:@selector(getSwitchValue:) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:isShow];
            cell.tag = [[dict objectForKey:@"mark"] intValue];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
   
    return cell;
}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 40.0;
//}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    //    NSString *mysection = [self.settingArray objectAtIndex:section];
    return @"";
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [editUserAddressTableView cellForRowAtIndexPath:indexPath];
    if (cell.tag > 0) {
        if (cell.tag != 1 && [DataCenter sharedInstance].userVO.building.length == 0) {
            UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"设置住宅" message:@"请先设置门栋号" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
            [av show];
            return;
        }
        else if(cell.tag != 2 &&[DataCenter sharedInstance].userVO.unit.length == 0) {
            UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"设置住宅" message:@"请先设置单元号" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
            [av show];
            return;
        }else{
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            SelectResidenceViewController *selectResidenceViewController;
            int type = 0;
            switch (cell.tag) {
                case 1:
                    type = 1;
                    break;
                case 2:
                    type = 2;
                    break;
                case 3:
                    type = 3;
                    break;
            }
            selectResidenceViewController = [[SelectResidenceViewController alloc] initWithType:type];
            [self.navigationController pushViewController:selectResidenceViewController animated:YES];
        }
    }
    
    
    
    
}

-(void)getSwitchValue:(UISwitch *) _switch{
    //1:设置隐私  2:取消隐私
    NSLog(@"switch ison :%d",!_switch.isOn);
    //yes:1 no:0
    [self setUserAddressPrivacy:!_switch.isOn];
//    [self setUserAddressPrivacy:[NSString stringWithFormat:@"%d",_switch.isOn]];
    
}

//限制输入的文本的长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    CGFloat width =  [textField.text sizeWithFont:textField.font].width;
    return (width <= (textField.frame.size.width-50));//减去50为叉号的位置
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%i",buttonIndex);
}

-(void) reloadEditUserAddressTableView{
    
    UserVO *userVO = [DataCenter sharedInstance].userVO;
    
    
    userAddressArray = [[NSMutableArray alloc]init];
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]init];
    [tempDict setValue:@"楼栋号" forKey:@"title"];
    [tempDict setValue:userVO.building forKey:@"content"];
    [tempDict setValue:@"1" forKey:@"mark"];
    [userAddressArray addObject:tempDict];
    
    tempDict = [[NSMutableDictionary alloc]init];
    [tempDict setValue:@"单元号" forKey:@"title"];
    [tempDict setValue:userVO.unit forKey:@"content"];
    [tempDict setValue:@"2" forKey:@"mark"];
    [userAddressArray addObject:tempDict];
    
    tempDict = [[NSMutableDictionary alloc]init];
    [tempDict setValue:@"房间号" forKey:@"title"];
    [tempDict setValue:userVO.room forKey:@"content"];
    [tempDict setValue:@"3" forKey:@"mark"];
    [userAddressArray addObject:tempDict];
    
    tempDict = [[NSMutableDictionary alloc]init];
    [tempDict setValue:ISSHOW forKey:@"title"];
    [tempDict setValue:[NSString stringWithFormat:@"%d",userVO.residencePrivacy] forKey:@"content"];
    [tempDict setValue:@"0" forKey:@"mark"];
    [userAddressArray addObject:tempDict];
 
    [editUserAddressTableView reloadData];
}

-(void) setUserAddressPrivacy:(int)_privacy{
    NSURL *url = [NSURL URLWithString:[RequestLinkUtil getUrlByKey:PERSONALITY_MODIFY]];
    ASIFormDataRequest *addressPrivacyReq = [ASIFormDataRequest requestWithURL:url];
    [addressPrivacyReq setPostValue:[DataCenter sharedInstance].userVO.userPersonalityId forKey:@"frf.UserPersonality.uuid"];
    [addressPrivacyReq setPostValue:[NSString stringWithFormat:@"%d",_privacy] forKey:@"frf.UserPersonality.residencePrivacy"];
    [addressPrivacyReq setCompletionBlock:^{
        NSLog(@"%@",[addressPrivacyReq responseString]);
        [HUD hide:YES];
    }];
    [addressPrivacyReq setFailedBlock:^{
        UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"梧桐邑" message:@"服务器异常" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [av show];
        [HUD hide:YES];
    }];
    [addressPrivacyReq startAsynchronous];
    [HUD show:YES];
    
    
    //    frf.UserPersonality.p
    
}

@end
