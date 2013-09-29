//
//  WutongCityViewController.m
//  WutongCity
//
//  Created by alan  on 13-7-7.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "TableBarViewController.h"
#import "MD5.h"
#import "UserVO.h"
#import "Village.h"
#import "XMPPManager.h"
#import "NSString.h"

@interface LoginViewController ()

@end


@implementation LoginViewController

-(id) init{
    if ((self = [super init])) {
        isLogin = YES;
        self.navigationItem.title = [DataCenter sharedInstance].village.name;
    }
    return self;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    
    //透明指示层
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.delegate = self;
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"注册"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(toRegisterPage)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    
    //背景图
    UIImage *pic = [UIImage imageNamed:@"bg.png"];
    UIImageView *bgImage = [[UIImageView alloc] initWithImage:pic];
    bgImage.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-44);
    [self.view addSubview:bgImage];
    
    
    //添加点击手势--点击撤销键盘
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyboard)];
    gestureRecognizer.cancelsTouchesInView = YES;
    [self.view addGestureRecognizer:gestureRecognizer];
    

    loginView = [[UIView alloc]initWithFrame:CGRectMake(10, MAX_Y, 300, 87)];
    [self.view addSubview:loginView];
    
    //背景图
    UIImage *loginFormPic = [UIImage imageNamed:@"loginForm.png"];
    UIImageView *loginFormImage = [[UIImageView alloc] initWithImage:loginFormPic];
    loginFormImage.frame = CGRectMake(0, 0, loginView.bounds.size.width, loginView.bounds.size.height);
    [loginView addSubview:loginFormImage];


    //登录账号输入框
    userNameText = [[UITextField alloc]initWithFrame:CGRectMake(80, 13, 210, 25)];
    [userNameText addTarget:self action:@selector(textFieldVerify:) forControlEvents:UIControlEventEditingChanged];//限制输入的文本的长度
    userNameText.placeholder = @"手机号/邮箱";
    userNameText.returnKeyType = UIReturnKeyDone;//键盘上面有“Done”
    userNameText.textColor = [UIColor blackColor];
    userNameText.autocorrectionType = UITextAutocorrectionTypeNo;//关闭联想功能
    userNameText.delegate = self;//关闭键盘
    userNameText.borderStyle = UITextBorderStyleNone;//输入框边框类型
    userNameText.backgroundColor = [UIColor clearColor];
    userNameText.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时会出现个修改X
    userNameText.keyboardType = UIKeyboardTypeAlphabet;
    userNameText.autocapitalizationType = UITextAutocapitalizationTypeNone;//不自动大写
    userNameText.tag = 1;
    [loginView addSubview:userNameText];
    
    
    //登录密码输入框
    userPassWordText = [[UITextField alloc]initWithFrame:CGRectMake(80, 55, 210, 25)];
    [userPassWordText addTarget:self action:@selector(textFieldVerify:) forControlEvents:UIControlEventEditingChanged];//限制输入的文本的长度
    userPassWordText.placeholder = @"英文/数字";
    userPassWordText.returnKeyType = UIReturnKeyDone;//键盘上面有“Done”
    userPassWordText.textColor = [UIColor blackColor];
    userPassWordText.autocorrectionType = UITextAutocorrectionTypeNo;//关闭联想功能
    userPassWordText.secureTextEntry = YES;//设置密码显示格式
    userPassWordText.delegate = self;//关闭键盘
    userPassWordText.borderStyle = UITextBorderStyleNone;//输入框边框类型
    userPassWordText.backgroundColor = [UIColor clearColor];
    userPassWordText.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时会出现个修改X
    userPassWordText.tag = 2;
    [loginView addSubview:userPassWordText];
    

    //登录提交按钮
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(10,250,134,44)];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"loginFuc.png"] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    //快速浏览
    UIButton *startBtn = [[UIButton alloc] initWithFrame:CGRectMake(175,250,134,44)];
    [startBtn setImage:[UIImage imageNamed:@"startFuc.png"] forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

//限制输入的文本的长度
-(void)textFieldVerify:(UITextField *)textField{
    if ([textField.text mixLength] > 15) {
        textField.text=[textField.text substringToIndex:30];
    }
    
    NSString *r;
    if (textField.tag > 1) {//密码
        r = LOGIN_PASSWORD_RULE;
    }else{
        r = LOGIN_NAME_RULE;
    }
    
    if (![self ruleVerify:textField.text rule:r]) {
        if (textField.text.length > 0) {
            textField.text = [textField.text substringToIndex:textField.text.length-1];
        }
    }
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

//注销键盘
-(void)resignKeyboard{
    [userNameText resignFirstResponder];
    [userPassWordText resignFirstResponder];
    [self keyboardMove:1];
}

//点击软键盘上"Done"这个键，键盘自动隐藏,文本框、标签下移
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [userNameText resignFirstResponder];
    [userPassWordText resignFirstResponder];
	[self keyboardMove:1];
    return YES;
}


//弹出键盘时 文本框上移
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self keyboardMove:0];
    return YES;
}

//键盘移动--moveType:上移=0,下移=1
-(void) keyboardMove:(int) moveType{
    CGRect frame = loginView.frame;
    float coordY = frame.origin.y;
    float tempCoord = 0.0;
    if (moveType > 0 && coordY == MIN_Y) {
        tempCoord = frame.origin.y + 50;
    }
    if (moveType == 0 && coordY == MAX_Y) {
        tempCoord = frame.origin.y - 50;
    }
    if (tempCoord > 0) {
        //开始动画
        [UIView beginAnimations:nil context:nil];
        //设定动画持续时间
        [UIView setAnimationDuration:0.3];
        //动画的内容
        frame.origin.y = tempCoord;
        [loginView setFrame:frame];
        //动画结束
        [UIView commitAnimations];
    }    
}

//登录
-(BOOL)login{
    
    NSString *msg = @"";
    if (userNameText.text.length == 0){
        msg = @"请输入账号";
    }else if (userPassWordText.text.length == 0) {
        msg = @"请输入密码";
    }
    if (msg.length > 0) {
        UIAlertView *av1=[[UIAlertView alloc]initWithTitle:@"登录" message:msg delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [av1 show];
        return NO;
    }

    
    //发送登录请求
    ASIFormDataRequest *loginReq=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:[RequestLinkUtil getUrlByKey:USER_LOGIN_URL]]];
    [loginReq setPostValue:userNameText.text forKey:LOGIN_ID];//账号
    [loginReq setPostValue:[MD5 md5:userPassWordText.text] forKey:LOGIN_PASSWORD];//密码
    [loginReq setPostValue:IPHONE forKey:LOGIN_TYPE];//访问类型
    [loginReq setPostValue:[DataCenter sharedInstance].village.uuid forKey:@"villageId"];
    [loginReq setDelegate:self];
    [loginReq setDidFinishSelector:@selector(loginSuccess:)];
    [loginReq setDidFailSelector:@selector(requestError:)];
    [loginReq startAsynchronous];
    //弹出透明指示层
    [HUD show:YES];
    
    return YES;
}

//注册页面
-(void) toRegisterPage{
    RegisterViewController *registerViewController = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:registerViewController animated:YES];
}

//快速浏览
-(void)start{
    //发送登录请求
    ASIFormDataRequest *startReq=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:[RequestLinkUtil getUrlByKey:USER_CREATE]]];
    NSLog(@"%@",[DataCenter sharedInstance].village.uuid);
    [startReq setPostValue:[DataCenter sharedInstance].village.uuid forKey:@"villageId"];//小区id
    [startReq setDelegate:self];
    [startReq setDidFinishSelector:@selector(startSuccess:)];
    [startReq setDidFailSelector:@selector(requestError:)];
    [startReq startAsynchronous];
    //弹出透明指示层
    [HUD show:YES];    
}

#pragma mark  -------登录网络请求回调----------
-(void)loginSuccess:(ASIFormDataRequest*)request{
    NSDictionary *reqDict = [request.responseString JSONValue];
    NSLog(@"登录成功：%@",reqDict);
    if ([reqDict objectForKey:@"userInfo"]) {
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
        Village *village = [Village new];
        NSArray *userResidences = [userInfoDict objectForKey:@"userResidences"];
        NSDictionary *villagedic = [ [userResidences lastObject] objectForKey:@"village"];
        village.uuid = [villagedic objectForKey:@"uuid"];
        village.name = [villagedic objectForKey:@"name"];
        [DataCenter sharedInstance].village = village;//将选择的小区信息放入数据中心
        [[DataCenter sharedInstance] setLocalAccount];//登录后设置本地账号
        
        
        //以用户uuid和账号密码注册openfire服务器
        XMPPManager *xmppManager = [XMPPManager sharedInstance];
        if (isLogin)//登录为真
            xmppManager.isLoginOperation = YES;
        else
            xmppManager.isLoginOperation = NO;
        
        if ([xmppManager connect]) {
            //进入主菜单
            TableBarViewController *tabbar = [[TableBarViewController alloc]init];
            [self.navigationController presentViewController:tabbar animated:NO completion:nil];
        }else{
            [[[UIAlertView alloc]initWithTitle:@"梧桐邑" message:@"登陆失败" delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil] show];
        }
    }else{
        UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"梧桐邑" message:@"登陆失败" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [av show];
        
    }
    [HUD hide:YES];
}

#pragma mark  -------登录网络请求回调----------
-(void)startSuccess:(ASIFormDataRequest*)request{
    NSString *respString = request.responseString;
    NSDictionary *reqDict = [respString JSONValue];
    if ([reqDict objectForKey:LOGIN_ID]) {
        isLogin = NO;//注册
        //发送登录请求
        
        ASIFormDataRequest *loginReq=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:[RequestLinkUtil getUrlByKey:USER_LOGIN_URL]]];
        [loginReq setPostValue:[reqDict objectForKey:LOGIN_ID] forKey:LOGIN_ID];//账号
        [loginReq setPostValue:[MD5 md5:DEFAULT_USER_PASSWORD] forKey:LOGIN_PASSWORD];//密码
        [loginReq setPostValue:IPHONE forKey:LOGIN_TYPE];//访问类型
         [loginReq setPostValue:[DataCenter sharedInstance].village.uuid forKey:@"villageId"];
        [loginReq setDelegate:self];
        [loginReq setDidFinishSelector:@selector(loginSuccess:)];
        [loginReq setDidFailSelector:@selector(requestError:)];
        [loginReq startAsynchronous];
    }else{
        UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"梧桐邑"
                                                  message:@"快速注册失败"
                                                 delegate:nil
                                        cancelButtonTitle:@"好的"
                                        otherButtonTitles: nil];
        [av show];
        [HUD hide:YES];
    }
}

#pragma mark  -------请求错误--------
- (void)requestError:(ASIFormDataRequest*)request
{
    [HUD hide:YES];
    UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"梧桐邑"
                                              message:@"服务器异常"
                                             delegate:nil
                                    cancelButtonTitle:@"好的"
                                    otherButtonTitles: nil];
    [av show];
}



@end
