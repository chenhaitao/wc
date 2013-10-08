

#import "ChatMessageController.h"
//#import "WCSendMessageController.h"
#import "ChatSendMsgViewController.h"
#import "ChatMessageCell.h"

//@interface ChatViewController (Private)
//-(void)initTableViewWithRect:(CGRect)aRect;
//
//@end

@implementation ChatMessageController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view from its nib.
    [self.navigationItem setTitle:@"聊天"];
    
    _messageTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 392) style:UITableViewStylePlain];
    _messageTable.dataSource = self;
    _messageTable.delegate = self;
    [_messageTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_messageTable];
    
 
//    WCXMPPManager *xmppManager= [WCXMPPManager sharedInstance];//初始化WcxmppManager
//    [xmppManager goOnline];//设置上线
    //接受新消息广播,并刷新tableview
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(newMsgCome:) name:MESSAGE_NOTIFACTION object:nil];

    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refresh];//获取最近联系人,并刷新tableview
    [_messageTable reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark   ---------tableView协议----------------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _msgArr.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier=@"messageCell";
    ChatMessageCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[[ChatMessageCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    WCMessageUserUnionObject *unionObject=[_msgArr objectAtIndex:indexPath.row];
    [cell setUnionObject:unionObject];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatSendMsgViewController *sendView=[[ChatSendMsgViewController alloc]init];
    
    WCMessageUserUnionObject *unionObj=[_msgArr objectAtIndex:indexPath.row];
    
    [sendView setChatPerson:unionObj.user];
    [sendView setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:sendView animated:YES];
    
    
}



#pragma mark  接受新消息广播
-(void)newMsgCome:(NSNotification *)notifacation
{
//    NSLog(@"%d",self.tabBarController )
//    UIViewController *tController = [self.tabBarController.viewControllers objectAtIndex:3];
//    int badgeValue = 2;
//    tController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",badgeValue+1];
//    
    [self.navigationController.tabBarItem setBadgeValue:@""];
//    NSLog(@"%@",notifacation.object);
    
//    [WCMessageObject save:notifacation.object];
    
    if ( [notifacation.object messageFrom] == nil) {
        return;
    }

    [self refresh];
}

//最近联系人
-(void)refresh{
    
    //去除角标
    [self.navigationController.tabBarItem setBadgeValue:nil];
    
    _msgArr=[WCMessageObject fetchRecentChatByPage:1];
    [_messageTable reloadData];
}


@end

