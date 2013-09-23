//
//  CommentViewController.m
//  WuTongCity
//
//  Created by alan  on 13-8-21.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "CommentViewController.h"
#import "DataCenter.h"
#import "CommentVO.h"
#import "CommentCell.h"

@implementation CommentViewController

-(id)initWithTopic:(TopicVO *)_topicVO
{
    self = [super init];
    if (self) {
        topicVO = _topicVO;
        pageNo = 1;//设置为第一页
        _dataSource = [[NSMutableArray alloc] init];
        comments = topicVO.comments;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    moreTitle = @"显示更多";
    isShow = NO;
    
    commentHeaderView = [[CommentHeaderView alloc]initWithTopicVO:topicVO isShow:NO];
    [commentHeaderView.showMoreBtn setTitle:@"显示更多" forState:UIControlStateNormal];
    [commentHeaderView.showMoreBtn addTarget:self action:@selector(showMoreByHead) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableHeaderView = commentHeaderView;

    FaceToolBar* bar=[[FaceToolBar alloc]initWithFrame:CGRectMake(0.0f,self.view.frame.size.height - toolBarHeight,self.view.frame.size.width,toolBarHeight) superView:self.view text:@"我要评论"];
    bar.delegate=self;
    [self.view addSubview:bar];
}

-(void) showMoreByHead{
    if (commentHeaderView.tVO.isShow) {
        commentHeaderView = [[CommentHeaderView alloc]initWithTopicVO:topicVO isShow:NO];
        [commentHeaderView.showMoreBtn setTitle:@"显示更多" forState:UIControlStateNormal];
    }else{
        commentHeaderView = [[CommentHeaderView alloc]initWithTopicVO:topicVO isShow:YES];
        [commentHeaderView.showMoreBtn setTitle:@"收起" forState:UIControlStateNormal];
    }
    [commentHeaderView.showMoreBtn addTarget:self action:@selector(showMoreByHead) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableHeaderView = commentHeaderView;
}

-(void) showMoreByComment:(ParamButton *)btn{
    //获取选中删除行索引值
    NSIndexPath *indexPath = [btn.param objectForKey:@"indexPath"];
    CommentCell *cell= (CommentCell *)[self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    if (cell.isShow) {
        isShow = NO;
        moreTitle = @"显示更多";
    }else{
        isShow = YES;
        moreTitle = @"收起";
    }
    [self.tableView reloadData];
}




-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_dataSource removeAllObjects];//删除所有数据
    [self loadData];//重新读取数据
}

-(void)sendTextAction:(NSString *)inputText{
    
    NSURL *url = [NSURL URLWithString:[RequestLinkUtil getUrlByKey:COMMENT_CREATE]];
    ASIFormDataRequest *commentCreateReq = [ASIFormDataRequest requestWithURL:url];
    [commentCreateReq setPostValue:inputText forKey:@"frf.MsgComment.content"];//
    [commentCreateReq setPostValue:@"0" forKey:@"frf.MsgComment.isStick"];//
    [commentCreateReq setPostValue:topicVO.topicId forKey:@"frf.MsgComment.msgId"];//
    [commentCreateReq setPostValue:@"0" forKey:@"frf.MsgComment.status"];//
    [commentCreateReq setPostValue:[DataCenter sharedInstance].userVO.userId forKey:@"frf.MsgComment.author.uuid"];//
    [commentCreateReq setCompletionBlock:^{
//        NSLog(@"result:%@",commentCreateReq.responseString);
        [_dataSource removeAllObjects];//删除所有数据
        pageNo = 1;
        [self loadData];//重新读取数据
        [commentHeaderView updateComments];
    }];
    [commentCreateReq setFailedBlock:^{
        //        NSError *error = [praisesReq error];
    }];
    [commentCreateReq startAsynchronous];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark -
#pragma mark overide UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSource?1:0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource?_dataSource.count:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CommentCell alloc] initWithCommentVO:[_dataSource objectAtIndex:[indexPath row]] isShow:isShow];
    
        [cell.showMoreBtn setTitle:moreTitle forState:UIControlStateNormal];
        [cell.showMoreBtn.param setValue:indexPath forKey:@"indexPath"];
        [cell.showMoreBtn addTarget:self action:@selector(showMoreByComment:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    commentHeaderView = (CommentHeaderView *)tableView.tableHeaderView;
//    return commentHeaderView.frame.size.height;
//}

#pragma mark-
#pragma mark overide methods
-(void)beginToReloadData:(EGORefreshPos)aRefreshPos{
	[super beginToReloadData:aRefreshPos];
    [self loadMoreData];
}

//上拉加载更多
-(void)loadMoreData{
    pageNo++;
    [self loadData];
}

-(void)loadData{
    //发送评论列表请求
    ASIFormDataRequest *commentListReq=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:[RequestLinkUtil getUrlByKey:COMMENT_LIST]]];
    [commentListReq setPostValue:topicVO.topicId forKey:@"frf.MsgComment.p.msgId"];//
    [commentListReq setPostValue:[NSString stringWithFormat:@"%d",pageNo] forKey:@"pageNo"];//
    [commentListReq setDelegate:self];
    [commentListReq setDidFinishSelector:@selector(commentListSuccess:)];
    [commentListReq setDidFailSelector:@selector(requestError:)];
    [commentListReq startAsynchronous];
}

//#pragma mark  -------评论发布请求回调----------
//-(void)createCommentSuccess:(ASIFormDataRequest*)request{
//    NSLog(@"result:%@",request.responseString);
//    [_dataSource removeAllObjects];//删除所有数据
//    pageNo = 1;
//    [self loadData];//重新读取数据
//    commentHeaderView.commentsLab.text = [NSString stringWithFormat:@"评论(%d)",(comments+1)];
//}

#pragma mark  -------评论列表请求回调----------
-(void)commentListSuccess:(ASIFormDataRequest*)request{
    NSLog(@"result:%@",request.responseString);
    NSString *respString = request.responseString;
    

    if ([respString JSONValue]) {
        NSArray *reqArray = [[respString JSONValue] objectForKey:@"result"];
        CommentVO *commentVO;
        for (NSDictionary *commentDict in reqArray) {

            NSDictionary *authorDict = [commentDict objectForKey:@"author"];//用户信息
            NSDictionary *userPersonalityDict = [[authorDict objectForKey:@"userPersonality"] objectAtIndex:0];//用户个性化设置信息
            
            commentVO = [[CommentVO alloc] initWityCommentId:[commentDict objectForKey:@"uuid"]
                                                      userId:[authorDict objectForKey:@"uuid"]
                                                      avatar:[userPersonalityDict objectForKey:@"avatar"]
                                                    nickName:[userPersonalityDict objectForKey:@"nickName"]
                                                   signature:[userPersonalityDict objectForKey:@"signature"]
                                                       msgId:topicVO.topicId
                                                     content:[commentDict objectForKey:@"content"]
                                                      status:[commentDict objectForKey:@"status"]
                                                  createTime:[commentDict objectForKey:@"createTime"]
                                                  modifyTime:[commentDict objectForKey:@"modifyTime"]];
            
            [_dataSource addObject:commentVO];
            //排序按照时间
            [_dataSource sortUsingComparator: ^(CommentVO *s1, CommentVO *s2){
                return [s2.createTime compare:s1.createTime];
            }];

            
        }
    }
    else{
        UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"邻居说" message:@"评论信息读取失败" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [av show];
        
    }
    [self.tableView reloadData];
    [self finishReloadingData];//完成下拉更新
    if (totalPageCount - pageNo > 0) {//如果当前页数不是最后一页
        [self setFooterView];
    }
}

#pragma mark  -------请求错误--------
- (void)requestError:(ASIFormDataRequest*)request{
     UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"梧桐邑" message:@"服务器异常" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
    [av show];
}




@end