//
//  NeighbourDetailCell.m
//  WuTongCity
//
//  Created by alan  on 13-8-14.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "NeighbourDetailCell.h"

@implementation NeighbourDetailCell
@synthesize titleLab, contentLab;
- (id)initWithTitle:(NSString *) _title content:(NSString *)_content mark:(NSString *)_mark;{
    self = [super init];
    if (self) {
        //标题
        self.titleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 80, 30)];
        [self.titleLab setText:_title];
        [self.titleLab setFont:[UIFont systemFontOfSize:14]];
        [self.titleLab setTextColor:[UIColor blackColor]];
        [self.titleLab setBackgroundColor:[UIColor clearColor]];
        self.titleLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.titleLab];
        
        //内容
        if ([_title isEqualToString:SEX]) {
            if ([_content isEqualToString:MALE_VALUE]) {
                _content = MALE;
            }else if([_content isEqualToString:FEMALE_VALUE]){
                _content = FEMALE;
            }
        }
        self.contentLab = [[UILabel alloc]initWithFrame:CGRectMake(90, 10, 180, 30)];
        if ([_mark isEqualToString:@"0"]) //表示公开
        {
            [self.contentLab setText:_content];
        }
        [self.contentLab setFont:[UIFont systemFontOfSize:14]];
        [self.contentLab setTextColor:[UIColor blackColor]];
        [self.contentLab setBackgroundColor:[UIColor clearColor]];
        self.contentLab.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.contentLab];
        //点击cell不变蓝
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
