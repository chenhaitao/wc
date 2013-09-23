//
//  WutongCityAppDelegate.h
//  WutongCity
//
//  Created by alan  on 13-7-7.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    Reachability  *hostReach;
}

@property (strong, nonatomic) UIWindow *window;

@end
