//
//  DateUtil.m
//  WuTongCity
//
//  Created by alan  on 13-8-18.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "DateUtil.h"

@implementation DateUtil

//YYYY年MM月d日
+ (NSDate *)dateFromString:(NSString *)dateString format:(NSString *)_format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (_format !=nil) {
        [dateFormatter setDateFormat: _format];
    }
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}

//YYYY年MM月d日
+ (NSString *)StringFromString:(NSString *)dateString format:(NSString *)_format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: _format];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return [dateFormatter stringFromDate:destDate];
}

+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)_format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:_format];
    return [dateFormatter stringFromDate:date];
}

+ (NSDate *)dateFromString:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}

+(NSString *) dateDifference:(NSString *)_dateString{
    //将传入时间转化成需要的格式
    NSDate *fromdate = [self dateFromString:_dateString format:@"yyyy-MM-dd HH:mm:ss"];

    NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
    NSInteger frominterval = [fromzone secondsFromGMTForDate: fromdate];
    NSDate *fromDate = [fromdate  dateByAddingTimeInterval: frominterval];
  
    //获取当前时间
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];

    
    
    double intervalTime = [localeDate timeIntervalSinceReferenceDate] - [fromDate timeIntervalSinceReferenceDate];
    
    long lTime = (long)intervalTime;
    NSInteger seconds = lTime % 60;
    NSInteger minutes = (lTime / 60) % 60;
    NSInteger hours = (lTime / 3600);
    NSInteger days = lTime/60/60/24;
    NSInteger month = lTime/60/60/24/12;
    NSInteger years = lTime/60/60/24/384;
    
    if (years > 0) {
        return [NSString stringWithFormat:@"%d年",years];
    }else if (month > 0){
        return [NSString stringWithFormat:@"%d月",month];
    }else if (days > 0){
        return [NSString stringWithFormat:@"%d天",days];
    }else if (hours > 0){
        return [NSString stringWithFormat:@"%d小时",hours];
    }else if (minutes > 0){
        return [NSString stringWithFormat:@"%d分钟",minutes];
    }else{
        return [NSString stringWithFormat:@"%d秒",seconds];
    }
}

@end
