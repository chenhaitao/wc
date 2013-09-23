//
//  ShieldingCell.h
//  WuTongCity
//
//  Created by alan  on 13-9-13.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserVO.h"
#import "ParamButton.h"

@interface ShieldingCell : UITableViewCell

@property (strong, nonatomic)ParamButton *shieldingBtn;

- (id)initWithUserVO:(UserVO *) userVO;

@end
