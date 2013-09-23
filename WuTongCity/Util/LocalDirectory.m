//
//  LocalDirectory.m
//  WuTongCity
//
//  Created by alan  on 13-8-18.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "LocalDirectory.h"

@implementation LocalDirectory

//本地imageFile目录
+ (NSString *) imageFileDirectory{
    //设置图片目录-------
    BOOL isDir = NO;
    //获取Documents文件夹目录
    NSArray *path1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [path1 objectAtIndex:0];
    //指定新建文件夹路径
    NSString *imageDocPath = [documentPath stringByAppendingPathComponent:@"imageFile"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:imageDocPath isDirectory:&isDir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:imageDocPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return imageDocPath;
}

@end
