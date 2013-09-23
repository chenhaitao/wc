//
//  HahaViewController.m
//  WuTongCity
//
//  Created by alan  on 13-8-11.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "EditRealNameViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface EditRealNameViewController ()

@end

@implementation EditRealNameViewController
@synthesize userVO, realNameArray;
- (id)initWithUserVO:(UserVO *)_userVO{
    self = [super init];
    if (self) {
        self.userVO = _userVO;
        
        self.realNameArray = [[NSMutableArray alloc]init];
        [self.realNameArray addObject:self.userVO.realName];
        [self.realNameArray addObject:ISSHOW];
    }
    return self;
}

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
    
    editrealNameTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 420) style:UITableViewStyleGrouped];
    editrealNameTableView.dataSource = self;
    editrealNameTableView.delegate = self;
    [self.view addSubview:editrealNameTableView];
    
}

-(void)goback{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)save{
    [DataCenter sharedInstance].userVO.realName = realNameTextField.text;
    
    //修改用户真实姓名
    ASIFormDataRequest *editRealNameReq=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:[RequestLinkUtil getUrlByKey:PERSONAL_MODIFY]]];
    [editRealNameReq setPostValue:realNameTextField.text forKey:@"frf.UserInfo.realName"];
    [editRealNameReq setDelegate:self];
    [editRealNameReq setDidFinishSelector:@selector(editRealNameSuccess:)];
    [editRealNameReq setDidFailSelector:@selector(requestError:)];
    [editRealNameReq startAsynchronous];
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

//返回分组数量
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 1;
//    
//}

//每组显示的数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.realNameArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * tableIdentifier=@"EditRealNameCell";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
        
    }
    
    NSString *value = [self.realNameArray objectAtIndex:[indexPath row]];
    if ([value isEqualToString:ISSHOW]) {
        cell.textLabel.text = ISSHOW;
     
        //创建开关控件
        UISwitch *isShow= [[UISwitch alloc] initWithFrame:CGRectMake(210, 10, 80, 20)];
        BOOL show = userVO.realNamePrivacy;
        isShow.on = !show;
        [isShow addTarget:self action:@selector(getSwitchValue:) forControlEvents:UIControlEventValueChanged];
        
        [cell.contentView addSubview:isShow];
        
    }else{
    
    realNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 280, 20.0f)];
    realNameTextField.delegate = self;
    [realNameTextField becomeFirstResponder];//默认一直打开键盘
    [realNameTextField setBorderStyle:UITextBorderStyleNone]; //外框类型
    realNameTextField.text = self.userVO.realName; //默认显示的字
    realNameTextField.textAlignment = NSTextAlignmentLeft;
    realNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    realNameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    realNameTextField.returnKeyType = UIReturnKeyDone;
    realNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时会出现个修改X
    [cell.contentView addSubview:realNameTextField];
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

-(void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{


}

-(void)getSwitchValue:(UISwitch *) _switch{
    
    //1:设置隐私  2:取消隐私
    NSLog(@"switch ison :%d",!_switch.isOn);
    //yes:1 no:0
    [self setRealNamePrivacy:!_switch.isOn];
    
}

//限制输入的文本的长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    CGFloat width =  [textField.text sizeWithFont:textField.font].width;
    return (width <= (textField.frame.size.width-50));//减去50为叉号的位置
}

//pragma mark  -------修改真实姓名网络请求回调----------
-(void)editRealNameSuccess:(ASIFormDataRequest*)request{
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

//设置隐私
-(void) setRealNamePrivacy:(int)_privacy{
    NSURL *url = [NSURL URLWithString:[RequestLinkUtil getUrlByKey:PERSONALITY_MODIFY]];
    ASIFormDataRequest *realNamePrivacyReq = [ASIFormDataRequest requestWithURL:url];
    [realNamePrivacyReq setPostValue:[NSString stringWithFormat:@"%d",_privacy] forKey:@"frf.UserPersonality.realNamePrivacy"];
    [realNamePrivacyReq setPostValue:[DataCenter sharedInstance].userVO.userPersonalityId forKey:@"frf.UserPersonality.uuid"];
    [realNamePrivacyReq setCompletionBlock:^{
        NSLog(@"%@",[realNamePrivacyReq responseString]);
        [DataCenter sharedInstance].userVO.mobilePrivacy = _privacy;
        [HUD hide:YES];
    }];
    [realNamePrivacyReq setFailedBlock:^{
        UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"梧桐邑" message:@"服务器异常" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [av show];
        [HUD hide:YES];
    }];
    [realNamePrivacyReq startAsynchronous];
    [HUD show:YES];
}




@end
