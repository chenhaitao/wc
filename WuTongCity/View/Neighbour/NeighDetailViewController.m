//
//  NeighbourDetailViewController.m
//  WuTongCity
//
//  Created by alan  on 13-8-14.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "NeighDetailViewController.h"
#import "DataCenter.h"
#import "NeighbourDetailCell.h"
#import <QuartzCore/QuartzCore.h>
#import "ChatSendMsgViewController.h"
#import "UIImageView+WebCache.h"
#import "ParamButton.h"

@interface NeighDetailViewController ()

@end

@implementation NeighDetailViewController
@synthesize neighbourDict, neighbourSectionArray;
-(id)initWithUserVO:(UserVO *)_userVO;{
    if (self = [super init]) {
        userVO = [[UserVO alloc] init];
        userVO = _userVO;
        self.neighbourDict = [[NSMutableDictionary alloc]initWithDictionary:[userVO getUserDcit]];//用户信息字典
        [self.neighbourDict removeObjectForKey:@"1"];//删除第一个分组
        [self.neighbourDict removeObjectForKey:@"2"];//删除第二个分组
        self.neighbourSectionArray = [[NSArray alloc]initWithArray:[self.neighbourDict allKeys]];//分组集合
    }
    return self;
}

- (void)viewDidLoad{
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 130)];
    stickUserBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 80, 300, 40)];
    [stickUserBtn setBackgroundImage:[UIImage imageNamed:@"blueBg"] forState:UIControlStateNormal];
    [stickUserBtn setTitle:@"邻 居 置 顶" forState:UIControlStateNormal];
    [stickUserBtn.titleLabel setFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:20]];
    [stickUserBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//
    [stickUserBtn addTarget:self action:@selector(stickUser) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:stickUserBtn];

    ParamButton *chatBtn = [[ParamButton alloc] initWithFrame:CGRectMake(10, 20, 300, 40)];
    [chatBtn setBackgroundImage:[UIImage imageNamed:@"redBtn"] forState:UIControlStateNormal];
    [chatBtn setTitle:@"发 消 息" forState:UIControlStateNormal];
    [chatBtn.titleLabel setFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:20]];
    [chatBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//
    
    [chatBtn addTarget:self action:@selector(toChatView) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:chatBtn];
    
    

    //用户信息列表
    neighbourDetailTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-44) style:UITableViewStyleGrouped];
    neighbourDetailTableView.dataSource = self;
    neighbourDetailTableView.delegate = self;
    neighbourDetailTableView.backgroundColor = [UIColor clearColor];
    [neighbourDetailTableView setTableFooterView:footView];
    [self.view addSubview:neighbourDetailTableView];
    
    [super viewDidLoad];
}

//返回分组数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.neighbourSectionArray count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *key=[self.neighbourSectionArray objectAtIndex:section];//返回当前分组对应neighbourDict的key值
    NSArray *sectionArray=[self.neighbourDict objectForKey:key];//根据key，取得Array
    return [sectionArray count]; //返回Array的大小
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *key = [self.neighbourSectionArray objectAtIndex:[indexPath section]];
    NSArray *section = [self.neighbourDict objectForKey:key];
    NSDictionary *dict = [[NSDictionary alloc]initWithDictionary:[section objectAtIndex:[indexPath row]]];


    static NSString * tableIdentifier=@"NeighbourDetailCell";
    NeighbourDetailCell *cell=[tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if(cell==nil){
        cell=[[NeighbourDetailCell alloc]initWithTitle:[dict objectForKey:@"title"] content:[dict objectForKey:@"content"]];

    }
    return cell;
}

//cell行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}

//分组的title
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"";
}

// 自定义UITableView的区段的Header
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSLog(@"%d",section);
    if (section == 0) {
        //headerView
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 110)];
            
        //用户头像
        UIImageView *avatarView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 70, 70)];
        NSString *avatarName = userVO.avatar;
        
        if (![avatarName isEqualToString:@""]) {
            NSLog(@"%@",avatarName);
            NSString *avatarString= [[RequestLinkUtil getUrlByKey:DOWNLOAD_FILE] stringByAppendingFormat:@"%@",avatarName];
            NSURL *avatarUrl=[NSURL URLWithString:avatarString];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 70, 70)];
            [imageView setImageWithURL:avatarUrl
                      placeholderImage:[UIImage imageNamed:@"defAvatar.png"]
                               success:^(UIImage *image){
                                   avatarView.image = image;
                               }
                               failure:^(NSError *error){}];
        }else{
            avatarView.image = [UIImage imageNamed:@"defAvatar.png"];
        }
        [avatarView.layer setMasksToBounds:YES];
        [avatarView.layer setCornerRadius:6.0];
        [headerView addSubview:avatarView];
    
        
        //昵称
        UILabel *nickNameLab = [[UILabel alloc] initWithFrame:CGRectMake(90, 10, 200, 20)];
        nickNameLab.backgroundColor = [UIColor clearColor];
        nickNameLab.textColor = [UIColor blackColor];
        nickNameLab.font = [UIFont fontWithName:@"Arial" size:18];
        nickNameLab.text = userVO.nickName;
        [headerView addSubview:nickNameLab];
        
        //签名
        UILabel *signatureLab= [[UILabel alloc] initWithFrame:CGRectMake(90, 35, 200, 60)];
        signatureLab.backgroundColor = [UIColor clearColor];
        signatureLab.textColor = [UIColor blackColor];
        signatureLab.font = [UIFont fontWithName:@"Arial" size:14];
        signatureLab.text = userVO.signature;
        signatureLab.numberOfLines = 3;
        signatureLab.lineBreakMode = NSLineBreakByTruncatingTail;
        [headerView addSubview:signatureLab];
        return headerView;
    }

    
    return nil;
}

// UITableView Header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    float height = 20;
    if (section == 0) {
        height = 110;
    }
    return height;
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

-(void) toChatView{
    NSLog(@"发消息咯！！");
    ChatSendMsgViewController *sendView=[[ChatSendMsgViewController alloc]init];
    NSDictionary *userDict = [[NSDictionary alloc] initWithObjectsAndKeys:userVO.userId,@"userId",
                              userVO.nickName,@"userNickname",
                              userVO.nickName,@"userDescription",
                              userVO.avatar,@"userHead",nil];
    WCUserObject *localUser=[WCUserObject userFromDictionary:userDict];
    //如果当前没有该用户,保存
    if (![WCUserObject haveSaveUserById:userVO.userId]) {
        [WCUserObject saveNewUser:localUser];
    }
    [sendView setChatPerson:localUser];
    [sendView setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:sendView animated:YES];
}


//置顶用户
-(void) stickUser{
    if (userVO.isStick > 0) {//取消置顶
        NSURL *url = [NSURL URLWithString:[RequestLinkUtil getUrlByKey:CANCEL_R_S]];
        ASIFormDataRequest *cancelStickReq = [ASIFormDataRequest requestWithURL:url];
        [cancelStickReq setPostValue:userVO.stickId forKey:@"uuid"];
        [cancelStickReq setCompletionBlock:^{
            NSLog(@"%@",[cancelStickReq responseString]);
            [stickUserBtn setTitle:@"邻 居 置 顶" forState:UIControlStateNormal];

        }];
        [cancelStickReq setFailedBlock:^{
            UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"梧桐邑" message:@"服务器异常" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [av show];
        }];
        [cancelStickReq startAsynchronous];

    }else{//置顶
        NSURL *url = [NSURL URLWithString:[RequestLinkUtil getUrlByKey:USER_STICK]];
        ASIFormDataRequest *stickReq = [ASIFormDataRequest requestWithURL:url];
        [stickReq setPostValue:userVO.userId forKey:@"userId"];
        [stickReq setCompletionBlock:^{
            NSLog(@"%@",[stickReq responseString]);
            [stickUserBtn setTitle:@"取 消 置 顶" forState:UIControlStateNormal];
//            [HUD hide:YES];
        }];
        [stickReq setFailedBlock:^{
            UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"梧桐邑" message:@"服务器异常" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [av show];
//            [HUD hide:YES];
        }];
        [stickReq startAsynchronous];
    }
}


@end
