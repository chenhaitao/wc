//
//  EGORefreshTableView.h
//  WuTongCity
//
//  Created by alan  on 13-8-21.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
#import "EGOViewCommon.h"

@interface EGORefreshTableView : UIViewController   <EGORefreshTableDelegate, UITableViewDelegate, UITableViewDataSource>{
	
	EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    
    UITableView *_tableView;
	
	//  Reloading var should really be your tableviews datasource
	//  Putting it here for demo purposes
	BOOL _reloading;
}

@property(nonatomic, retain)UITableView *tableView;

// create/remove footer/header view, reset the position of the footer/header views
-(void)setFooterView;
-(void)removeFooterView;
-(void)createHeaderView;
-(void)removeHeaderView;

// overide methods
-(void)beginToReloadData:(EGORefreshPos)aRefreshPos;
-(void)finishReloadingData;

// force to refresh
-(void)showRefreshHeader:(BOOL)animated;
@end