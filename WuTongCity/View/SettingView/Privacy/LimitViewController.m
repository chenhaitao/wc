//
//  LimitViewController.m
//  WuTongCity
//
//  Created by alan  on 13-8-27.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "LimitViewController.h"
#import "UIImageView+WebCache.h"
#import "LimitCell.h"
#import "UserVO.h"

@interface LimitViewController ()

@end

@implementation LimitViewController

-(id)init{
    if (self = [super init]) {
        limitArray = [[NSMutableArray alloc] init];   
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    
    
    
    //邻居列表
    limitTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-44) style:UITableViewStylePlain];
    limitTableView.dataSource = self;
    limitTableView.delegate = self;
    [self.view addSubview:limitTableView];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self reloadLimitList];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;//返回分组数量,即Array的数量
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [limitArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UserVO *userVO = [limitArray objectAtIndex:[indexPath row]];
    static NSString * tableIdentifier=@"limitTableViewCell";
    
    LimitCell *cell= nil;
    if(cell==nil){
        cell=[[LimitCell alloc]initWithUserVO:userVO];
        [cell.limitBtn addTarget:self action:@selector(limitUser:) forControlEvents:UIControlEventTouchUpInside];//查看评论
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
    //    NeighbourCell *neighbourCell = (NeighbourCell *)[tableView cellForRowAtIndexPath:indexPath];
    //
    //    self.neighDetailViewController = [[NeighDetailViewController alloc]initWithUser:neighbourCell.user];
    //    [self.navigationController pushViewController:self.neighDetailViewController animated:YES];
    //    self.neighDetailViewController.title = @"邻居";
}

-(void) limitUser:(ParamButton *)btn{
    ParamButton *paramBtn = (ParamButton *)btn;
    UserVO *uvo = [paramBtn.param objectForKey:@"userVO"];
    
    if (uvo.isRestrict > 0) {//取消限制
        NSURL *url = [NSURL URLWithString:[RequestLinkUtil getUrlByKey:CANCEL_R_S]];
        ASIFormDataRequest *cancelLimitUserReq = [ASIFormDataRequest requestWithURL:url];
        [cancelLimitUserReq setPostValue:uvo.restrictId forKey:@"uuid"];
        [cancelLimitUserReq setCompletionBlock:^{
          
            [self reloadLimitList];
            [HUD hide:YES];
        }];
        [cancelLimitUserReq setFailedBlock:^{
            UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"梧桐邑" message:@"服务器异常" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [av show];
            [HUD hide:YES];
        }];
        [cancelLimitUserReq startAsynchronous];
        [HUD show:YES];
    }else{//限制
        NSURL *url = [NSURL URLWithString:[RequestLinkUtil getUrlByKey:USER_RESTRICT]];
        ASIFormDataRequest *limitUserReq = [ASIFormDataRequest requestWithURL:url];
        [limitUserReq setPostValue:uvo.userId forKey:@"userId"];
        [limitUserReq setCompletionBlock:^{
           
            [self reloadLimitList];
            [HUD hide:YES];
        }];
        [limitUserReq setFailedBlock:^{
            UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"梧桐邑" message:@"服务器异常" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [av show];
            [HUD hide:YES];
        }];
        [limitUserReq startAsynchronous];
        [HUD show:YES];
    }
    
    
}

//刷新列表
-(void) reloadLimitList{
    [limitArray removeAllObjects];
    NSURL *url = [NSURL URLWithString:[RequestLinkUtil getUrlByKey:USER_LIST]];
    ASIFormDataRequest *limitUserListReq = [ASIFormDataRequest requestWithURL:url];
    [limitUserListReq setPostValue:@"all" forKey:@"type"];
    [limitUserListReq setCompletionBlock:^{//成功
        NSString *responseStr = [limitUserListReq responseString];
        NSDictionary *responseDict = [responseStr JSONValue];
        int totalCount = [[responseDict objectForKey:@"totalCount"] intValue];;
        if (totalCount > 0) {
            NSArray *arr = [responseDict objectForKey:@"result"];
            for (NSDictionary *dict in arr) {
                [limitArray addObject:[[UserVO alloc] initNeighbourWithDict:dict]];
                
                UserVO *user = [[UserVO alloc] initNeighbourWithDict:dict];
                NSLog(@"name:%@,%i", user.nickName,user.isRestrict);
                
            }
            [limitTableView reloadData];
        }
        [HUD hide:YES];
    }];
    [limitUserListReq setFailedBlock:^{//失败
        UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"梧桐邑" message:@"服务器异常" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [av show];
        [HUD hide:YES];
    }];
    [limitUserListReq startAsynchronous];
    [HUD show:YES];
}

@end
