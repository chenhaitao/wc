//
//  UIView+UIViewController.m
//  WuTongCity
//
//  Created by alan  on 13-8-19.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "UIView+UIViewController.h"

@implementation UIView (FindFirstResponder)

- (BOOL)findFirstResponder
{
    if (self.isFirstResponder) {
        return YES;
    }
    
    for (UIView *subView in self.subviews) {
        if ([subView findFirstResponder]) {
            return YES;
        }
    }
    
    return NO;
}

@end

//@implementation UIViewController (FindFirstResponder)
//
//- (id)findFirstResponder
//{
//    if (self.isFirstResponder) {
//        return self;
//    }
//    
//    id firstResponder = [self.view findFirstResponder];
//    if (firstResponder != nil) {
//        return firstResponder;
//    }
//    
//    for (UIViewController *childViewController in self.childViewControllers) {
//        firstResponder = [childViewController findFirstResponder];
//        
//        if (firstResponder != nil) {
//            return firstResponder;
//        }
//    }
//    
//    return nil;
//}

//@end
