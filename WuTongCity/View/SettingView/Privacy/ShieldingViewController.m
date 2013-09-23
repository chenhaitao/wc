//
//  ShieldingViewController.m
//  WuTongCity
//
//  Created by alan  on 13-8-27.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "ShieldingViewController.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h> 
#import "ShieldingCell.h"

@interface ShieldingViewController ()

@end

@implementation ShieldingViewController

-(id)init{
    if (self = [super init]) {
        shieldingArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    [HUD show:YES];
    
    
    //邻居列表
    shieldingTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height) style:UITableViewStylePlain];
    shieldingTableView.dataSource = self;
    shieldingTableView.delegate = self;
    [self.view addSubview:shieldingTableView];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self reloadShieldingList];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;//返回分组数量,即Array的数量
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [shieldingArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        
    UserVO *userVO = [shieldingArray objectAtIndex:[indexPath row]];
    static NSString * tableIdentifier=@"limitTableViewCell";
    
    ShieldingCell *cell=[tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if(cell==nil){
        cell=[[ShieldingCell alloc]initWithUserVO:userVO];
        [cell.shieldingBtn addTarget:self action:@selector(shieldingUser:) forControlEvents:UIControlEventTouchUpInside];//屏蔽
    }
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"";
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(void) shieldingUser:(ParamButton *)btn{
    ParamButton *paramBtn = (ParamButton *)btn;
    UserVO *uvo = [paramBtn.param objectForKey:@"userVO"];
    
    
    
    
    
    
    if (uvo.isShield > 0) {//取消限制
        NSURL *url = [NSURL URLWithString:[RequestLinkUtil getUrlByKey:CANCEL_R_S]];
        ASIFormDataRequest *cancelShieldingReq = [ASIFormDataRequest requestWithURL:url];
        [cancelShieldingReq setPostValue:uvo.shieldId forKey:@"uuid"];
        [cancelShieldingReq setCompletionBlock:^{
            NSLog(@"%@",[cancelShieldingReq responseString]);
            [self reloadShieldingList];
            [HUD hide:YES];
        }];
        [cancelShieldingReq setFailedBlock:^{
            UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"梧桐邑" message:@"服务器异常" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [av show];
            [HUD hide:YES];
        }];
        [cancelShieldingReq startAsynchronous];
        [HUD show:YES];
    }else{//屏蔽
        NSURL *url = [NSURL URLWithString:[RequestLinkUtil getUrlByKey:USER_SHIELD]];
        ASIFormDataRequest *shieldUserReq = [ASIFormDataRequest requestWithURL:url];
        [shieldUserReq setPostValue:uvo.userId forKey:@"userId"];
        [shieldUserReq setCompletionBlock:^{
            NSLog(@"%@",[shieldUserReq responseString]);
            [self reloadShieldingList];
            [HUD hide:YES];
        }];
        [shieldUserReq setFailedBlock:^{
            UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"梧桐邑" message:@"服务器异常" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [av show];
            [HUD hide:YES];
        }];
        [shieldUserReq startAsynchronous];
        [HUD show:YES];
    }

    
}


-(void) reloadShieldingList{
    [shieldingArray removeAllObjects];
    NSURL *url = [NSURL URLWithString:[RequestLinkUtil getUrlByKey:USER_LIST]];
    ASIFormDataRequest *shidldingListReq = [ASIFormDataRequest requestWithURL:url];
    [shidldingListReq setPostValue:@"all" forKey:@"type"];
    [shidldingListReq setCompletionBlock:^{
        NSLog(@"%@",[shidldingListReq responseString]);
        NSString *responseStr = [shidldingListReq responseString];
        NSDictionary *responseDict = [responseStr JSONValue];
        int totalCount = [[responseDict objectForKey:@"totalCount"] intValue];
        if (totalCount > 0) {
            NSArray *arr = [responseDict objectForKey:@"result"];
            for (NSDictionary *dict in arr) {
                [shieldingArray addObject:[[UserVO alloc] initNeighbourWithDict:dict]];
            }
            [shieldingTableView reloadData];
        }
        [HUD hide:YES];
    }];
    [shidldingListReq setFailedBlock:^{
        UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"梧桐邑" message:@"服务器异常" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [av show];
        [HUD hide:YES];
    }];
    [shidldingListReq startAsynchronous];
    [HUD show:YES];
}





@end
