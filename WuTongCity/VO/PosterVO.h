//
//  PosterVO.h
//  WuTongCity
//
//  Created by alan  on 13-9-13.
//  Copyright (c) 2013年 alan. All rights reserved.
//


@interface PosterVO : NSObject

@property (strong, nonatomic) NSString *uuid;
@property (strong, nonatomic) NSString *title;//标题
@property (strong, nonatomic) NSString *link;//链接
@property (strong, nonatomic) NSString *content;
@property (assign, nonatomic) int location;//放置位置
@property (assign, nonatomic) int scope;//广告范围
@property (assign, nonatomic) int sortNo;//序号
@property (strong, nonatomic) NSString *imageName;



-(id)initWithDict:(NSDictionary *)_dict;

@end
