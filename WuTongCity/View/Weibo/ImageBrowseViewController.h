//
//  ImageBrowseViewController.h
//  WuTongCity
//
//  Created by alan  on 13-8-18.
//  Copyright (c) 2013年 alan. All rights reserved.
//


@protocol ImageBrowseDelegate;

@interface ImageBrowseViewController : UIViewController <UIScrollViewDelegate> {
	UIImageView *imageView;//全屏图片
    BOOL fullScreen;//是否全屏
    NSString *imageName;//图片名称
}

@property (nonatomic, assign) id <ImageBrowseDelegate> delegate;

- (id)initWithImageName:(NSString *)_imageName;

@end

@protocol ImageBrowseDelegate <NSObject>
- (void)trashWithImageName:(NSString *)_imageName;
//- (void)imageBrowseDidCancel:(ImageBrowseViewController *)imageBrowse;
@end