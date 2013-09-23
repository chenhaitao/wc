//
//  EditSignatureViewController.h
//  WuTongCity
//
//  Created by alan  on 13-8-13.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditSignatureViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, UITextViewDelegate>{
    UITableView *editSignatureTableView;
    UITextView *signatureTextView;

}


@property (strong,nonatomic) NSString *signature;

- (id)initWithSignature:(NSString *)_signature;

@end
