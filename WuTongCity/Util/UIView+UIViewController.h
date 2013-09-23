//
//  UIView+UIViewController.h
//  WuTongCity
//
//  Created by alan  on 13-8-19.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIView (FindFirstResponder)
- (BOOL)findFirstResponder;
@end

@interface UIViewController (FindFirstResponder)
- (id)findFirstResponder;
@end