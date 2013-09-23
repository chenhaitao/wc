//
//  OtherWeiboViewController.h
//  WuTongCity
//
//  Created by alan  on 13-8-22.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableFooterToLoadView.h"
#import "TopicVO.h"

@interface OtherWeiboViewController : TableFooterToLoadView{
	NSMutableArray *_dataSource;
    
    UserVO *userVO;//父blog
    NSMutableArray *commentArray;//评论集合
    
    int pageNo;//第几页
    int totalPageCount;//总页数
    
     NSString *moreTitle;
    BOOL isShow;
}

//
-(id)initWithUserVO:(UserVO *)_userVO;
@end
