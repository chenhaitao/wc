//
//  SelectResidenceViewController.h
//  WuTongCity
//
//  Created by alan  on 13-9-3.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectResidenceViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UITextFieldDelegate,MBProgressHUDDelegate>{
    MBProgressHUD *HUD;
    UITableView *residenceTableView;
    
    NSMutableArray *residenceArray;
    
    int type;//查找类型
//    NSString *village;
//    NSString * building;
//    NSString *unit;
//    NSString *room;
    
    NSString *residenceUUID;
}


-(id)initWithType:(int)_type;

@end
