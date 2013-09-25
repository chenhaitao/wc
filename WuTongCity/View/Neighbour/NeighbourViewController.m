//
//  NeighbourViewController.m
//  WuTongCity
//
//  Created by alan  on 13-8-14.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "NeighbourViewController.h"
#import "UserVO.h"
#import "NeighbourCell.h"
#import "pinyin.h"
#import "NeighDetailViewController.h"

@interface NeighbourViewController ()

@end

@implementation NeighbourViewController

-(id)init{
    if (self = [super init]) {
        neighbourArray = [[NSMutableArray alloc]init];
        neighbourBasicArray = [[NSMutableArray alloc]init];        
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //遮盖层
    coverLayer=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 160)];
    [coverLayer setAlpha:0.9f];
    [coverLayer addTarget:self action:@selector(hiddenCoverLayer) forControlEvents:UIControlEventTouchUpInside];

    //搜索栏
    neighbourSearchBar = [[UISearchBar alloc]
                      initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
    neighbourSearchBar.tintColor = [UIColor darkGrayColor];
    neighbourSearchBar.delegate = self;
    neighbourSearchBar.showsCancelButton = NO;
    neighbourSearchBar.barStyle=UIBarStyleDefault;
    [neighbourSearchBar setInputAccessoryView:coverLayer];
    [self.view addSubview:neighbourSearchBar];
    
    //邻居列表
    neighbourTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height-130) style:UITableViewStylePlain];
    neighbourTableView.dataSource = self;
    neighbourTableView.delegate = self;
    neighbourTableView.allowsSelectionDuringEditing = YES;
    [self.view addSubview:neighbourTableView];
    
    self.topArray = [NSMutableArray array];
    self.noTopArray = [NSMutableArray array];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [neighbourArray removeAllObjects];
    [neighbourBasicArray removeAllObjects];
    [self neighbourList];
}


- (void)viewDidUnload{
    [super viewDidUnload];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //返回分组数量,即Array的数量
    return 2;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return [neighbourArray count];
    if (section == 0) {
        return self.topArray.count;
    }else{
        return self.noTopArray.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * tableIdentifier=@"NeighbourCell";
    UserVO *userVO  = nil;
    if (indexPath.section == 0) {
        userVO = [self.topArray objectAtIndex:indexPath.row];
    }else{
        userVO = [self.noTopArray objectAtIndex:[indexPath row]];
    }
   
    NeighbourCell *cell=[tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if(cell==nil){
        cell=[[NeighbourCell alloc]initWithUserVO:userVO];
    }
    return cell;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellEditingStyleNone;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = nil;
    if (section == 0) {
        title = @"置顶邻居";
    }else{
        title = @"普通邻居";
    }
    return title;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NeighbourCell *neighbourCell = (NeighbourCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    NeighDetailViewController *neighDetailViewController = [[NeighDetailViewController alloc]initWithUserVO:neighbourCell.userVO];
    neighDetailViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:neighDetailViewController animated:YES];
    neighDetailViewController.title = @"邻居";
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{                  // called when keyboard search button pressed{
    searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = YES;
    for(id cc in [searchBar subviews]){
        if([cc isKindOfClass:[UIButton class]]){
            UIButton *btn = (UIButton *)cc;
            [btn setTitle:@"取消"  forState:UIControlStateNormal];
        }
    }
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    NSLog( @"%s,%d" , __FUNCTION__ , __LINE__ );
    
    
}

// 当搜索内容变化时，执行该方法。很有用，可以实现时实搜索
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;{
    [self updateSearchString:searchBar.text];
}

// 取消按钮被按下时，执行的方法
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    searchBar.showsCancelButton = NO;
    searchBar.text = @"";
    [self updateSearchString:@""];
}


- (void)updateSearchString:(NSString*)aSearchString{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if ([aSearchString isEqualToString:@""]) {
        neighbourArray = neighbourBasicArray;
    }else{
        for(UserVO *u in neighbourArray){
            NSString *topWord = [[NSString alloc]init];
            for (int i = 0; i < [u.nickName length]; i++){
                //返回中文字的首字母
                topWord = [topWord stringByAppendingString:[NSString stringWithFormat:@"%c",pinyinFirstLetter([u.nickName characterAtIndex:i])]];
            }
            //是否包含
            NSRange foundObj=[topWord rangeOfString:aSearchString options:NSCaseInsensitiveSearch];
            if(foundObj.length>0) {
                [array addObject:u];
            }else{
                foundObj=[u.nickName rangeOfString:aSearchString options:NSCaseInsensitiveSearch];
                if(foundObj.length>0) {
                    [array addObject:u];
                }
            }
        }
        neighbourArray = [[NSMutableArray alloc] initWithArray:array];
    }
    
    [self.topArray removeAllObjects];
    [self.noTopArray removeAllObjects];
    for (UserVO *user in neighbourArray) {
        if (user.isStick > 0) {
            [self.topArray addObject:user];
        }else{
            [self.noTopArray addObject:user];
        }
    }
    
    [neighbourTableView reloadData];
    
}


-(void) hiddenCoverLayer{
    [neighbourSearchBar resignFirstResponder];
}


-(void) neighbourList{
    NSURL *url = [NSURL URLWithString:[RequestLinkUtil getUrlByKey:USER_LIST]];
    ASIFormDataRequest *neighbourListReq = [ASIFormDataRequest requestWithURL:url];
    [neighbourListReq setPostValue:@"withoutShield" forKey:@"type"];
    [neighbourListReq setCompletionBlock:^{//成功
        NSLog(@"%@",[neighbourListReq responseString]);
        NSString *responseStr = [neighbourListReq responseString];
        NSDictionary *responseDict = [responseStr JSONValue];
        int totalCount = [[responseDict objectForKey:@"totalCount"]intValue];
        if (totalCount > 0) {
            NSArray *arr = [responseDict objectForKey:@"result"];
            for (NSDictionary *dict in arr) {
                UserVO *uvo = [[UserVO alloc] initNeighbourWithDict:dict];
                [neighbourArray addObject:uvo];
                [neighbourBasicArray addObject:uvo];
            }
            
            [self.topArray removeAllObjects];
            [self.noTopArray removeAllObjects];
            for (UserVO *user in neighbourArray) {
                if (user.isStick > 0) {
                    [self.topArray addObject:user];
                }else{
                    [self.noTopArray addObject:user];
                }
            }
            
            [neighbourTableView reloadData];
        }
        [HUD hide:YES];
    }];
    [neighbourListReq setFailedBlock:^{//失败
        UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"梧桐邑" message:@"服务器异常" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [av show];
        [HUD hide:YES];
    }];
    [neighbourListReq startAsynchronous];
    [HUD show:YES];
}

@end
