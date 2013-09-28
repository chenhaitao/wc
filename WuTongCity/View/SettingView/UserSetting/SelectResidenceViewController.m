//
//  SelectResidenceViewController.m
//  WuTongCity
//
//  Created by alan  on 13-9-3.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "SelectResidenceViewController.h"

@interface SelectResidenceViewController ()

@end

@implementation SelectResidenceViewController

-(id)initWithType:(int)_type{
    if (self = [super init]) {
        type = _type;
        residenceArray = [[NSMutableArray alloc] init];
        switch (type) {
            case 1:
                self.navigationItem.title = @"楼栋列表";
                break;
            case 2:
                self.navigationItem.title = @"单元列表";
                break;
            case 3:
                self.navigationItem.title = @"房间列表";
                break;
        }
        
    }
    return self;
}

-(void) getResidence:(int)_type{
    //发起获取小区信息请求
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:[RequestLinkUtil getUrlByKey:RESIDENCE_LOAD]]];
    switch (type) {
        case 1:
            [request setPostValue: [DataCenter sharedInstance].village.uuid forKey:@"villageId"];
            break;
        case 2:
            [request setPostValue:[DataCenter sharedInstance].userVO.building forKey:@"building"];
            break;
        case 3:
            [request setPostValue:[DataCenter sharedInstance].userVO.building forKey:@"building"];
            [request setPostValue:[DataCenter sharedInstance].userVO.unit forKey:@"unit"];
            break;
    }
    [request setDelegate:self];
    [request setCompletionBlock:^{
       
        if ([request.responseString JSONValue]) {
            NSArray *tempArray = [request.responseString JSONValue];
            if (tempArray.count == 0) {
                UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"住宅选择" message:@"住宅信息为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [av show];
            }else{
                residenceArray = [[NSMutableArray alloc] initWithArray:tempArray];
                [residenceTableView reloadData];
            }
            
            
        }else{
            UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"住宅选择" message:@"住宅信息读取失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [av show];
        }
        [HUD hide:YES];
    }];
    [request setFailedBlock:^{
        [HUD hide:YES];
        UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"梧桐邑" message:@"服务器异常" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [av show];
    }];
    [request startAsynchronous];
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.delegate = self;
    [HUD show:YES];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self getResidence:type];
    
    
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    CGRect tableFrame = CGRectMake(0, 0, self.view.bounds.size.width, [UIScreen mainScreen].bounds.size.height - 20 - 44 );
    residenceTableView = [[UITableView alloc]initWithFrame:tableFrame style:UITableViewStylePlain];
    residenceTableView.dataSource = self;
    residenceTableView.delegate = self;
    [self.view addSubview:residenceTableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [residenceArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * tableIdentifier=@"SelectResidenceCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if(cell==nil){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
        NSDictionary *dict = [residenceArray objectAtIndex:[indexPath row]];
//        NSString *residenceId = [dict objectForKey:@"uuid"];
        switch (type) {
            case 1:
                if ([[dict objectForKey:@"building"] isEqualToString:[DataCenter sharedInstance].userVO.building]) {
                    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                }
                cell.textLabel.text = [NSString stringWithFormat:@"%i", [[dict objectForKey:@"building"] intValue] ] ;
                cell.textLabel.textColor = [UIColor blackColor];
                NSLog(@"building:%@",[dict objectForKey:@"building"]);
                break;
            case 2:
                if ([[dict objectForKey:@"unit"] isEqualToString:[DataCenter sharedInstance].userVO.unit]) {
                    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                }
                cell.textLabel.text = [dict objectForKey:@"unit"];
                break;
            case 3:
                if ([[dict objectForKey:@"room"] isEqualToString:[DataCenter sharedInstance].userVO.room]) {
                    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                }
                cell.textLabel.text = [dict objectForKey:@"room"];
                break;
        }
        
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *array = [tableView visibleCells];
    for (UITableViewCell *cell in array) {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        cell.textLabel.textColor=[UIColor blackColor];
    }
    UITableViewCell *cell=[residenceTableView cellForRowAtIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    switch (type) {
        case 1:
            [DataCenter sharedInstance].userVO.building = cell.textLabel.text;
            [DataCenter sharedInstance].userVO.unit = nil;
            [DataCenter sharedInstance].userVO.room = nil;
            break;
        case 2:
            [DataCenter sharedInstance].userVO.unit = cell.textLabel.text;
            [DataCenter sharedInstance].userVO.room = nil;
            break;
        case 3:
            [DataCenter sharedInstance].userVO.room = cell.textLabel.text;
            [DataCenter sharedInstance].userVO.residenceId = [[residenceArray objectAtIndex:[indexPath row]] objectForKey:@"uuid"];
            break;
    }
}

#pragma mark  -------网络请求回调----------
-(void)requestSuccess:(ASIFormDataRequest*)request{
    
    NSLog(@"response:%@",request.responseString);
    
}

#pragma mark  -------请求错误--------
- (void)requestError:(ASIFormDataRequest*)request{
   
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}


@end
