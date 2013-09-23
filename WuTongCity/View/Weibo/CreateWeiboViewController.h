//
//  CreateWeiboViewController.h
//  WuTongCity
//
//  Created by alan  on 13-8-15.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaceBoard.h"
#import "DataCenter.h"
#import "ImageBrowseViewController.h"
//#define  keyboardHeight 216

@interface CreateWeiboViewController : UIViewController<UITableViewDelegate,UIImagePickerControllerDelegate,UITextViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIActionSheetDelegate, FaceBoardDelegate,ImageBrowseDelegate,MBProgressHUDDelegate>{
    DataCenter *dataCenter;//数据中心
    UITableView *createWeiboTableView;
    UITextView *weiboTextView;//微博文字
    //为使用tableview定义的临时数据
    NSMutableDictionary *tempDict;
    NSArray *tempArray;
    
//    NSMutableDictionary *imgDict;//临时图片字典
//    NSMutableArray *imgKeyArray;//临时图片字典key
    NSMutableArray *imageArray;//临时图片字典key

    BOOL  faceBoardShow;//是否打开表情键盘
    UIButton *faceBtn;//表情功能按钮
    
    FaceBoard *_faceBoard;//表情键盘
    NSString *imagePath;//图片路径
    
    MBProgressHUD *HUD;//透明指示层
    
    ASIFormDataRequest *createWeiboReq;
}


@end
