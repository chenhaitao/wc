//
//  PhotoView+SDWebImage.h
//  WuTongCity
//
//  Created by alan  on 13-9-11.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "KTPhotoView.h"
#import "SDWebImageManagerDelegate.h"

@interface KTPhotoView (SDWebImage) <SDWebImageManagerDelegate>

- (void)setImageWithURL:(NSURL *)url;
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;

@end
