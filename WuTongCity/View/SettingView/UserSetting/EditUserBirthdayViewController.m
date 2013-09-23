//
//  EditUserBirthdayViewController.m
//  WuTongCity
//
//  Created by alan  on 13-8-13.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "EditUserBirthdayViewController.h"
#import "DataCenter.h"
#import "DateUtil.h"

@interface EditUserBirthdayViewController ()

@end

@implementation EditUserBirthdayViewController
@synthesize userVO;
- (id)initWithUserVO:(UserVO *)_userVO{
    self = [super init];
    if (self) {
        self.userVO = _userVO;
        
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

    
    editUserBirthdayTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 420) style:UITableViewStyleGrouped];
    editUserBirthdayTableView.dataSource = self;
    editUserBirthdayTableView.delegate = self;
    [self.view addSubview:editUserBirthdayTableView];
}

-(void)goback{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)save{
    if (![userBirthdayTextField.text isEqualToString:@""]) {
        [DataCenter sharedInstance].userVO.birthday = userBirthdayTextField.text;
        
        //修改用户昵称
        ASIFormDataRequest *editBirthdayReq=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:[RequestLinkUtil getUrlByKey:PERSONAL_MODIFY]]];
        [editBirthdayReq setPostValue:tempBirthday forKey:@"frf.UserInfo.birthday"];
        [editBirthdayReq setDelegate:self];
        [editBirthdayReq setDidFinishSelector:@selector(editBirthdaySuccess:)];
        [editBirthdayReq setDidFailSelector:@selector(requestError:)];
        [editBirthdayReq startAsynchronous];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //返回分组数量,即Array的数量
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * tableIdentifier=@"EditUserBirthdayCell";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
        
    }

    userBirthdayTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 280, 20)];
    [userBirthdayTextField becomeFirstResponder];//默认一直打开键盘
    //[userBirthdayTextField setBorderStyle:UITextBorderStyleNone]; //外框类型
    userBirthdayTextField.text = self.userVO.birthday; //默认显示的字
    userBirthdayTextField.hidden = YES;
    [cell.contentView addSubview:userBirthdayTextField];
    //用label显示
    userBirthdayLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 280, 20)];
    [userBirthdayLabel setText:self.userVO.birthday];
    [userBirthdayLabel setFont:[UIFont systemFontOfSize:18]];
    [userBirthdayLabel setTextColor:[UIColor blackColor]];
    [userBirthdayLabel setBackgroundColor:[UIColor clearColor]];
    userBirthdayLabel.textAlignment = NSTextAlignmentLeft;
    [cell.contentView addSubview:userBirthdayLabel];
    //DatePicker
    userBirthdayTextField.delegate = self;
    datePicker = [[UIDatePicker alloc]init];

    //时区
    datelocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    datePicker.locale = datelocale;
    datePicker.datePickerMode = UIDatePickerModeDate;
    
    if (![self.userVO.birthday isEqualToString:@""]) {
        NSDate *d = [DateUtil dateFromString:self.userVO.birthday format:@"yyyy年MM月d日"];
        [datePicker setDate:d];
    }
    
    
    

    //设定弹出datepicker
    userBirthdayTextField.inputView = datePicker;
    //建立UIToolbar
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar setBarStyle:UIBarStyleBlack];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self
                                                                          action:@selector(cancelPicker)];

    toolBar.items = [NSArray arrayWithObject:right];
    userBirthdayTextField.inputAccessoryView = toolBar;
    
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

// 按下完成鈕後的 method
-(void) cancelPicker {
    userBirthdayTextField.text = [DateUtil stringFromDate:datePicker.date format:@"yyyy年MM月d日"];
    userBirthdayLabel.text = [DateUtil stringFromDate:datePicker.date format:@"yyyy年MM月d日"];
    tempBirthday = [DateUtil stringFromDate:datePicker.date format:@"yyyy-MM-dd"];
}

//pragma mark  -------修改生日网络请求回调----------
-(void)editBirthdaySuccess:(ASIFormDataRequest*)request{
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


@end