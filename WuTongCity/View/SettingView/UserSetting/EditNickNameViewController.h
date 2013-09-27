//
//  HahaViewController.h
//  WuTongCity
//
//  Created by alan  on 13-8-11.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataCenter.h"


@interface EditNickNameViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    UITableView *editNickNameTableView;
    UITextField *nickNameTextField;
    
}

//@property(strong,nonatomic)NSArray *settingArray;
@property (strong,nonatomic) NSString *nickName;
@property (assign,nonatomic) int maxWords;


- (id)initWithNickName:(NSString *)_nickName;

@end
