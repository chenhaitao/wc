//
//  ParamButton.h
//  WuTongCity
//
//  Created by alan  on 13-8-21.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParamButton : UIButton

@property (strong, nonatomic) NSMutableDictionary *param;

- (id)initWithFrame:(CGRect)frame;

@end
