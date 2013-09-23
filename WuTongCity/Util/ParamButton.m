//
//  ParamButton.m
//  WuTongCity
//
//  Created by alan  on 13-8-21.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "ParamButton.h"

@implementation ParamButton
@synthesize param;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.param = [[NSMutableDictionary alloc]init];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
