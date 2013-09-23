//
//  Village.m
//  WuTongCity
//
//  Created by alan  on 13-8-19.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "Village.h"

@implementation Village
@synthesize uuid;
@synthesize name;//名称
@synthesize location;//
@synthesize address;//地址
@synthesize description;//描述
@synthesize longitude;//经度
@synthesize latitude;//维度
@synthesize permanent;//常住人口数量
//@synthesize residences;//住宅单位
@synthesize status;//小区状态
@synthesize proposerId;//物业id;
@synthesize createTime;//创建时间
@synthesize modifyTime;

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
            modifyTime:(NSString *)_modifyTime{
    if (self = [super init]) {
        self.uuid = _uuid;
        self.name = _name;
        self.location = _location;
        self.address = _address;
        self.description = _description;
        self.longitude = _longitude;
        self.latitude = _latitude;
        self.permanent = _permanent;
        self.status = _status;
        self.proposerId = _proposerId;
        self.createTime = _createTime;
        self.modifyTime = _modifyTime;
    }
    return self;
}

@end
