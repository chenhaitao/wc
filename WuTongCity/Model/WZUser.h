//
//  WZUser.h
//  WuTongCity
//
//  Created by 陈 海涛 on 13-9-26.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface WZUser : NSManagedObject

@property (nonatomic, retain) NSString * loginId;
@property (nonatomic, retain) NSDate * loginTime;
@property (nonatomic, retain) NSString * nickName;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString * villageId;
@property (nonatomic, retain) NSNumber * isTempAccount;

@end
