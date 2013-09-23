//
//  ImageUtil.h
//  WuTongCity
//
//  Created by alan  on 13-8-29.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageUtil : NSObject

//压缩图片
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;

@end
