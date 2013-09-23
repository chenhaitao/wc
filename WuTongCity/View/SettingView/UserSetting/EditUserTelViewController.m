//
//  EditUserTelViewController.m
//  WuTongCity
//
//  Created by alan  on 13-8-13.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "EditUserTelViewController.h"
#import "DataCenter.h"

@interface EditUserTelViewController ()

@end

@implementation EditUserTelViewController
@synthesize userVO, userTelArray;

- (id)initWithUserVO:(UserVO *)_userVO{
    self = [super init];
    if (self) {
        self.userVO = _userVO;
        
        self.userTelArray = [[NSMutableArray alloc]init];
        [self.userTelArray addObject:self.userVO.mobile];
        [self.userTelArray addObject:ISSHOW];
        
        //透明指示层
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.delegate = self;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

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
    
    editUserTelTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 420) style:UITableViewStyleGrouped];
    editUserTelTableView.dataSource = self;
    editUserTelTableView.delegate = self;
    [self.view addSubview:editUserTelTableView];
    
}

-(void)save{
    [DataCenter sharedInstance].userVO.mobile = userTelTextField.text;
    
    //修改电话姓名
    ASIFormDataRequest *editTelReq=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:[RequestLinkUtil getUrlByKey:PERSONAL_MODIFY]]];
    [editTelReq setPostValue:userTelTextField.text forKey:@"frf.UserInfo.mobile"];
    [editTelReq setDelegate:self];
    [editTelReq setDidFinishSelector:@selector(editTelSuccess:)];
    [editTelReq setDidFailSelector:@selector(requestError:)];
    [editTelReq startAsynchronous];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)goback{
    [self.navigationController popViewControllerAnimated:YES];
}

//每组显示的数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.userTelArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * tableIdentifier=@"EditUserTelCell";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
        
    }
    
    NSString *value = [self.userTelArray objectAtIndex:[indexPath row]];
    if ([value isEqualToString:ISSHOW]) {
        cell.textLabel.text = ISSHOW;
        //创建开关控件
        UISwitch *isShow= [[UISwitch alloc] initWithFrame:CGRectMake(210, 10, 80, 20)];
        BOOL show = userVO.mobilePrivacy;
        isShow.on = !show;
        [isShow addTarget:self action:@selector(getSwitchValue:) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:isShow];
        
    }else{
        
        userTelTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 280, 20.0f)];
        userTelTextField.delegate = self;
        [userTelTextField becomeFirstResponder];//默认一直打开键盘
        [userTelTextField setBorderStyle:UITextBorderStyleNone]; //外框类型
        userTelTextField.text = self.userVO.mobile; //默认显示的字
        userTelTextField.textAlignment = NSTextAlignmentLeft;
        userTelTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        userTelTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        userTelTextField.returnKeyType = UIReturnKeyDone;
        userTelTextField.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时会出现个修改X
        [cell.contentView addSubview:userTelTextField];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.0;
}

-(void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

//限制输入的文本的长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    CGFloat width =  [textField.text sizeWithFont:textField.font].width;
    return (width <= (textField.frame.size.width-50));//减去50为叉号的位置
}

//pragma mark  -------修改网络请求回调----------
-(void)editTelSuccess:(ASIFormDataRequest*)request{
    NSLog(@"blog回调结果:%@",request.responseString);
    NSRange foundObj=[request.responseString rangeOfString:@"success" options:NSCaseInsensitiveSearch];
    if(!foundObj.length > 0) {
        UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"电话" message:@"修改失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [av show];
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
    [self setUserTelPrivacy:!_switch.isOn];
    
}


//设置隐私
-(void) setUserTelPrivacy:(int)_privacy{
    NSURL *url = [NSURL URLWithString:[RequestLinkUtil getUrlByKey:PERSONALITY_MODIFY]];
    ASIFormDataRequest *cancelLimitUserReq = [ASIFormDataRequest requestWithURL:url];
    [cancelLimitUserReq setPostValue:[NSString stringWithFormat:@"%d",_privacy] forKey:@"frf.UserPersonality.mobilePrivacy"];
    [cancelLimitUserReq setPostValue:[DataCenter sharedInstance].userVO.userPersonalityId forKey:@"frf.UserPersonality.uuid"];
    [cancelLimitUserReq setCompletionBlock:^{
        NSLog(@"%@",[cancelLimitUserReq responseString]);
        [DataCenter sharedInstance].userVO.mobilePrivacy = _privacy;
        [HUD hide:YES];
    }];
    [cancelLimitUserReq setFailedBlock:^{
        UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"梧桐邑" message:@"服务器异常" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [av show];
        [HUD hide:YES];
    }];
    [cancelLimitUserReq startAsynchronous];
    [HUD show:YES];
}


@end
