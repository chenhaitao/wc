//
//  CommentViewController.h
//  WuTongCity
//
//  Created by alan  on 13-8-21.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableFooterToLoadView.h"
#import "TopicVO.h"
#import "FaceToolBar.h"
#import "CommentHeaderView.h"

@interface CommentViewController:TableFooterToLoadView <FaceToolBarDelegate>{
	NSMutableArray *_dataSource;
    
    TopicVO *topicVO;//父blog
    
    int pageNo;//第几页
    int totalPageCount;//总页数
    CommentHeaderView *commentHeaderView;
    
    int comments;//评论数
    NSString *moreTitle;//显示更多标题
    BOOL isShow;
    
}


-(id)initWithTopic:(TopicVO *)_topicVO;

@end