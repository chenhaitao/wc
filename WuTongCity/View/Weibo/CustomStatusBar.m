//
//  CustomTabbar.m
//  WuTongCity
//
//  Created by 陈 海涛 on 13-9-26.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "CustomStatusBar.h"

@implementation CustomStatusBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect frame = [UIApplication sharedApplication].statusBarFrame;
        frame.origin.y = -20;
        self.frame = frame;
        self.windowLevel = UIWindowLevelStatusBar + 1;
        self.backgroundColor = [UIColor grayColor];
        self.hidden = NO;
        
        self.messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.messageButton.frame = CGRectMake(0, 0, 320, 20);
        [self addSubview:self.messageButton];
        self.messageButton.backgroundColor = [UIColor   clearColor];
        [self.messageButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        self.messageButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [self.messageButton addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(action) name:@"loginOut" object:nil];
    }
    return self;
}

- (void)action
{
    [self hiddenMessage];
}

- (void)clickAction
{
    [self hiddenMessage];
}

- (void)showMessage
{
    if (self.frame.origin.y  > -5  ) {
        return;
    }
    [UIView animateWithDuration:1 animations:^{
         self.transform = CGAffineTransformMakeTranslation(0, 22);
    } completion:^(BOOL finished) {
        [UIView  animateWithDuration:0.3 animations:^{
            self.transform = CGAffineTransformTranslate(self.transform, 0, -2);
        }];
    }];
    
}


- (void)hiddenMessage
{
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformIdentity;
        
    }];
}


@end












