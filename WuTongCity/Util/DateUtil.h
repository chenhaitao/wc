//
//  DateUtil.h
//  WuTongCity
//
//  Created by alan  on 13-8-18.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtil : NSObject

+ (NSDate *)dateFromString:(NSString *)dateString format:(NSString *)_format;
+ (NSString *)StringFromString:(NSString *)dateString format:(NSString *)_format;
+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)_format;

+ (NSDate *)dateFromString:(NSString *)dateString;

//时间差
+(NSString *) dateDifference:(NSString *)_dateString;
@end
