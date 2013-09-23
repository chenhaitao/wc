//
//  EditUserBirthdayViewController.h
//  WuTongCity
//
//  Created by alan  on 13-8-13.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditUserBirthdayViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate>{
    UITableView *editUserBirthdayTableView;
    UITextField *userBirthdayTextField;
    UILabel *userBirthdayLabel;
    
    UIDatePicker *datePicker;
    NSLocale *datelocale;
    
    NSString *tempBirthday;//yyyy-mm-dd
    
}

@property (strong,nonatomic) UserVO *userVO;


- (id)initWithUserVO:(UserVO *)_userVO;

@end
