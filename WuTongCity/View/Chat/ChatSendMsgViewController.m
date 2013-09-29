//
//  ChatSendMsgViewController.m
//  WuTongCity
//
//  Created by alan  on 13-8-23.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "ChatSendMsgViewController.h"
#import "XMPPMessage.h"
#import "ChatSendMessageCell.h"
//#import "UIImageView+WebCache.h"


@interface ChatSendMsgViewController ()

@end

@implementation ChatSendMsgViewController
-(id)init{
    if (self = [super init]) {
        dataCenter = [DataCenter sharedInstance];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=_chatPerson.userNickname;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(newMsgCome:) name:MESSAGE_NOTIFACTION object:nil];
    
    self.pageNu = 1;
    
    
    msgRecordTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-90) style:UITableViewStylePlain];
    msgRecordTable.dataSource = self;
    msgRecordTable.delegate = self;
    [self.view addSubview:msgRecordTable];
    [msgRecordTable setBackgroundView:nil];
    [msgRecordTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    FaceToolBar* bar=[[FaceToolBar alloc]initWithFrame:CGRectMake(0.0f,self.view.frame.size.height - toolBarHeight,self.view.frame.size.width,toolBarHeight) superView:self.view text:@""];
    bar.delegate=self;
    [self.view addSubview:bar];
    
 
   
 
    
}




- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self refresh];
}

-(void)sendTextAction:(NSString *)inputText{
    NSString *message = inputText;
    if (message.length > 0) {
        //生成消息对象
        
        
        
        
        XMPPMessage *mes=[XMPPMessage messageWithType:@"chat" to:[XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",_chatPerson.userId,HOST_NAME]]];
        [mes addChild:[DDXMLNode elementWithName:@"body" stringValue:message]];
        
        //发送消息
        [[XMPPManager sharedInstance] sendMessage:mes];
    }
    [messageText setText:nil];
    
    
    
    

    
}



- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.y < -60) {
        [self refresh1];
    }
}

-(void)refresh1
{
    if (!self.isLoading) {
        self.isLoading = YES;
        NSMutableArray *array =[WCMessageObject fetchMessageListWithUser:_chatPerson.userId byPage:self.pageNu+1];
        if (array.count!=0) {
           msgRecords = [NSMutableArray arrayWithArray: [array arrayByAddingObjectsFromArray:msgRecords]];
            [msgRecordTable reloadData];
            
            [msgRecordTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:msgRecords.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            
            self.pageNu++;
        }
        
        self.isLoading = NO;
    }
   
    
}
-(void)refresh
{
 
        msgRecords =[WCMessageObject fetchMessageListWithUser:_chatPerson.userId byPage:1];
        if (msgRecords.count!=0) {
            [msgRecordTable reloadData];
            
            [msgRecordTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:msgRecords.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];

        }
        
   
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark   ---------tableView协议----------------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return msgRecords.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier=@"friendCell";
    ChatSendMessageCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[[ChatSendMessageCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    WCMessageObject *msg=[msgRecords objectAtIndex:indexPath.row];
    [cell setMessageObject:msg];
    

    
    enum kWCMessageCellStyle style=[msg.messageFrom isEqualToString:[DataCenter sharedInstance].userVO.userId]?kWCMessageCellStyleMe:kWCMessageCellStyleOther;
    if (style==kWCMessageCellStyleMe) {
        [cell setHeadImageWithName:dataCenter.userVO.avatar];
    }else
    {
        [cell setHeadImageWithName:_chatPerson.userHead];
    }
    [cell setMsgStyle:style];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *orgin=[msgRecords[indexPath.row]messageContent];
    CGSize textSize=[orgin sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake((320-HEAD_SIZE-3*INSETS-40), TEXT_MAX_HEIGHT) lineBreakMode:NSLineBreakByWordWrapping];
    return 55+textSize.height;
}

#pragma mark  接受新消息广播
-(void)newMsgCome:(NSNotification *)notifacation
{
    [self.tabBarController.tabBarItem setBadgeValue:@"1"];
    
    //[WCMessageObject save:notifacation.object];
    
    [self refresh2];
    
}

- (void)refresh2
{
    if (self.view.window != nil) {
        FMDatabase *db=[FMDatabase databaseWithPath:DATABASE_PATH];
        if (![db open]) {
            NSLog(@"数据打开失败");
            return ;
        }
        
        
        //NSString *queryString= [NSString stringWithFormat:@"select * from wcMessage where (messageFrom=? and messageTo=?) or (messageFrom=? and messageTo=?) order by messageDate  Limit %i offset %i",10,pageInde*10 ];
        NSString *queryString= [NSString stringWithFormat:@"select * from wcMessage order by messageDate desc Limit 0 , 1" ];
        NSMutableArray *messageList = [NSMutableArray array];
        NSLog(@"%@",[DataCenter sharedInstance].userVO.userId);
        
        FMResultSet *rs=[db executeQuery:queryString];
        while ([rs next]) {
            WCMessageObject *message=[[WCMessageObject alloc]init];
            [message setMessageId:[rs objectForColumnName:kMESSAGE_ID]];
            [message setMessageContent:[rs stringForColumn:kMESSAGE_CONTENT]];
            [message setMessageDate:[rs dateForColumn:kMESSAGE_DATE]];
            [message setMessageFrom:[rs stringForColumn:kMESSAGE_FROM]];
            [message setMessageTo:[rs stringForColumn:kMESSAGE_TO]];
            [message setMessageType:[rs objectForColumnName:kMESSAGE_TYPE]];
            [ messageList addObject:message];
            
        }
        [msgRecords insertObject:messageList.lastObject atIndex:msgRecords.count - 1];
        [msgRecordTable reloadData];
    }
   
}
@end
