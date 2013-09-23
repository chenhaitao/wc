//
//  OtherWeiboViewController.m
//  WuTongCity
//
//  Created by alan  on 13-8-22.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "OtherWeiboViewController.h"
#import "OtherTopicCell.h"
#import "OtherHeaderView.h"
#import "DataCenter.h"
#import "CommentViewController.h"
#import "Topic.h"

@interface OtherWeiboViewController ()

@end

@implementation OtherWeiboViewController

-(id)initWithUserVO:(UserVO *)_userVO
{
    self = [super init];
    if (self) {
        pageNo = 1;//设置为第一页
        userVO = _userVO;
        _dataSource = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 10.0, 0);
    
    OtherHeaderView *otherHeaderView = [[OtherHeaderView alloc] initWithFrame:CGRectMake(0, 0, 320, 250) userVO:userVO];
    self.tableView.tableHeaderView = otherHeaderView;
    
    self.tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 44);
    
    moreTitle = @"显示更多";
    isShow = NO;
}

-(void) showMore:(ParamButton *)btn{
    //获取选中删除行索引值
    NSIndexPath *indexPath = [btn.param objectForKey:@"indexPath"];
    OtherTopicCell *cell = (OtherTopicCell *)[self tableView:self.tableView cellForRowAtIndexPath:indexPath];
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
    
    static NSString *CellIdentifier = @"OtherTopicCell";
    
    OtherTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[OtherTopicCell alloc] initWithTopicVO:[_dataSource objectAtIndex:[indexPath row]] isShow:isShow];
        [cell.commentsBtn addTarget:self action:@selector(toCommentPage:) forControlEvents:UIControlEventTouchUpInside];//查看评论
        
        [cell.showMoreBtn setTitle:moreTitle forState:UIControlStateNormal];
        [cell.showMoreBtn.param setValue:indexPath forKey:@"indexPath"];
        [cell.showMoreBtn addTarget:self action:@selector(showMore:) forControlEvents:UIControlEventTouchUpInside];

    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //return 350.0;
    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

-(void)toCommentPage:(ParamButton *)btn{
    //    Topic *topic = [btn.param objectForKey:@"topic"];
    //    //    NSLog(@"去评论%@",uuid);
    //    CommentViewController *commentViewController = [[CommentViewController alloc] initWithTopic:topic];
    //    commentViewController.hidesBottomBarWhenPushed = YES;
    //    [self.navigationController pushViewController:commentViewController animated:YES];
}

#pragma mark-
#pragma mark overide methods
-(void)beginToReloadData:(EGORefreshPos)aRefreshPos{
	[super beginToReloadData:aRefreshPos];
    [self loadMoreData];
    
//    [self performSelector:@selector(testRealLoadMoreData) withObject:nil afterDelay:2.0];
}

//上拉加载更多
-(void)loadMoreData{
    pageNo++;
    [self loadData];
}

-(void)loadData{
    //发送微博列表请求
    ASIFormDataRequest *otherListReq=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:[RequestLinkUtil getUrlByKey:PUBLIC_BLOG_LIST]]];
    [otherListReq setPostValue:[NSString stringWithFormat:@"%d",pageNo] forKey:@"pageNo"];//
    [otherListReq setPostValue:userVO.userId forKey:@"uuid"];
    [otherListReq setDelegate:self];
    [otherListReq setDidFinishSelector:@selector(otherListSuccess:)];
    [otherListReq setDidFailSelector:@selector(responseError:)];
    [otherListReq startAsynchronous];
}

#pragma mark  -------评论列表请求回调----------
-(void)otherListSuccess:(ASIFormDataRequest*)request{
    NSLog(@"blog回调结果:%@",request.responseString);
    NSString *respString = request.responseString;
    if (request.responseString.length > 0) {
        NSArray *reqArray = [[respString JSONValue] objectForKey:@"result"];
        TopicVO *tVO;
        for (NSDictionary *blogDict in reqArray) {
            tVO = [[TopicVO alloc] initTopicVOWithDict:blogDict];
            [_dataSource addObject:tVO];
        }
        //排序按照时间
        [_dataSource sortUsingComparator: ^(TopicVO *s1, TopicVO *s2){
            return [s2.createTime compare:s1.createTime];
        }];
    }else{
        UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"邻居说" message:@"邻居说读取失败" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [av show];
        
    }
    [self.tableView reloadData];
    [self finishReloadingData];//完成下拉更新
    if (totalPageCount - pageNo > 0) {//如果当前页数不是最后一页
        [self setFooterView];
    }


}

#pragma mark  -------请求错误--------
- (void)responseError:(ASIFormDataRequest*)request{
    NSLog(@"%@",[request error]);
    UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"邻居说" message:@"服务器异常" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
    [av show];
}



@end
