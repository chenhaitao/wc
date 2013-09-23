//
//  UserLocalInfo.h
//  WuTongCity
//
//  Created by alan  on 13-9-18.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserLocalInfo : NSObject<NSCoding>

@property(nonatomic, strong)NSString* loginId;
@property(nonatomic, strong)NSString* password;
@property(nonatomic, strong)NSString* villageId;
@property(nonatomic, strong)NSString* userId;
@property(nonatomic, strong)NSString* avatar;
@property(nonatomic, strong)NSString* nickName;
@property(nonatomic, strong)NSDate* loginTime;


@end