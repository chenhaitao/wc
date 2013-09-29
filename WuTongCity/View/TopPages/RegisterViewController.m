//
//  RegisterViewController.m
//  WutongCity
//
//  Created by alan  on 13-7-8.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "RegisterViewController.h"
#import "DataCenter.h"
#import "MD5.h"
#import "TableBarViewController.h"
#import "Village.h"
#import "UIImageView+WebCache.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (id)init{
    self = [super init];
    if (self) {
        self.navigationItem.title = @"注册";
        isChecked = NO;//单选按钮
        isCheckCode = NO;//验证码
        //初始化关于
        aboutWTYViewController = [[AboutWTYViewController alloc] init];
    }
    return self;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"注册"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(registert)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    
    [self.view setBackgroundColor:[UIColor colorWithRed:230.0 green:230.0 blue:230.0 alpha:1.0]];
    
    //添加点击手势--点击撤销键盘
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyboard)];
    gestureRecognizer.cancelsTouchesInView = YES;
    [self.view addGestureRecognizer:gestureRecognizer];
    
    //账号、昵称view------------------------------------------
    UIView *accountAndNickNameView = [[UIView alloc]initWithFrame:CGRectMake(10, 20, 295, 84)];
    UIColor *accountAndNickNameColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"accountAndNickName.png"]];
    [accountAndNickNameView setBackgroundColor:accountAndNickNameColor];
    [self.view addSubview:accountAndNickNameView];
                       
    //登录账号输入框
    userNameText = [[UITextField alloc]initWithFrame:CGRectMake(50, 15, 240, 20)];
    userNameText.delegate = self;//关闭键盘
//    [userNameText addTarget:self action:@selector(verifyUserName:) forControlEvents:UIControlEventEditingDidEnd];//限制输入的文本的长度
    userNameText.textColor = [UIColor blackColor];
    userNameText.placeholder = INPUT_YOUR_ACCOUNT;
    userNameText.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时会出现个修改X
    userNameText.autocorrectionType = UITextAutocorrectionTypeNo;//关闭联想功能
    userNameText.tag = 1;
    userNameText.keyboardType = UIKeyboardTypeAlphabet;
    userNameText.autocapitalizationType = UITextAutocapitalizationTypeNone;//不自动大写
    [accountAndNickNameView addSubview:userNameText];
    
    //昵称输入框
    nickNameText = [[UITextField alloc]initWithFrame:CGRectMake(20, 50, 270, 25)];
    nickNameText.delegate = self;//关闭键盘
    nickNameText.textColor = [UIColor blackColor];
    nickNameText.placeholder = INPUT_YOUR_NICKNAME;
    nickNameText.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时会出现个修改X
    nickNameText.autocorrectionType = UITextAutocorrectionTypeNo;//关闭联想功能
    nickNameText.tag = 2;
    [accountAndNickNameView addSubview:nickNameText];
    
    //密码、确认密码view------------------------------------------
    UIView *acountPwdView = [[UIView alloc]initWithFrame:CGRectMake(10, 120, 295, 84)];
    UIColor *acountPwdColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"acountPwd.png"]];
    [acountPwdView setBackgroundColor:acountPwdColor];
    [self.view addSubview:acountPwdView];
    
    //登录账号输入框
    userPassWordText = [[UITextField alloc]initWithFrame:CGRectMake(20, 10, 270, 25)];
    userPassWordText.delegate = self;//关闭键盘
    userPassWordText.textColor = [UIColor blackColor];
    userPassWordText.placeholder = INPUT_YOUR_PWD;
    userPassWordText.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时会出现个修改X
    userPassWordText.secureTextEntry = YES;//设置密码显示格式
    userPassWordText.autocorrectionType = UITextAutocorrectionTypeNo;//关闭联想功能
    userPassWordText.tag = 3;
    [acountPwdView addSubview:userPassWordText];
    
 
    //确认密码输入框
    aUserPassWordText = [[UITextField alloc]initWithFrame:CGRectMake(20, 50, 260, 25)];
    aUserPassWordText.delegate = self;//关闭键盘
    aUserPassWordText.textColor = [UIColor blackColor];
    aUserPassWordText.placeholder = INPUT_YOUR_APWD;
    aUserPassWordText.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时会出现个修改X
    aUserPassWordText.secureTextEntry = YES;//设置密码显示格式
    aUserPassWordText.autocorrectionType = UITextAutocorrectionTypeNo;//关闭联想功能
    aUserPassWordText.tag = 4;
    [acountPwdView addSubview:aUserPassWordText];
    
    
    //校验码view------------------
    UIView *accountCodeView = [[UIView alloc]initWithFrame:CGRectMake(10, 220, 144, 41)];
    UIColor *accountCodeColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"accountCode"]];
    [accountCodeView setBackgroundColor:accountCodeColor];
    [self.view addSubview:accountCodeView];
    
    //验证码输入框
    checkingCodeText = [[UITextField alloc]initWithFrame:CGRectMake(10, 10, 130, 25)];
    checkingCodeText.delegate = self;//关闭键盘
    checkingCodeText.textColor = [UIColor blackColor];
    checkingCodeText.placeholder = INPUT_YOUR_CHECKINGCODE;
    checkingCodeText.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时会出现个修改X
    checkingCodeText.autocorrectionType = UITextAutocorrectionTypeNo;//关闭联想功能
    checkingCodeText.tag = 5;
    [accountCodeView addSubview:checkingCodeText];
    
    
    srand((unsigned)time(0));  //不加这句每次产生的随机数不变
    int i = rand() % 1000000;
    
    //验证码
    ccImageView = [[UIImageView alloc]initWithFrame:CGRectMake(180, 0, 100, 40)];
    NSString *checkString= [RequestLinkUtil getUrlByKey:CHECK_CODE_URL];
    
    
    NSURL *checkUrl=[NSURL URLWithString:[checkString stringByAppendingFormat:@"?temp=%d",i]];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(180, 0, 100, 40)];
    [imageView setImageWithURL:checkUrl
                       success:^(UIImage *image){
                           ccImageView.image = image;
                       }
                       failure:^(NSError *error){}];
    [accountCodeView addSubview:ccImageView];
    
    //注册提交按钮
    UIButton *registerBtn = [[UIButton alloc]initWithFrame:CGRectMake(10,280,300,40)];
    [registerBtn setBackgroundImage:[UIImage imageNamed:@"register.png"] forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(toRegistert) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    
    QCheckBox *_check3 = [[QCheckBox alloc] initWithDelegate:self];
    _check3.frame = CGRectMake(10, 330, 150, 20);
    [_check3 setTitle:@"已阅读并同意" forState:UIControlStateNormal];
    [_check3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_check3.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
    [_check3 setImage:[UIImage imageNamed:@"uncheck_icon.png"] forState:UIControlStateNormal];
    [_check3 setImage:[UIImage imageNamed:@"check_icon.png"] forState:UIControlStateSelected];
    [self.view addSubview:_check3];
    [_check3 setChecked:NO];
    
    UIButton *agreementBtn = [[UIButton alloc]initWithFrame:CGRectMake(10,360,130,20)];
    [agreementBtn setTitle:@"梧桐邑网络使用协议" forState:UIControlStateNormal];
    [agreementBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];//默认蓝色字
    [agreementBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];//字体大小
    [agreementBtn.titleLabel setTextAlignment:NSTextAlignmentLeft];//居左
    [agreementBtn addTarget:self action:@selector(toAgreementPage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:agreementBtn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)ruleVerify:(NSString *)_dataSource rule:(NSString *)_rule{
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:_rule options:0 error:&error];
    if (regex != nil) {
        NSTextCheckingResult *firstMatch=[regex firstMatchInString:_dataSource options:0 range:NSMakeRange(0, [_dataSource length])];
        if (!firstMatch) {//不在范围里
            return NO;
        }else{
            return YES;
        }
    }
    return nil;
}


#pragma mark - QCheckBoxDelegate
- (void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked {
    NSLog(@"did tap on CheckBox:%@ checked:%d", checkbox.titleLabel.text, checked);
    isChecked = checked;
}

//注册
-(BOOL)toRegistert{
    int textLength = 0;
    //账号验证
    if (userNameText.text.length > 0) {
        textLength = 15;
        if ([userNameText.text length] > textLength) {
            [self toAlert:[NSString stringWithFormat:@"账号长度不能超过%d",textLength]];
            return NO;
        }else if (![self ruleVerify:userNameText.text rule:LOGIN_NAME_RULE]) {
            [self toAlert:@"账号不能含有非英文,数字,@,_,.字符"];
            return NO;
        }
    }else{
        [self toAlert:@"请输入账号"];
        return NO;
    }
    
    //验证昵称
    if (nickNameText.text.length > 0) {
        textLength = 15;
        if ([nickNameText.text length] > textLength) {
            [self toAlert:[NSString stringWithFormat:@"昵称长度不能超过%d",textLength]];
            return NO;
        }
    }else{
        [self toAlert:@"请输入昵称"];
        return NO;
    }
    
    //密码验证
    if (userPassWordText.text.length > 0) {
        textLength = 15;
        if ([userPassWordText.text length] > textLength) {
            [self toAlert:[NSString stringWithFormat:@"密码长度不能超过%d",textLength]];
            return NO;
        }else if (![self ruleVerify:userPassWordText.text rule:LOGIN_PASSWORD_RULE]) {
            [self toAlert:@"密码不能含有非英文,数字字符"];
            return NO;
        }
    }else{
        [self toAlert:@"请输入密码"];
        return NO;
    }
    
    //确认密码验证
    if (aUserPassWordText.text.length > 0) {
        textLength = 15;
        if ([aUserPassWordText.text length] > textLength) {
            [self toAlert:[NSString stringWithFormat:@"确认密码长度不能超过%d",textLength]];
            return NO;
        }else if (![self ruleVerify:aUserPassWordText.text rule:LOGIN_PASSWORD_RULE]) {
            [self toAlert:@"确认密码不能含有非英文,数字字符"];
            return NO;
        }
    }else{
        [self toAlert:@"请输入确认密码"];
        return NO;
    }
    
    //验证码验证
    if (checkingCodeText.text.length > 0) {
        textLength = 4;
        if ([checkingCodeText.text length] > textLength) {
            [self toAlert:[NSString stringWithFormat:@"验证码长度不能超过%d",textLength]];
            return NO;
        }else if (![self ruleVerify:checkingCodeText.text rule:LOGIN_PASSWORD_RULE]) {
            [self toAlert:@"验证码不能含有非英文,数字字符"];
            return NO;
        }
    }else{
        [self toAlert:@"请输入验证码"];
        return NO;
    }


    if (![userPassWordText.text isEqualToString:aUserPassWordText.text]) {
        [self toAlert:@"两次密码输入不一致"];
        return NO;
    }
    
    if (!isChecked){
        [self toAlert:@"请先阅读相关使用协议和隐私条款"];
        return NO;
    }    

    //发送注册请求
    ASIFormDataRequest *registerReq=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:[RequestLinkUtil getUrlByKey:USER_REGISTER_URL]]];
    [registerReq setPostValue:userNameText.text forKey:@"loginId"];//账号
    [registerReq setPostValue:[MD5 md5:userPassWordText.text] forKey:@"loginPassword"];//密码
    [registerReq setPostValue:[DataCenter sharedInstance].village.uuid forKey:@"villageId"];//小区id
    [registerReq setPostValue:nickNameText.text forKey:@"nickName"];//昵称
    [registerReq setPostValue:checkingCodeText.text forKey:@"vCode"];//验证码
    [registerReq setDelegate:self];
    [registerReq setDidFinishSelector:@selector(requestSuccess:)];
    [registerReq setDidFailSelector:@selector(requestError:)];
    [registerReq startAsynchronous];
    
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    [HUD show:YES];

    return YES;
        
}


-(void)toAgreementPage{
    NSLog(@"去看梧桐邑网络使用协议啦！！！！！！！！！！！！！");
        [self.navigationController pushViewController:aboutWTYViewController animated:YES];
    
//    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)toProvisionPage{
    NSLog(@"去看隐私条款啦！！！！！！！！！！！！！");
    aboutWTYViewController = [[AboutWTYViewController alloc] init];
    [self.navigationController pushViewController:aboutWTYViewController animated:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
}


//注销键盘
-(void)resignKeyboard{
    [userNameText resignFirstResponder];
    [nickNameText resignFirstResponder];
    [userPassWordText resignFirstResponder];
    [aUserPassWordText resignFirstResponder];
    [checkingCodeText resignFirstResponder];
    if (isCheckCode) {//如果验证码的键盘已经打开
        
            CGRect frame = self.view.frame;
            //开始动画
            [UIView beginAnimations:nil context:nil];
            //设定动画持续时间
            [UIView setAnimationDuration:0.3];
            //动画的内容
            frame.origin.y += 100;
            [self.view setFrame:frame];
            //动画结束
            [UIView commitAnimations];
            isCheckCode = NO;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
     if (textField.tag == 5) {
            [textField resignFirstResponder];
        CGRect frame = self.view.frame;
        //开始动画
        [UIView beginAnimations:nil context:nil];
        //设定动画持续时间
        [UIView setAnimationDuration:0.3];
        //动画的内容
        if (textField == checkingCodeText)
        {
            frame.origin.y += 100;
        }
        else
        {
            frame.origin.y += 70;
        }
        [self.view setFrame:frame];
        //动画结束
        [UIView commitAnimations];
         isCheckCode = NO;
     }
    return YES;

}

//点击软键盘上"Done"这个键，键盘自动隐藏,文本框、标签下移
//- (void)textFieldDidEndEditing:(UITextField *)textField{
//    
//    if (textField.tag == 5) {
//        [textField resignFirstResponder];
//        CGRect frame = self.view.frame;
//        //开始动画
//        [UIView beginAnimations:nil context:nil];
//        //设定动画持续时间
//        [UIView setAnimationDuration:0.3];
//        //动画的内容
//        if (textField == checkingCodeText)
//        {
//            frame.origin.y += 100;
//        }
//        else
//        {
//            frame.origin.y += 70;
//        }
//        [self.view setFrame:frame];
//        //动画结束
//        [UIView commitAnimations];
//    }
//    //return YES;
//}

//弹出键盘时 文本框上移
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 5) {
       
        CGRect frame = self.view.frame;
        //开始动画
        [UIView beginAnimations:nil context:nil];
        //设定动画持续时间
        [UIView setAnimationDuration:0.3];
        //动画的内容
        
        if (textField == checkingCodeText)
        {
            frame.origin.y -= 100;
        }
        else
        {
            frame.origin.y -= 70;
        }
        
        [self.view setFrame:frame];
        //动画结束
        [UIView commitAnimations];
        isCheckCode = YES;
    }
    
    return YES;
}

#pragma mark  -------注册网络请求回调----------
-(void)requestSuccess:(ASIFormDataRequest*)request{
    NSLog(@"%@",request.responseString);
    NSString *respString = request.responseString;
    NSDictionary *userDict = [respString JSONValue];
    if ([@"success" isEqualToString:[userDict objectForKey:@"resultCode"]]) {
        
        
        //发送登录请求
        ASIFormDataRequest *loginReq=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:[RequestLinkUtil getUrlByKey:USER_LOGIN_URL]]];
        [loginReq setPostValue:userNameText.text forKey:LOGIN_ID];//账号
        [loginReq setPostValue:[MD5 md5:userPassWordText.text] forKey:LOGIN_PASSWORD];//密码
        [loginReq setPostValue:[DataCenter sharedInstance].village.uuid forKey:@"villageId"];
        [loginReq setPostValue:IPHONE forKey:LOGIN_TYPE];//访问类型
        [loginReq setDelegate:self];
        [loginReq setDidFinishSelector:@selector(loginRequestSuccess:)];
        [loginReq setDidFailSelector:@selector(requestError:)];
        [loginReq startAsynchronous];
    }else{
        NSDictionary *eDict = [userDict objectForKey:@"error"];
        NSDictionary *errorDict = [[NSDictionary alloc] initWithDictionary:[[eDict objectForKey:@"globalErrors"] objectAtIndex:0]];
       
        UIAlertView *av1=[[UIAlertView alloc]initWithTitle:@"注册" message: [errorDict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [av1 show];
    }
}

#pragma mark  -------登录网络请求回调----------
-(void)loginRequestSuccess:(ASIFormDataRequest*)request
{
    
    NSLog(@"response:%@",request.responseString);
    NSDictionary *reqDict = [request.responseString JSONValue];
    if ([reqDict objectForKey:@"userInfo"]) {
        //userinfo字典
        NSDictionary*userInfoDict = [reqDict objectForKey:@"userInfo"];
        
        //初始化用户信息
        UserVO *userVO = [[UserVO alloc] initLoginUserWithDict:userInfoDict loginId:userNameText.text password:userPassWordText.text];
        //add
        NSDictionary *dic = [userInfoDict objectForKey:@"account"];
        if (userVO.loginId.length == 0) {
            userVO.loginId = [dic objectForKey:@"loginId"];
            userVO.password = [dic objectForKey:@"loginPassword"];
            userVO.isTempAcount = [[dic objectForKey:@"isTempAcco"] intValue];
        }
        
        [DataCenter sharedInstance].userVO = userVO;//放入数据中心
        
        
        
//        Village *village = [Village new];
//        NSArray *userResidences = [userInfoDict objectForKey:@"userResidences"];
//        NSDictionary *villagedic = [ [userResidences lastObject] objectForKey:@"village"];
//        village.uuid = [villagedic objectForKey:@"uuid"];
//        village.name = [villagedic objectForKey:@"name"];
//        [DataCenter sharedInstance].village = village;//将选择的小区信息放入数据中心
        
        Village *village = [Village new];
        NSArray *userResidences = [userInfoDict objectForKey:@"userResidences"];
        NSDictionary *villagedic = [ [userResidences lastObject] objectForKey:@"village"];
        village.uuid = [villagedic objectForKey:@"uuid"];
        village.name = [villagedic objectForKey:@"name"];
        [DataCenter sharedInstance].village = village;//将选择的小区信息放入数据中心
        
        [[DataCenter sharedInstance] setLocalAccount];//登录后设置本地账号
        
        //以用户uuid和账号密码注册openfire服务器
        XMPPManager *xmppManager = [XMPPManager sharedInstance];
        xmppManager.isLoginOperation = NO;
        if ([xmppManager connect]) {
            //进入主菜单
            TableBarViewController *tabbar = [[TableBarViewController alloc]init];
            [self.navigationController presentViewController:tabbar animated:NO completion:nil];
        }else{
            [[[UIAlertView alloc]initWithTitle:@"服务器异常" message:@"服务器异常" delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil] show];
        }
    }else{
        UIAlertView *av1=[[UIAlertView alloc]initWithTitle:@"注册" message:@"注册失败" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [av1 show];

    }
    [HUD hide:YES];
}

#pragma mark  -------请求错误--------
- (void)requestError:(ASIFormDataRequest*)request
{
    [HUD hide:YES];
    NSLog(@"请求失败");
    UIAlertView *av1=[[UIAlertView alloc]initWithTitle:@"注册" message:@"服务器异常" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
    [av1 show];
}

-(void) toAlert:(NSString *)msg{
        UIAlertView *av1=[[UIAlertView alloc]initWithTitle:@"注册" message:msg delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [av1 show];

}

@end
