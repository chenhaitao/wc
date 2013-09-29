//
//  WCXMPPManager.m
//  WeChat
//
//  Created by Reese on 13-8-10.
//  Copyright (c) 2013年 Reese. All rights reserved.
//
// Log levels: off, error, warn, info, verbose

#import "XMPPManager.h"
#import "GCDAsyncSocket.h"
#import "XMPP.h"
#import "XMPPReconnect.h"
#import "XMPPCapabilities.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "XMPPRoster.h"
#import "DataCenter.h"
#import "User.h"
#import "RequestLinkUtil.h"

#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_INFO;
#endif




#define DOCUMENT_PATH NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]
#define CACHES_PATH NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]

@implementation XMPPManager
static XMPPManager *sharedManager;

+(XMPPManager*)sharedInstance{
    if (sharedManager == nil ) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedManager=[[XMPPManager alloc]init];
            [DDLog addLogger:[DDTTYLogger sharedInstance]];
            
            [sharedManager setupStream];
            
        });
    }
    return sharedManager;
}


- (void)dealloc
{
    //    [super dealloc];
	[self teardownStream];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma  mark ------收发消息-------
- (void)sendMessage:(XMPPMessage *)aMessage
{
    [xmppStream sendElement:aMessage];
    NSString *body = [[aMessage elementForName:@"body"] stringValue];
    NSString *meesgageTo = [[aMessage to]bare];
    NSArray *strs=[meesgageTo componentsSeparatedByString:@"@"];
    
    //创建message对象
    WCMessageObject *msg=[[WCMessageObject alloc]init];
    [msg setMessageDate:[NSDate date]];
    [msg setMessageFrom:[DataCenter sharedInstance].userVO.userId];
    [msg setMessageContent:body];
    [msg setMessageTo:strs[0]];
    [msg setMessageType:[NSNumber numberWithInt:kWCMessageTypePlain]];
    [WCMessageObject save:msg];
    //发送全局通知
    //    [[NSNotificationCenter defaultCenter]postNotificationName:kXMPPNewMsgNotifaction object:msg ];
    //    [msg release];
}



#pragma mark --------配置XML流---------
- (void)setupStream
{
	NSAssert(xmppStream == nil, @"Method setupStream invoked multiple times");
	
    
	xmppStream = [[XMPPStream alloc] init];
	
#if !TARGET_IPHONE_SIMULATOR
	{
        xmppStream.enableBackgroundingOnSocket = YES;
	}
#endif
	
	
	
	xmppReconnect = [[XMPPReconnect alloc] init];
	

    xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
	
	xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:xmppRosterStorage];
	
	xmppRoster.autoFetchRoster = YES;
	xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
    
	[xmppReconnect         activate:xmppStream];
    [xmppRoster            activate:xmppStream];
    
	// Add ourself as a delegate to anything we may be interested in
    
	[xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
	
	// Optional:
	//
	// Replace me with the proper domain and port.
	// The example below is setup for a typical google talk account.
	//
	// If you don't supply a hostName, then it will be automatically resolved using the JID (below).
	// For example, if you supply a JID like 'user@quack.com/rsrc'
	// then the xmpp framework will follow the xmpp specification, and do a SRV lookup for quack.com.
	//
	// If you don't specify a hostPort, then the default (5222) will be used.
	
	[xmppStream setHostName:HOST_NAME];
	[xmppStream setHostPort:5222];
	
    
    
    
	// You may need to alter these settings depending on the server you're connecting to
	allowSelfSignedCertificates = NO;
	allowSSLHostNameMismatch = NO;
    
    

}

- (void)teardownStream
{
	[xmppStream removeDelegate:self];
	
	[xmppReconnect         deactivate];
	
	[xmppStream disconnect];
	
	xmppStream = nil;
	xmppReconnect = nil;
}

// It's easy to create XML elments to send and to read received XML elements.
// You have the entire NSXMLElement and NSXMLNode API's.
//
// In addition to this, the NSXMLElement+XMPP category provides some very handy methods for working with XMPP.
//
// On the iPhone, Apple chose not to include the full NSXML suite.
// No problem - we use the KissXML library as a drop in replacement.
//
// For more information on working with XML elements, see the Wiki article:
// http://code.google.com/p/xmppframework/wiki/WorkingWithElements

- (void)goOnline
{
	XMPPPresence *presence = [XMPPPresence presence]; // type="available" is implicit
	
	[xmppStream sendElement:presence];
}

- (void)goOffline
{
	XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
	
	[xmppStream sendElement:presence];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Connect/disconnect
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)connect{
	if (![xmppStream isDisconnected])
        return YES;
    
	NSString *myJID = [DataCenter sharedInstance].userVO.userId;
	if (myJID == nil) return NO;
    
    
    
    
//    [xmppStream setMyJID:[XMPPJID jidWithUser:myJID domain:DOMAIN_NAME resource:@"wutongyi"]];
    
    [xmppStream setMyJID:[XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",[DataCenter sharedInstance].userVO.userId,HOST_NAME]]];
    
	NSError *error = nil;
	if (![xmppStream connectWithTimeout:10 error:&error]){
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"服务器异常"
		                                                    message:@"服务器异常"
		                                                   delegate:nil
		                                          cancelButtonTitle:@"Ok"
		                                          otherButtonTitles:nil];
		[alertView show];
		return NO;
	}
    
	return YES;
}

- (void)disconnect{
    
	[self goOffline];
	[xmppStream disconnect];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UIApplicationDelegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store
	// enough application state information to restore your application to its current state in case
	// it is terminated later.
	//
	// If your application supports background execution,
	// called instead of applicationWillTerminate: when the user quits.
	
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
#if TARGET_IPHONE_SIMULATOR
	DDLogError(@"The iPhone simulator does not process background network traffic. "
			   @"Inbound traffic is queued until the keepAliveTimeout:handler: fires.");
#endif
    
	if ([application respondsToSelector:@selector(setKeepAliveTimeout:handler:)])
	{
		[application setKeepAliveTimeout:600 handler:^{
			
			DDLogVerbose(@"KeepAliveHandler");
			
			// Do other keep alive stuff here.
		}];
	}
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (NSManagedObjectContext *)managedObjectContext_roster
{
	return [xmppRosterStorage mainThreadManagedObjectContext];
}
// Returns the URL to the application's Documents directory.

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPStream Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	if (allowSelfSignedCertificates)
	{
		[settings setObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCFStreamSSLAllowsAnyRoot];
	}
	
	if (allowSSLHostNameMismatch)
	{
		[settings setObject:[NSNull null] forKey:(NSString *)kCFStreamSSLPeerName];
	}
	else
	{
		// Google does things incorrectly (does not conform to RFC).
		// Because so many people ask questions about this (assume xmpp framework is broken),
		// I've explicitly added code that shows how other xmpp clients "do the right thing"
		// when connecting to a google server (gmail, or google apps for domains).
		
		NSString *expectedCertName = nil;
		
		NSString *serverDomain = xmppStream.hostName;
		NSString *virtualDomain = [xmppStream.myJID domain];
		
		if ([serverDomain isEqualToString:@"talk.google.com"])
		{
			if ([virtualDomain isEqualToString:@"gmail.com"])
			{
				expectedCertName = virtualDomain;
			}
			else
			{
				expectedCertName = serverDomain;
			}
		}
		else if (serverDomain == nil)
		{
			expectedCertName = virtualDomain;
		}
		else
		{
			expectedCertName = serverDomain;
		}
		
		if (expectedCertName)
		{
			[settings setObject:expectedCertName forKey:(NSString *)kCFStreamSSLPeerName];
		}
	}
}

- (void)xmppStreamDidSecure:(XMPPStream *)sender
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

//登录密码认证/注册密码
- (void)xmppStreamDidConnect:(XMPPStream *)sender{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	NSError *error = nil;
    NSString *password = [[NSUserDefaults standardUserDefaults] stringForKey:LOGIN_PASSWORD];
    //登录
    if (self.isLoginOperation) {
        if (![xmppStream authenticateWithPassword:password error:&error]){
            DDLogError(@"Error authenticating: %@", error);
        }
    }else{//注册
        if (![xmppStream registerWithPassword:password error:&error]) {
            DDLogError(@"Error register: %@", error);
        }
    }
}
//登录验证密码成功
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	[self goOnline];
    [xmppRoster fetchRoster];
}
//登录验证密码失败
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

//注册验证密码成功
- (void)xmppStreamDidRegister:(XMPPStream *)sender{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    //    registerSuccess = YES;
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"创建帐号成功"
//                                                        message:@""
//                                                       delegate:self
//                                              cancelButtonTitle:@"Ok"
//                                              otherButtonTitles:nil];
//    [alertView show];
}
//注册验证密码失败
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"创建帐号失败"
                                                        message:@"用户名冲突"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
}


- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
	DDLogVerbose(@"%@: %@ - %@", THIS_FILE, THIS_METHOD, [iq elementID]);
	
	return NO;
}


//收到消息
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    NSString *body = [[message elementForName:@"body"] stringValue];
    NSString *displayName = [[message from]bare];
    
    
//    [[[UIAlertView alloc]initWithTitle:@"收到新消息" message:body delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil]show];
    
    
    //创建message对象
    WCMessageObject *msg=[WCMessageObject messageWithType:kWCMessageTypePlain];
    NSArray *strs=[displayName componentsSeparatedByString:@"@"];
    [msg setMessageDate:[NSDate date]];
    [msg setMessageFrom:strs[0]];
    [msg setMessageContent:body];
    [msg setMessageTo:[DataCenter sharedInstance].userVO.userId];
    [msg setMessageType:[NSNumber numberWithInt:kWCMessageTypePlain]];
    [WCMessageObject save:msg];
    if (![WCUserObject haveSaveUserById:strs[0]]) {
        [self fetchUser:strs[0]];
    }
    
    
    
//    if([[UIApplication sharedApplication] applicationState] != UIApplicationStateActive)
//    {
//        // We are not active, so use a local notification instead
//        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
//        localNotification.alertAction = @"Ok";
//        localNotification.alertBody = [NSString stringWithFormat:@"From: %@\n\n%@",@"消息:",@"123"];
//        
//        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
//    }
	
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
	DDLogVerbose(@"%@: %@ - %@", THIS_FILE, THIS_METHOD, [presence fromStr]);
}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(id)error
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}


//创建聊天房间
-(void) createRoom{
    
    //创建一个新的群聊房间,roomName是房间名 fullName是房间里自己所用的昵称
    NSString *jidRoom = [NSString stringWithFormat:@"%@@conference.siteviewwzp", @"apple"];
    XMPPJID *jid = [XMPPJID jidWithString:jidRoom];
    
    XMPPRoomCoreDataStorage *roomstorage = [[XMPPRoomCoreDataStorage alloc] init];
    XMPPRoom *room = [[XMPPRoom alloc] initWithRoomStorage:roomstorage jid:jid dispatchQueue:dispatch_get_main_queue()];
    
    
    [room activate:xmppStream];
    
    [room joinRoomUsingNickname:@"alan" history:nil];
    
    [room addDelegate:self delegateQueue:dispatch_get_main_queue()];

}

//Jid roomJid = new Jid("roomName","domain.com");
///// <summary>
///// 查询聊天室内成员
///// </summary>
//-(void) QueryMembers(){
//    DiscoItemsIq discoItemIq = new DiscoItemsIq(IqType.get)
//    discoItemIq.To = roomJid;
//    xmppConnection.IqGrabber.SendIq(discoItemIq , new IqCB(QueryIqHandler), null);
//}
//
//// <summary>
///// 处理查询结果
///// </summary>
///// <param name="sender"></param>
///// <param name="iq"></param>
///// <param name="data"></param>
//-(void) QueryIqHandler(object sender ,IQ iq, object data){
//    if(iq.Type == IqType.result){
//        DiscoItems items = iq.SelectSingleElement<DiscoItems>();
//        foreach(DiscoItem item in items.GetDiscoItems()){
//            //roomJid = item.Jid.Bare;
//            //memberNick = item.Jid.Resource;
//            //other process...      
//        }
//    }
//}

//用XMPPRoom来实现。具体代码如下:
////创建一个新的群聊房间,roomName是房间名 fullName是房间里自己所用的昵称
//XMPPRoom*room =[[XMPPRoom alloc] initWithStream:xmppStream roomName:roomName nickName:fullName];
//self.chatRoom = room;[room release];
////设置代理
//[room setDelegate:self];
////创建
//[room createOrJoinRoom];
////加入房间，它会用xmppstream中的jid来加入
//[room joinRoom];
//创建完后，xmpproom会通知它的delegate,在这里是self.因此需要在self中再加入下面protocal函数:
//#pragma mark -#pragma mark chatRoom
////创建结果
//-(void)xmppRoom:(XMPPRoom*)room didCreate:(BOOL)success{
//	if(success)
//		NSLog(@"create success");
//	else{
//		NSLog(@"create failure");
//	}
//}
////是否已经加入房间
//-(void)xmppRoom:(XMPPRoom*)room didEnter:(BOOL)enter{
//	NSLog(@"%@",@"didEnter");
//}
////是否已经离开
//-(void)xmppRoom:(XMPPRoom*)room didLeave:(BOOL)leave{
//	NSLog(@"%@",@"didLeave");
//}
////收到群聊消息
//-(void)xmppRoom:(XMPPRoom*)room didReceiveMessage:(NSString*)message fromNick:(NSString*)nick{
//	NSLog(@"xmppRoom:didReceiveMessage:%@",message);
//}
////房间人员列表发生变化
//-(void)xmppRoom:(XMPPRoom*)room didChangeOccupants:(NSDictionary*)occupants{
//	NSLog(@"%@",@"didChangeOccupants");
//}
//当房间创建成功，或收到消息时，就会调用这些protocal，函数中需要加入自己的实现代码逻辑。




////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPRosterDelegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
    
    XMPPJID *jid=[XMPPJID jidWithString:[presence stringValue]];
    [xmppRoster acceptPresenceSubscriptionRequestFrom:jid andAddToRoster:YES];
}

- (void)addSomeBody:(NSString *)userId
{
    [xmppRoster subscribePresenceToUser:[XMPPJID jidWithString:[NSString stringWithFormat:@"%@@zhoutong",userId]]];
}

//通过发送消息用户的uuid查询用户信息,并保存在本地数据库
-(void)fetchUser:(NSString*)uuid{
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:[RequestLinkUtil getUrlByKey:USER_LOAD]]];
    [request setPostValue:uuid forKey:@"userId"];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(requestSuccess:)];
    [request setDidFailSelector:@selector(requestError:)];
    [request startAsynchronous];
}
-(void)requestSuccess:(ASIFormDataRequest*)request{
    NSLog(@"response:%@",request.responseString);
//    SBJsonParser *paser=[[SBJsonParser alloc]init];
    if (request.responseString) {
        NSDictionary *dict=[[[request.responseString JSONValue] objectForKey:@"result"] objectAtIndex:0];
        NSLog(@"%@",[dict objectForKey:@"uuid"]);
        NSLog(@"%@",[dict objectForKey:@"realName"]);
       
        
        NSDictionary *userDict = [[NSDictionary alloc] initWithObjectsAndKeys:[dict objectForKey:@"uuid"],@"userId",
                                                                             [dict objectForKey:@"realName"],@"userNickname",
                                                                             [dict objectForKey:@"realName"],@"userDescription",
                                                                             @"",@"userHead",nil];
        WCUserObject *user=[WCUserObject userFromDictionary:userDict];
        [WCUserObject saveNewUser:user];
    }
    
}
-(void)requestError:(ASIFormDataRequest*)request
{
    
}

@end
