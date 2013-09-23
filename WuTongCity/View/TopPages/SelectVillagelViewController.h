//
//  SelectVillagelViewController.h
//  WuTongCity
//
//  Created by alan  on 13-7-29.
//  Copyright (c) 2013年 alan. All rights reserved.
//


@interface SelectVillagelViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UITextFieldDelegate,MBProgressHUDDelegate>{
    MBProgressHUD *HUD;//透明遮盖层
    UITableView *villageTableView;//小区列表
    UIButton *coverLayer;//搜索遮盖层
    NSMutableDictionary *villageDict;//小区信息字典
    NSMutableDictionary *basicVillageDict;//小区信息字典
    UISearchBar *villageSearchBar;//搜索栏
}

//搜索查询
- (void)updateSearchString:(NSString*)aSearchString;

@end
