//
//  CustomTabbar.h
//  WuTongCity
//
//  Created by 陈 海涛 on 13-9-26.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomStatusBar : UIWindow

@property (nonatomic,weak) UIButton *messageButton;

- (void)showMessage;
- (void)hiddenMessage;

@end
