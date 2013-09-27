//
//  HahaViewController.m
//  WuTongCity
//
//  Created by alan  on 13-8-11.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "EditNickNameViewController.h"
#import <QuartzCore/QuartzCore.h>
//#import "UITextField.h"
#import "RegexKitLite.h"
#define  maxWordsConst 10

@interface EditNickNameViewController ()

@end

@implementation EditNickNameViewController
@synthesize nickName;
- (id)initWithNickName:(NSString *)_nickName{
    self = [super init];
    if (self) {
        self.nickName = _nickName;

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
    
    editNickNameTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 420) style:UITableViewStyleGrouped];
    editNickNameTableView.dataSource = self;
    editNickNameTableView.delegate = self;
    [self.view addSubview:editNickNameTableView];

}

-(void)goback{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)save{
    [DataCenter sharedInstance].userVO.nickName = nickNameTextField.text;
    
    
    //修改用户昵称
    ASIFormDataRequest *nickNameReq=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:[RequestLinkUtil getUrlByKey:PERSONALITY_MODIFY]]];
    [nickNameReq setPostValue:[DataCenter sharedInstance].userVO.userPersonalityId forKey:@"frf.UserPersonality.uuid"];
    [nickNameReq setPostValue:nickNameTextField.text forKey:@"frf.UserPersonality.nickName"];
    [nickNameReq setDelegate:self];
    [nickNameReq setDidFinishSelector:@selector(editNickNameSuccess:)];
    [nickNameReq setDidFailSelector:@selector(requestError:)];
    [nickNameReq startAsynchronous];
    
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
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * tableIdentifier=@"EditNickNameCell";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
        
    }
    
    nickNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 280, 20.0f)];
    nickNameTextField.delegate = self;
    [nickNameTextField becomeFirstResponder];//默认一直打开键盘
    [nickNameTextField setBorderStyle:UITextBorderStyleNone]; //外框类型
    nickNameTextField.text = self.nickName; //默认显示的字
    nickNameTextField.textAlignment = NSTextAlignmentLeft;
    nickNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    nickNameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    nickNameTextField.returnKeyType = UIReturnKeyDone;
    nickNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时会出现个修改X
    [cell.contentView addSubview:nickNameTextField];
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
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    if ([string isEqualToString:@"\n"])
    {
        return YES;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (nickNameTextField == textField)
    {
        if ([toBeString length] > 10) {
            textField.text = [toBeString substringToIndex:10];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"超过最大字数不能输入了" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            return NO;
        }
    }
    return YES;
}


//pragma mark  -------修改头像网络请求回调----------
-(void)editNickNameSuccess:(ASIFormDataRequest*)request{
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

-(void) editNickName{
    
}

    
    
    


@end
