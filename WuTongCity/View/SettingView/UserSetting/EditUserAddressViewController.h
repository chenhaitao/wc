//
//  EditUserAddressViewController.h
//  WuTongCity
//
//  Created by alan  on 13-8-13.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditUserAddressViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate,UIAlertViewDelegate,MBProgressHUDDelegate>{
    UITableView *editUserAddressTableView;
    UITextField *userAddressTextField;
    
    NSMutableArray *userAddressArray;
    MBProgressHUD *HUD;
}

@property (strong,nonatomic) NSString *userAddress;


@end
