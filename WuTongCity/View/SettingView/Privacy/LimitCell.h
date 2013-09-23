//
//  LimitCell.h
//  WuTongCity
//
//  Created by alan  on 13-8-27.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserVO.h"
#import "ParamButton.h"

@interface LimitCell : UITableViewCell

@property (strong, nonatomic)ParamButton *limitBtn;

- (id)initWithUserVO:(UserVO *) userVO;

@end
