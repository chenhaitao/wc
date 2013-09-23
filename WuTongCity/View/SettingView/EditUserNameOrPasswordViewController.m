//
//  EditUserNameOrPasswordViewController.m
//  WuTongCity
//
//  Created by 陈 海涛 on 13-9-23.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "EditUserNameOrPasswordViewController.h"

@interface EditUserNameOrPasswordViewController () <UITextFieldDelegate>

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
    self.password.text = self.user.password;
    self.password.secureTextEntry = YES ;
    self.userName.textColor = [UIColor blackColor];
    self.password.textColor = [UIColor blackColor];
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
     [self.view addSubview:HUD];
    
    
    self.userName.delegate = self;
    self.password.delegate = self;
    
    self.title = @"用户名密码修改";
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
            return;
        }else{
            NSString *url = [SERVER_DEFAULT_ADDRESS stringByAppendingString:@"/m/user/userModify.do"];
            url =[url stringByAppendingFormat:@"?loginId=%@&loginPassword=%@",self.userName.text,self.password.text ];
            ASIFormDataRequest *updateReq=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
//            [updateReq setPostValue:self.userName.text forKey:@"loginId"];
//            [updateReq setPostValue:self.password.text forKey:@"loginPassword"];
            __block ASIFormDataRequest *request = updateReq;
            [updateReq setCompletionBlock:^{
//            NSString *json =   request.responseString;
//                NSLog(@"%@",request.responseStatusMessage);
//                 NSLog(@"%@",request.responseString);
//                 NSLog(@"%@",request.responseHeaders);
//                NSLog(@"%@",request.responseData);
//                  NSLog(@"%@",request.requestHeaders);
               
                [HUD hide:YES];
            }];
            
            [updateReq setFailedBlock:^{
                [HUD hide:YES];
            }];
            
            [updateReq startAsynchronous];
            //弹出透明指示层
            [HUD show:YES];
        }
    }
    
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
