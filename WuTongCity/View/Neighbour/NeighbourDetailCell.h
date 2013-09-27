//
//  NeighbourDetailCell.h
//  WuTongCity
//
//  Created by alan  on 13-8-14.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NeighbourDetailCell : UITableViewCell

@property (strong, nonatomic)UILabel *titleLab;//标题
@property (strong, nonatomic)UILabel *contentLab;//内容

- (id)initWithTitle:(NSString *) _title content:(NSString *)_content mark:(NSString *)_mark;

@end
