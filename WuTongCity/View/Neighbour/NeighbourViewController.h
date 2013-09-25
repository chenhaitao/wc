//
//  NeighbourViewController.h
//  WuTongCity
//
//  Created by alan  on 13-8-14.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NeighDetailViewController.h"

@interface NeighbourViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate, MBProgressHUDDelegate>{
    UITableView *neighbourTableView;//邻居列表
    UISearchBar *neighbourSearchBar;//搜索栏
    UIButton *coverLayer;//遮盖层
    MBProgressHUD *HUD;
    
    NSMutableArray *neighbourArray;
    NSMutableArray *neighbourBasicArray;
}

//@property(strong,nonatomic) NeighDetailViewController *neighDetailViewController;

@property (nonatomic,strong) NSMutableArray *topArray;
@property (nonatomic,strong) NSMutableArray *noTopArray;

@end
