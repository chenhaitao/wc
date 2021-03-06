//
//  EditUserNameOrPasswordViewController.m
//  WuTongCity
//
//  Created by 陈 海涛 on 13-9-23.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "EditUserNameOrPasswordViewController.h"
#import "MD5.h"

@interface EditUserNameOrPasswordViewController ()

@end

@implementation EditUserNameOrPasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.userName.text = self.user.loginId;
    //self.password.text = self.user.password;
    self.password.secureTextEntry = YES ;
    self.userName.textColor = [UIColor blackColor];
    self.password.textColor = [UIColor blackColor];
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
     [self.view addSubview:HUD];
    //添加点击手势--点击撤销键盘
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyboard)];
    gestureRecognizer.cancelsTouchesInView = YES;
    [self.view addGestureRecognizer:gestureRecognizer];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(commit:)];
    self.navigationItem.rightBarButtonItem = rightButton;

    self.userName.delegate = self;
    self.password.delegate = self;
    
    self.title = @"用户名密码修改";
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)reset:(id)sender {
    self.userName.text = self.user.loginId;
    self.password.text = self.user.password;
}

- (IBAction)commit:(id)sender {
    if ([self check]) {
        [self.userName resignFirstResponder];
        [self.password resignFirstResponder];
        if ([self.userName.text isEqualToString:self.user.loginId] && [self.password.text isEqualToString:self.user.password] ) {
            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"您的密码与原密码相同！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            return;
        }else{
            NSString *url = [SERVER_DEFAULT_ADDRESS stringByAppendingString:@"/m/user/userModify.do"];
            url =[url stringByAppendingFormat:@"?loginId=%@&loginPassword=%@",self.userName.text,[MD5 md5:self.password.text]];
            ASIHTTPRequest *updateReq=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
            [updateReq setRequestMethod:@"GET"];
//            [updateReq setPostValue:self.userName.text forKey:@"loginId"];
//            [updateReq setPostValue:self.password.text forKey:@"loginPassword"];
           
            ASIHTTPRequest *req = (ASIHTTPRequest *)updateReq;
            
            [updateReq setCompletionBlock:^{
               NSString *flag = req.responseString;
                if (![flag isEqualToString:@"failure"]) {
                    self.user.password = [MD5 md5:self.password.text];
                    self.user.loginId =  self.userName.text;
                    [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfAndWait];
                    
                    
                    [[[UIAlertView alloc] initWithTitle:@"提示" message:@"修改成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                    [HUD hide:YES];
                }else{
                    [[[UIAlertView alloc] initWithTitle:@"提示" message:@"修改失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                    [HUD hide:YES];
                }
                
                
            }];
            
            [updateReq setFailedBlock:^{
                [[[UIAlertView alloc] initWithTitle:@"提示" message:@"修改失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                [HUD hide:YES];
            }];
            
            [updateReq startAsynchronous];
            //弹出透明指示层
            [HUD show:YES];
        }
    }
    
}

//注销键盘
-(void)resignKeyboard{
    [self.userName resignFirstResponder];
    [self.password resignFirstResponder];
    //[self keyboardMove:1];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)check
{
        NSString * regex   = @"(^[A-Za-z0-9]{6,15}$)";
        NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        BOOL isMatch = [pred evaluateWithObject:self.password.text ];
        
        if (!isMatch) {
            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请使用6～15位数字或字母作为密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            return NO;
        }
    
    if (self.userName.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return NO;
    }
    
    return YES;
}

@end
