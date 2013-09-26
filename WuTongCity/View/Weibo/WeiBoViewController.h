//
//  WeiBoViewController.h
//  WuTongCity
//
//  Created by alan  on 13-7-11.
//  Copyright (c) 2013年 alan. All rights reserved.
//


#import "EGORefreshTableView.h"
#import "AdvertisementView.h"
#import "CustomStatusBar.h"


@interface WeiBoViewController : EGORefreshTableView<MBProgressHUDDelegate> {
    NSMutableArray *_dataSource;
    MBProgressHUD *HUD;//透明指示层
    
    int pageNo;//第几页
    int totalPageCount;//总页数
    
    AdvertisementView *advertisementView;//广告view
    
    
    
    ASIFormDataRequest *weiboReq;
    
    NSString *moreTitle;
    
    UIWindow *window;
    
}
@property (nonatomic,strong) CustomStatusBar *customStatusBar;
//
//@property (strong, nonatomic) ParamButton *avatarBtn;//头像按钮
//@property (strong, nonatomic) ParamButton *nickNameBtn;//昵称按钮
//@property (strong, nonatomic) ParamButton *maskUserBtn;//屏蔽此人按钮
//@property (strong, nonatomic) ParamButton *praisesBtn;//赞数量按钮
//@property (strong, nonatomic) ParamButton *commentsBtn;//评论数按钮
//@property (strong, nonatomic) ParamButton *showMoreBtn;//显示更多按钮

-(void) refreshTableView;

@end

