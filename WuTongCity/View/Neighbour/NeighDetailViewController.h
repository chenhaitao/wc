//
//  NeighDetailViewController.h
//  WuTongCity
//
//  Created by alan  on 13-8-14.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserVO.h"

@interface NeighDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    
    UITableView *neighbourDetailTableView;//用户信息列表
    
    UserVO *userVO;
    
    UIButton *stickUserBtn;
    
}
//@property (strong, nonatomic) UserVO *userVO;
@property (strong, nonatomic) NSMutableDictionary *neighbourDict;//邻居信息字典
@property (strong, nonatomic) NSArray *neighbourSectionArray;

-(id)initWithUserVO:(UserVO *)_userVO;


@end
