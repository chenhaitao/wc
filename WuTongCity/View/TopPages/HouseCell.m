//
//  houseCell.m
//  WuTongCity
//
//  Created by alan  on 13-7-29.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "HouseCell.h"

@implementation HouseCell

- (id)initWithHouseName:(NSString *)_houseName
{
    self = [super init];
    if (self) {
        
//        [self setBackgroundView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MessageListCellBkg"]]];
    
        UILabel *nameLable=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
        nameLable.textColor = [UIColor blackColor];
        [nameLable setFont:[UIFont systemFontOfSize:18]];
        nameLable.text = _houseName;
        [self.contentView addSubview:nameLable];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    
    
    // Configure the view for the selected state
}

@end
