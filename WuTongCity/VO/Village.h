//
//  Village.h
//  WuTongCity
//
//  Created by alan  on 13-8-19.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Village : NSObject

@property (strong, nonatomic) NSString *createTime;//创建时间
@property (strong, nonatomic) NSString *status;//状态
@property (strong, nonatomic) NSString *location;//
@property (strong, nonatomic) NSString *proposerId;
@property (strong, nonatomic) NSString *address;//地址
@property (strong, nonatomic) NSString *permanent;
@property (strong, nonatomic) NSString *description;//描述
@property (strong, nonatomic) NSString *name;//名称
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSString *uuid;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *modifyTime;

-(id)initVillageByUuid:(NSString *)_uuid
                  name:(NSString *)_name
              location:(NSString *)_location
               address:(NSString *)_address
           description:(NSString *)_description
             longitude:(NSString *)_longitude
              latitude:(NSString *)_latitude
             permanent:(NSString *)_permanent
                status:(NSString *)_status
            proposerId:(NSString *)_proposerId
            createTime:(NSString *)_createTime
            modifyTime:(NSString *)_modifyTime;

@end

