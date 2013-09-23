//
//  EditSignatureViewController.m
//  WuTongCity
//
//  Created by alan  on 13-8-13.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "EditSignatureViewController.h"
#import "DataCenter.h"

@interface EditSignatureViewController ()

@end

@implementation EditSignatureViewController
@synthesize signature;

- (id)initWithSignature:(NSString *)_signature{
    self = [super init];
    if (self) {
        self.signature = _signature;
        
//        self.view.backgroundColor = [UIColor lightGrayColor];
        
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
    
    editSignatureTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 420) style:UITableViewStyleGrouped];
    editSignatureTableView.dataSource = self;
    editSignatureTableView.delegate = self;
    [self.view addSubview:editSignatureTableView];
    
}

-(void)goback{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)save{
    [DataCenter sharedInstance].userVO.signature = signatureTextView.text;
    
    //修改用户昵称
    ASIFormDataRequest *editSignatureReq=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:[RequestLinkUtil getUrlByKey:PERSONALITY_MODIFY]]];
    [editSignatureReq setPostValue:[DataCenter sharedInstance].userVO.userPersonalityId forKey:@"frf.UserPersonality.uuid"];
    [editSignatureReq setPostValue:signatureTextView.text forKey:@"frf.UserPersonality.signature"];
    [editSignatureReq setDelegate:self];
    [editSignatureReq setDidFinishSelector:@selector(editSignatureSuccess:)];
    [editSignatureReq setDidFailSelector:@selector(requestError:)];
    [editSignatureReq startAsynchronous];
    
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
    static NSString * tableIdentifier=@"EditSignatureCell";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
        
    }
    
    signatureTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, 280, 120)];
    signatureTextView.delegate = self;
    signatureTextView.text=self.signature;
    [signatureTextView becomeFirstResponder];
    signatureTextView.font = [UIFont systemFontOfSize:14];
    [cell.contentView addSubview:signatureTextView];
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140.0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"";
    
}

-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length >= 30) {
        textView.text=[textView.text substringToIndex:30];
    }

}


//pragma mark  -------修改头像网络请求回调----------
-(void)editSignatureSuccess:(ASIFormDataRequest*)request{
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
