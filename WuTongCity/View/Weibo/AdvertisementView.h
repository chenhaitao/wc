//
//  AdvertisementView.h
//  WuTongCity
//
//  Created by alan  on 13-8-18.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParamButton.h"
#define SCROLLVIEW_HEIGHT 220
@interface AdvertisementView : UIView<UIScrollViewDelegate>{
    UIScrollView *scrollView;
    NSMutableArray *slideImages;
    UIPageControl *pageControl;
    NSMutableArray *posterArray;
}

@property (strong, nonatomic) ParamButton *avatarBtn;
@property (strong, nonatomic) UILabel *userNameLab;

- (id)initWithFrame:(CGRect)frame;
-(void) updateAvatar;
    
@end
