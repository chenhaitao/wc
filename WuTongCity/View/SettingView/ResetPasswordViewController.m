//
//  ResetPasswordViewController.m
//  WuTongCity
//
//  Created by chen  on 13-9-23.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "DataCenter.h"

@interface ResetPasswordViewController ()

@end

@implementation ResetPasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id) initWithUser:(WZUser *)user{
    self.user = user;
    if(self = [super init]){
        dataCenter = [DataCenter sharedInstance];
    }
    
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.userName = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 80, 30)];
    [self.userName setText:@"用户名"];
    [self.userName setFont:[UIFont systemFontOfSize:14]];
    [self.userName setTextColor:[UIColor blackColor]];
    [self.userName setBackgroundColor:[UIColor clearColor]];
    self.userName.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:self.userName];
    
    self.oldPass = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 80, 30)];
    [self.oldPass setText:@"旧密码"];
    [self.oldPass setFont:[UIFont systemFontOfSize:14]];
    [self.oldPass setTextColor:[UIColor blackColor]];
    [self.oldPass setBackgroundColor:[UIColor clearColor]];
    self.oldPass.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:self.oldPass];

    self.newPass = [[UILabel alloc]initWithFrame:CGRectMake(10, 100, 80, 30)];
    [self.newPass setText:@"新密码"];
    [self.newPass setFont:[UIFont systemFontOfSize:14]];
    [self.newPass setTextColor:[UIColor blackColor]];
    [self.newPass setBackgroundColor:[UIColor clearColor]];
    self.newPass.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:self.newPass];

    self.userNameField = [[UITextField alloc]initWithFrame:CGRectMake(10, 10, 110, 30)];
   
    [self.userNameField setFont:[UIFont systemFontOfSize:14]];
    [self.userNameField setTextColor:[UIColor blackColor]];
    [self.userNameField setBackgroundColor:[UIColor clearColor]];
    self.userNameField.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:self.userNameField];
    
    self.oldPassword = [[UITextField alloc]initWithFrame:CGRectMake(10, 50, 110, 30)];
  
    [self.oldPassword setFont:[UIFont systemFontOfSize:14]];
    [self.oldPassword setTextColor:[UIColor blackColor]];
    [self.oldPassword setBackgroundColor:[UIColor clearColor]];
    self.oldPassword.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:self.oldPassword];
    
    self.newPassword = [[UITextField alloc]initWithFrame:CGRectMake(10, 100, 110, 30)];
    [self.newPassword setFont:[UIFont systemFontOfSize:14]];
    [self.newPassword setTextColor:[UIColor blackColor]];
    [self.newPassword setBackgroundColor:[UIColor clearColor]];
    self.newPassword.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:self.newPassword];
    
    
    
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
