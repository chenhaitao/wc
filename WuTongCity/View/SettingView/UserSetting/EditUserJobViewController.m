//
//  EditUserJobViewController.m
//  WuTongCity
//
//  Created by alan  on 13-8-13.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "EditUserJobViewController.h"
#import "DataCenter.h"

@interface EditUserJobViewController ()

@end

@implementation EditUserJobViewController
@synthesize userVO;
- (id)initWithUserVO:(UserVO *)_userVO{
    self = [super init];
    if (self) {
        self.userVO = _userVO;
        self.jobArray = [[NSMutableArray alloc]init];
        [self.jobArray addObject:self.userVO.employer];
        [self.jobArray addObject:ISSHOW];
        // Custom initialization
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
    
    editUserJobTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 420) style:UITableViewStyleGrouped];
    editUserJobTableView.dataSource = self;
    editUserJobTableView.delegate = self;
    [self.view addSubview:editUserJobTableView];
    
}

-(void)goback{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)save{
    [DataCenter sharedInstance].userVO.employer = userJobTextField.text;
    //修改职位姓名
    ASIFormDataRequest *editJobReq=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:[RequestLinkUtil getUrlByKey:PERSONAL_MODIFY]]];
    [editJobReq setPostValue:userJobTextField.text forKey:@"frf.UserInfo.employer"];
    [editJobReq setDelegate:self];
    [editJobReq setDidFinishSelector:@selector(editJobSuccess:)];
    [editJobReq setDidFailSelector:@selector(requestError:)];
    [editJobReq startAsynchronous];

    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.jobArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * tableIdentifier=@"EditUserJobCell";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
        
    }
    NSString *value = [self.jobArray objectAtIndex:[indexPath row]];
    if ([value isEqualToString:ISSHOW]) {
        cell.textLabel.text = ISSHOW;
        
        //创建开关控件
        UISwitch *isShow= [[UISwitch alloc] initWithFrame:CGRectMake(210, 10, 80, 20)];
        BOOL show = self.userVO.employerPrivacy;
        isShow.on = !show;
        [isShow addTarget:self action:@selector(getSwitchValue:) forControlEvents:UIControlEventValueChanged];
        
        [cell.contentView addSubview:isShow];
        
    }else{
        
        userJobTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 280, 20.0f)];
        userJobTextField.delegate = self;
        [userJobTextField becomeFirstResponder];//默认一直打开键盘
        [userJobTextField setBorderStyle:UITextBorderStyleNone]; //外框类型
        userJobTextField.text = value; //默认显示的字
        userJobTextField.textAlignment = NSTextAlignmentLeft;
        userJobTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        userJobTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        userJobTextField.returnKeyType = UIReturnKeyDone;
        userJobTextField.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时会出现个修改X
        [cell.contentView addSubview:userJobTextField];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"";
    
}

//限制输入的文本的长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    CGFloat width =  [textField.text sizeWithFont:textField.font].width;
    return (width <= (textField.frame.size.width-50));//减去50为叉号的位置
}

//pragma mark  -------修改职位网络请求回调----------
-(void)editJobSuccess:(ASIFormDataRequest*)request{
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
    [self setEmployerPrivacy:!_switch.isOn];
    
}


//设置隐私
-(void) setEmployerPrivacy:(int)_privacy{
    NSURL *url = [NSURL URLWithString:[RequestLinkUtil getUrlByKey:PERSONALITY_MODIFY]];
    ASIFormDataRequest *sexPrivacyReq = [ASIFormDataRequest requestWithURL:url];
    [sexPrivacyReq setPostValue:[NSString stringWithFormat:@"%d",_privacy] forKey:@"frf.UserPersonality.employerPrivacy"];
    [sexPrivacyReq setPostValue:[DataCenter sharedInstance].userVO.userPersonalityId forKey:@"frf.UserPersonality.uuid"];
    [sexPrivacyReq setCompletionBlock:^{
        NSLog(@"%@",[sexPrivacyReq responseString]);
        [DataCenter sharedInstance].userVO.employerPrivacy = _privacy;
//        [HUD hide:YES];
    }];
    [sexPrivacyReq setFailedBlock:^{
        UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"梧桐邑" message:@"服务器异常" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [av show];
//        [HUD hide:YES];
    }];
    [sexPrivacyReq startAsynchronous];
//    [HUD show:YES];
}


@end
