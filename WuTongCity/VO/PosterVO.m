//
//  PosterVO.m
//  WuTongCity
//
//  Created by alan  on 13-9-13.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "PosterVO.h"

@implementation PosterVO

@synthesize uuid;
@synthesize title;//标题
@synthesize link;
@synthesize content;
@synthesize location;//放置位置
@synthesize scope;//广告范围
@synthesize sortNo;//序号
@synthesize imageName;

-(id)initWithDict:(NSDictionary *)_dict{
    if (self = [super init]) {
        self.uuid = [_dict objectForKey:@"uuid"];
        self.title = [_dict objectForKey:@"title"];
        self.link = [_dict objectForKey:@"link"];
        self.content = [_dict objectForKey:@"content"];
        self.location = [_dict objectForKey:@"location"];
        self.scope = [_dict objectForKey:@"scope"];
        self.sortNo = [_dict objectForKey:@"sortNo"];
        self.imageName = [_dict objectForKey:@"imageId"];
    }
    return self;
}

@end
