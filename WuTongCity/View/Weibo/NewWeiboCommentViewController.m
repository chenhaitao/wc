//
//  NewWeiboCommentViewController.m
//  WuTongCity
//
//  Created by 陈 海涛 on 13-9-27.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "NewWeiboCommentViewController.h"

@interface NewWeiboCommentViewController ()

@end

@implementation NewWeiboCommentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 20 -44 - 46)];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    moreTitle = @"显示更多";
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
        [self.tableView reloadData];
    
}


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *tableIdentifier = @"WeiboTabledentifier";
    TopicCell *cell=[tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    
    if(cell==nil){
        if (_dataSource) {
            TopicVO *topicVO = [_dataSource objectAtIndex:[indexPath row]];
            cell=[[TopicCell alloc] initWithTopicVO:topicVO];
            
            //为查看其他用户邻居说页面的用户信息做准备
            UserVO *u = [[UserVO alloc] init];
            u.userId = topicVO.userId;
            u.avatar = topicVO.avatar;
            u.nickName = topicVO.nickName;
            u.signature = topicVO.signature;
            
            //用户头像
            cell.avatarBtn = [[ParamButton alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
            NSString *avatarName = topicVO.avatar;
            //解决头像在资料更新后不显示的问题（后台修改后没有更新）
            if ([u.userId isEqualToString:[DataCenter sharedInstance].userVO.userId])
            {
                avatarName = [DataCenter sharedInstance].userVO.avatar;
                
            }
            if (avatarName.length > 0) {
                NSString *avatarString= [[RequestLinkUtil getUrlByKey:DOWNLOAD_FILE] stringByAppendingFormat:@"%@",avatarName];
                NSURL *avatarUrl=[NSURL URLWithString:avatarString];
                [cell.avatarBtn setBackgroundImageWithURL:avatarUrl
                                         placeholderImage:[UIImage imageNamed:@"defAvatar"]
                                                  success:^(UIImage *image){
                                                      [cell.avatarBtn setBackgroundImage:image forState:UIControlStateNormal];
                                                      [cell.avatarBtn setBackgroundImage:image forState:UIControlStateHighlighted];
                                                  }
                                                  failure:^(NSError *error){}];
            }else{
                [cell.avatarBtn setBackgroundImage:[UIImage imageNamed:@"defAvatar.png"] forState:UIControlStateNormal];
                [cell.avatarBtn setBackgroundImage:[UIImage imageNamed:@"defAvatar.png"] forState:UIControlStateHighlighted];
            }
            [cell.avatarBtn.layer setMasksToBounds:YES];
            [cell.avatarBtn.layer setBorderWidth:2.0]; //边框宽度
            [cell.avatarBtn.layer setBorderColor:[[UIColor whiteColor] CGColor]];
            [cell.avatarBtn.param setValue:u forKey:@"userVO"];
            [cell.avatarBtn addTarget:self action:@selector(toUserWeibo:) forControlEvents:UIControlEventTouchUpInside];//头像按钮
            [cell addSubview:cell.avatarBtn];
            
            //用户昵称按钮(字数*18+5,保证昵称显示完成)
            int nickNameLen = [topicVO.nickName mixLength];//昵称字符长度
            if (nickNameLen > 7) {
                nickNameLen = 7;
            }
            cell.nickNameBtn = [[ParamButton alloc]initWithFrame:CGRectMake(60,10,nickNameLen*18,20)];
            cell.nickNameBtn.lineBreakMode = NSLineBreakByTruncatingTail;
            [cell.nickNameBtn setTitle:topicVO.nickName forState:UIControlStateNormal];
            [cell.nickNameBtn setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];//默认蓝色字
            [cell.nickNameBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];//字体大小
            cell.nickNameBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//居左
            [cell.nickNameBtn.param setValue:u forKey:@"userVO"];
            [cell.nickNameBtn addTarget:self action:@selector(toUserWeibo:) forControlEvents:UIControlEventTouchUpInside];//昵称按钮
            [cell addSubview:cell.nickNameBtn];
            
       /*     //屏蔽此人按钮
            if (![[DataCenter sharedInstance].userVO.userId isEqualToString:topicVO.userId]) {
                cell.maskUserBtn = [[ParamButton alloc]initWithFrame:CGRectMake(cell.nickNameBtn.bounds.size.width+60,10,60,20)];
                [cell.maskUserBtn setTitle:@"屏蔽此人" forState:UIControlStateNormal];
                [cell.maskUserBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];//默认黑色字
                [cell.maskUserBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];//字体大小
                cell.maskUserBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//居左
                [cell.maskUserBtn.param setValue:topicVO.userId forKey:@"uuid"];
                [cell.maskUserBtn addTarget:self action:@selector(maskUser:) forControlEvents:UIControlEventTouchUpInside];//屏蔽此人
                [cell addSubview:cell.maskUserBtn];
            }
        */
            
            
            //发布时间
            NSString *pubTime = [NSString stringWithFormat:@"%@前",[DateUtil dateDifference:topicVO.createTime]];
            int pubTimeLen = [pubTime mixLength];
            UILabel *pubTimeLab = [[UILabel alloc]initWithFrame:CGRectMake(300-pubTimeLen*15, 10, pubTimeLen*15, 20)];
            [pubTimeLab setText:pubTime];
            [pubTimeLab setFont:[UIFont systemFontOfSize:12]];
            [pubTimeLab setTextColor:[UIColor blackColor]];
            pubTimeLab.textAlignment = NSTextAlignmentRight;
            [cell addSubview:pubTimeLab];
            
            float imgX = 60, imgY = 35;
            if (![topicVO.title isEqualToString:@""]) {
                //标题
                UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(60, 30, 230, 20)];
                [titleLab setText:topicVO.title];
                [titleLab setFont:[UIFont systemFontOfSize:16]];
                [titleLab setTextColor:[UIColor blackColor]];
                titleLab.textAlignment = NSTextAlignmentLeft;
                [cell addSubview:titleLab];
                imgY = 55;
            }
            
            if (topicVO.imageArray.count > 0) {
                int imageArrayCount = topicVO.imageArray.count;
                ParamButton *imageBtn;
                for (int i=0; i<imageArrayCount; i++) {
                    NSString *imgName = [topicVO.imageArray objectAtIndex:i];
                    NSString *imgString= [[RequestLinkUtil getUrlByKey:DOWNLOAD_FILE] stringByAppendingFormat:@"%@",imgName];
                    NSURL *imgUrl=[NSURL URLWithString:imgString];
                    imageBtn = [[ParamButton alloc]initWithFrame:CGRectMake(imgX, imgY, 70, 70)];
                    [imageBtn.param setValue:[NSString stringWithFormat:@"%d",i+1] forKey:@"index"];
                    ParamButton *tempBtn = imageBtn;
                    [tempBtn setBackgroundImageWithURL:imgUrl
                                      placeholderImage:[UIImage imageNamed:@"defAvatar"]
                                               success:^(UIImage *image){
                                                   [imageBtn setBackgroundImage:image forState:UIControlStateNormal];
                                                   [imageBtn.param setValue:[NSString stringWithFormat:@"%d",i] forKey:@"index"];
                                                   [imageBtn.param setValue:topicVO.imageArray forKey:@"imageArray"];
                                                   [imageBtn addTarget:self action:@selector(showWeiboImage:) forControlEvents:UIControlEventTouchUpInside];//查看评论
                                               }
                                               failure:^(NSError *error){}];
                    
                    if (imageArrayCount > 1) {
                        if ((i+1)%3 == 0 && (i+1) < topicVO.imageArray.count) {//每行3个，到第三个图片
                            imgX = 60;
                            imgY = imgY+imageBtn.bounds.size.height + 5;
                        }else{
                            imgX = imgX+imageBtn.bounds.size.width + 5;
                        }
                    }
                    [cell addSubview:imageBtn];
                    
                }
                imgY = imgY + imageBtn.bounds.size.height + 5;//准备图片下方的文字信息坐标
            }
            
            //内容
            bool isMore = NO;
            if (topicVO.content.length > 0) {
                UILabel *contentLab = [[UILabel alloc]init];//详细信息Label
                
                //详细信息的高度
                float contentHeight = [FormatUtil heightForString:topicVO.content fontSize:14 andWidth:240];
                if (contentHeight/18 > 3) {
                    isMore = YES;
                    if (topicVO.isShow){
                        contentLab.frame = CGRectMake(60, imgY, 240,contentHeight);
                    }else{
                        contentLab.frame = CGRectMake(60, imgY, 240,54);
                    }
                }else{
                    contentLab.frame = CGRectMake(60, imgY, 240, contentHeight);
                }
                contentLab.text = topicVO.content;
                contentLab.font = [UIFont systemFontOfSize:14];
                contentLab.numberOfLines = 0;
                contentLab.lineBreakMode = NSLineBreakByTruncatingTail;
                [contentLab setTextColor:[UIColor blackColor]];
                contentLab.textAlignment = NSTextAlignmentLeft;
                contentLab.tag = 1;
                [cell addSubview:contentLab];
                imgY = contentLab.frame.origin.y + contentLab.bounds.size.height + 5;
            }
            
            
            //显示更多按钮
            if (isMore) {
                cell.showMoreBtn = [[ParamButton alloc]initWithFrame:CGRectMake(60,imgY,60,20)];
                [cell.showMoreBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];//默认黑色字
                [cell.showMoreBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];//字体大小
                cell.showMoreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//居左
                [cell.showMoreBtn setTitle:moreTitle forState:UIControlStateNormal];
                [cell.showMoreBtn.param setValue:[NSString stringWithFormat:@"%d",[indexPath row]] forKey:@"row"];
                //                [cell.showMoreBtn.param setValue:[NSString stringWithFormat:@"%d",topicVO.isShow] forKey:@"isShow"];
                [cell.showMoreBtn addTarget:self action:@selector(showMore:) forControlEvents:UIControlEventTouchUpInside];
                
                [cell addSubview:cell.showMoreBtn];
            }
            
        /*    //赞数量按钮
            cell.praisesBtn = [[ParamButton alloc]initWithFrame:CGRectMake(165, imgY, 60, 29)];
            [cell.praisesBtn setBackgroundImage:[UIImage imageNamed:@"comment_ praise_bg"] forState:UIControlStateNormal];
            [cell.praisesBtn setTitle:[NSString stringWithFormat:@"赞(%d) ",topicVO.praies] forState:UIControlStateNormal];
            [cell.praisesBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];//默认黑色字
            [cell.praisesBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];//字体大小
            cell.praisesBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;//居左
            [cell.praisesBtn.param setValue:topicVO.topicId forKey:@"topicId"];
            //赞图标
            UIImage *praiseImage = [UIImage imageNamed:@"praise_mark"];
            UIImageView *praiseImageView = [[UIImageView alloc] initWithImage:praiseImage];
            praiseImageView.frame = CGRectMake(4, 4, praiseImage.size.width, praiseImage.size.height);
            [cell.praisesBtn addSubview:praiseImageView];
            [cell.praisesBtn addTarget:self action:@selector(praises:) forControlEvents:UIControlEventTouchUpInside];//赞
            [cell addSubview:cell.praisesBtn];
         */
            
            
            //评论数按钮
            cell.commentsBtn = [[ParamButton alloc]initWithFrame:CGRectMake(235, imgY, 75, 29)];
            [cell.commentsBtn setBackgroundImage:[UIImage imageNamed:@"comment_ praise_bg"] forState:UIControlStateNormal];
            [cell.commentsBtn setTitle:[NSString stringWithFormat:@"评论(%d) ",topicVO.comments] forState:UIControlStateNormal];
            [cell.commentsBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];//默认黑色字
            [cell.commentsBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];//字体大小
            cell.commentsBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;//居左//居左
            [cell.commentsBtn.param setValue:topicVO forKey:@"topicVO"];
            //评论图标
            UIImage *commentImage = [UIImage imageNamed:@"comment_mark"];
            UIImageView *commentImageView = [[UIImageView alloc] initWithImage:commentImage];
            commentImageView.frame = CGRectMake(4, 4, commentImage.size.width, commentImage.size.height);
            [cell.commentsBtn addSubview:commentImageView];
            [cell.commentsBtn addTarget:self action:@selector(toCommentPage:) forControlEvents:UIControlEventTouchUpInside];//查看评论
            [cell addSubview:cell.commentsBtn];
            
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.frame = CGRectMake(0, 0, 320, imgY + 34);
            
            
        }
        
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"sdfsdfsdf");
    
}

-(void) showMore:(ParamButton *)btn{
    int row = [[btn.param objectForKey:@"row"] intValue];
    TopicVO *tvo = [_dataSource objectAtIndex:row];
    if (tvo.isShow) {
        tvo.isShow = NO;
        moreTitle = @"显示更多";
    }else{
        tvo.isShow = YES;
        moreTitle = @"收起";
    }
    [self.tableView reloadData];
}


-(void) showWeiboImage:(ParamButton *)btn{
    //    SDWebImageDataSource *images_ = [[SDWebImageDataSource alloc] init];
    //
    //    KTPhotoScrollViewController *newController = [[KTPhotoScrollViewController alloc]
    //                                                  initWithDataSource:images_
    //                                                  andStartWithPhotoAtIndex:2];
    
    
    
    
    
    //
    //    SDWebImageDataSource *images_ = [[SDWebImageDataSource alloc] initWithImageArray:[btn.param objectForKey:@"imageArray"]];
    //
    //
    //
    //    KTPhotoScrollViewController *newController = [[KTPhotoScrollViewController alloc]
    //                                                  initWithDataSource:images_
    //                                                  andStartWithPhotoAtIndex:[[btn.param objectForKey:@"index"] intValue]];
    
    NSArray *images = [btn.param objectForKey:@"imageArray"];
    PhotoDataSource *dataSource = [[PhotoDataSource alloc] initWithImages:images];
    
    KTPhotoScrollViewController *newController = [[KTPhotoScrollViewController alloc]
                                                  initWithDataSource:dataSource
                                                  andStartWithPhotoAtIndex:[[btn.param objectForKey:@"index"]intValue]];
    //[newController setStatusbarHidden:YES];
    
    //    UINavigationController *newNavController = [[UINavigationController alloc] initWithRootViewController:newController];
    //    [[newNavController navigationBar] setBarStyle:UIBarStyleBlack];
    //    [[newNavController navigationBar] setTranslucent:YES];
    
    
    
    //    window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //    window.rootViewController = newController;
    //    [window makeKeyAndVisible];
    
    
    [self.navigationController pushViewController:newController animated:YES];
}

/*
//查看某一用户发布的所有邻居说
-(void)toUserWeibo:(ParamButton *)btn{
    [weiboReq cancel];
    UserVO *userVO = [btn.param objectForKey:@"userVO"];
    OtherWeiboViewController *otherWeiboViewController = [[OtherWeiboViewController alloc] initWithUserVO:userVO];
    otherWeiboViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:otherWeiboViewController animated:YES];
}

//屏蔽此人
-(void)maskUser:(ParamButton *)btn{
    [_dataSource removeAllObjects];
    NSString *uuid = [btn.param objectForKey:@"uuid"];
    
    NSURL *url = [NSURL URLWithString:[RequestLinkUtil getUrlByKey:USER_SHIELD]];
    ASIFormDataRequest *userShieldReq = [ASIFormDataRequest requestWithURL:url];
    [userShieldReq setPostValue:uuid forKey:@"userId"];//
    [userShieldReq setCompletionBlock:^{//成功
        [self loadData];//重新读取数据
    }];
    [userShieldReq setFailedBlock:^{//失败
    }];
    [userShieldReq startAsynchronous];
}

//赞--0:成功，1:失败
-(void)praises:(ParamButton *)btn{
    [_dataSource removeAllObjects];
    NSString *topicId = [btn.param objectForKey:@"topicId"];
    NSURL *url = [NSURL URLWithString:[RequestLinkUtil getUrlByKey:PUBLIC_BLOG_PRAISES]];
    ASIFormDataRequest *praisesReq = [ASIFormDataRequest requestWithURL:url];
    [praisesReq setPostValue:topicId forKey:@"uuid"];//
    [praisesReq setPostValue:@"0" forKey:@"type"];//
    [praisesReq setCompletionBlock:^{
        int praises = [[praisesReq responseString] intValue];
        if (praises > 0 ) {//失败
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"梧桐邑" message:@"您已经赞过该邻居说" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
            [alert show];
        }
      //  [self loadData];//重新读取数据
    }];
    [praisesReq setFailedBlock:^{
        //        NSError *error = [praisesReq error];
    }];
    [praisesReq startAsynchronous];
}
 */

//查看评论
-(void)toCommentPage:(ParamButton *)btn{
   
    TopicVO *topicVO = [btn.param objectForKey:@"topicVO"];
    CommentViewController *commentViewController = [[CommentViewController alloc] initWithTopic:topicVO];
    commentViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:commentViewController animated:YES];
}

//创建blog页面
-(void)toCreateWeibo{
   
    CreateWeiboViewController *createWeiboViewController = [[CreateWeiboViewController alloc]init];
    UINavigationController *createWeiboNav=[[UINavigationController alloc]initWithRootViewController:createWeiboViewController];
    createWeiboNav.navigationBar.barStyle = UIBarStyleBlack;
    [self presentViewController:createWeiboNav animated:YES completion:NO];
}






//-(void) refreshTableView{
//    [self.tableView reloadData];
//}




@end
