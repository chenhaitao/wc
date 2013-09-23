//
//  EditUserJobViewController.h
//  WuTongCity
//
//  Created by alan  on 13-8-13.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditUserJobViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate>{
    UITableView *editUserJobTableView;
    UITextField *userJobTextField;
    
}

@property (strong,nonatomic) UserVO *userVO;
@property (strong, nonatomic) NSMutableArray *jobArray;


- (id)initWithUserVO:(UserVO *)_userVO;

@end
