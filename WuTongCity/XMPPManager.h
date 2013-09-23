//
//  WCXMPPManager.h
//  WeChat
//
//  Created by Reese on 13-8-10.
//  Copyright (c) 2013年 Reese. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "XMPPFramework.h"


@class XMPPMessage;
@interface XMPPManager : NSObject <UIApplicationDelegate>{
    XMPPStream *xmppStream;
	XMPPReconnect *xmppReconnect;
    XMPPRoster *xmppRoster;
    XMPPRosterCoreDataStorage *xmppRosterStorage;
    
	
	BOOL allowSelfSignedCertificates;
	BOOL allowSSLHostNameMismatch;
	
//	BOOL isXmppConnected;
}

@property (assign, nonatomic) BOOL isLoginOperation;//登录/注册
@property (readonly, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
- (NSManagedObjectContext *)managedObjectContext_roster;
- (NSURL *)applicationDocumentsDirectory;

- (BOOL)connect;
- (void)disconnect;




+(XMPPManager*)sharedInstance;

-(void) createRoom;


#pragma mark -------配置XML流-----------

- (void)setupStream;
- (void)teardownStream;


#pragma mark ----------收发信息------------
- (void)goOnline;
- (void)goOffline;

- (void)sendMessage:(XMPPMessage *)aMessage;
- (void)addSomeBody:(NSString *)userId;

@end
