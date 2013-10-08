//
//  SelectVillagelViewController.m
//  WuTongCity
//
//  Created by alan  on 13-7-29.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "SelectVillagelViewController.h"
#import "HouseCell.h"
#import "pinyin.h"
#import "LoginViewController.h"
#import "Village.h"
#import "MD5.h"
#import "TableBarViewController.h"

@interface SelectVillagelViewController ()

@end

@implementation SelectVillagelViewController

-(id)init{
    if (self = [super init]) {
        self.navigationItem.title = @"小区列表";
        
    }
    return self;
}


- (void)_initData
{
    villageDict = [[NSMutableDictionary alloc] init];
    basicVillageDict = [[NSMutableDictionary alloc] init];
    
    //发起获取小区信息请求
    NSURL *url = [NSURL URLWithString:[RequestLinkUtil getUrlByKey:VILLAGE_LIST]];
    ASIFormDataRequest *villageRequest=[ASIFormDataRequest requestWithURL:url];
    [ASIFormDataRequest setShouldThrottleBandwidthForWWAN:YES];
    villageRequest.timeOutSeconds= 30;
    [villageRequest setDelegate:self];
    [villageRequest setCompletionBlock:^{
        NSString *villageString = villageRequest.responseString;
        NSDictionary *reqDict = [villageString JSONValue];
        if ([reqDict objectForKey:@"result"]) {
            NSArray *villageArray = [reqDict objectForKey:@"result"];
            for (NSDictionary *vDict in villageArray) {
                NSString *topWord = [[NSString alloc]init];
                Village * v = [[Village alloc]init];
                v.uuid = [vDict objectForKey:@"uuid"];
                v.name = [vDict objectForKey:@"name"];
                //返回中文字的首字母
                topWord = [topWord stringByAppendingString:[NSString stringWithFormat:@"%c",pinyinFirstLetter([v.name characterAtIndex:0])]];
                if ([villageDict objectForKey:topWord]) {
                    [[villageDict objectForKey:topWord] addObject:v];
                }else{
                    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithObjects:v, nil];
                    [villageDict setValue:tempArray forKey:topWord];
                }
            }
            
            //给villageDict排序
            NSArray *keys = [villageDict allKeys];
            keys = [keys sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString * obj2) {
                return [obj1 localizedCompare:obj2];
            }];
            self.keys = keys;
            NSMutableDictionary *tmp = [NSMutableDictionary dictionary];
            for (NSString *key in keys) {
                [tmp setObject:villageDict[key] forKey:key];
            }
            villageDict = tmp;
            
            basicVillageDict = villageDict;
            [villageTableView reloadData];
            
        }else{
            NSLog(@"请求失败");
        }
        
        [HUD hide:YES];        }];
    [villageRequest setFailedBlock:^{
        [HUD hide:YES];
        UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"梧桐邑"
                                                  message:@"服务器异常"
                                                 delegate:nil
                                        cancelButtonTitle:@"好的"
                                        otherButtonTitles: nil];
        [av show];
        
    }];
    [villageRequest startAsynchronous];
    [HUD show:YES];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    [HUD show:YES];

    [self _initData];

//    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"小区创建"
//                                                                      style:UIBarButtonItemStylePlain
//                                                                     target:self
//                                                                     action:@selector(createVillage)];
//    self.navigationItem.rightBarButtonItem = anotherButton;

    
    // 遮盖层
    coverLayer=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 160)];
    [coverLayer setAlpha:0.9f];
    [coverLayer addTarget:self action:@selector(hiddenCoverLayer) forControlEvents:UIControlEventTouchUpInside];
    
    
    villageSearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    villageSearchBar.delegate = self;
    villageSearchBar.barStyle=UIBarStyleDefault;
    villageSearchBar.placeholder=@"请输入小区名称";
    //背景色
    villageSearchBar.tintColor = [UIColor darkGrayColor];
    villageSearchBar.backgroundColor=[UIColor clearColor];
    [villageSearchBar setInputAccessoryView:coverLayer];
    [self.view addSubview:villageSearchBar];
    
    villageTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height-44) style:UITableViewStylePlain];
    villageTableView.dataSource = self;
    villageTableView.delegate = self;
    [self.view addSubview:villageTableView];
}

//返回分组数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.keys count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *key=[self.keys objectAtIndex:section];//返回当前分组对应neighbourDict的key值
    NSArray *sectionArray=[villageDict objectForKey:key];//根据key，取得Array
    return [sectionArray count]; //返回Array的大小
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * tableIdentifier=@"HouseSelCell";
    
    NSString *key = [self.keys objectAtIndex:[indexPath section]];
    NSLog(@"(%i,%i) and %@",indexPath.section,indexPath.row,key);
    NSArray *section = [villageDict objectForKey:key];
    Village *village = [section objectAtIndex:[indexPath row]];
    
    HouseCell *cell=[tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if(cell==nil){
        cell=[[HouseCell alloc] initWithHouseName:village.name];
    }
    return cell;
}

//分组的title
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
   
    NSString *key = [self.keys objectAtIndex:section];
    return key;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//点击后cell背景消失
    //从小区字典集合中找到当前选中的小区信息,放入数据中心
    NSString *key = [self.keys objectAtIndex:[indexPath section]];
    NSArray *section = [villageDict objectForKey:key];
    Village *village = [section objectAtIndex:[indexPath row]];
    [DataCenter sharedInstance].village = village;//将选择的小区信息放入数据中心
    
    NSArray *us = [WZUser MR_findAll];
    for (WZUser *u in us) {
        NSLog(@"%@,%@,%@,%@",u.loginId,u.password,u.villageId,village.uuid);
    }
    NSArray *users =[WZUser   MR_findByAttribute:@"villageId" withValue:village.uuid ];
     WZUser *user = [users lastObject];
    BOOL flag = [[NSUserDefaults standardUserDefaults]  boolForKey:@"autoLogin"];
    if (user.loginId.length >0 && user.password.length >0 && flag) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:user.loginId,@"loginId",user.password,@"password",user.villageId,@"villageId", nil];
        [self login:dic];
    }else{
        LoginViewController *loginViewController = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:loginViewController animated:YES];
    }
    
/*
//    //判断当前小区是否已经有注册用户
//    NSDictionary *dict = [[DataCenter sharedInstance] searchLoaclAccountByVillageId];
//    if (dict) {
//        [self login:dict];
//    }else{
        LoginViewController *loginViewController = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:loginViewController animated:YES];
//    }
 */
}

//创建小区
-(void) createVillage{
    LoginViewController *loginViewController = [[LoginViewController alloc]init];
    [self.navigationController pushViewController:loginViewController animated:YES];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{                  // called when keyboard search button pressed{
    searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = YES;
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

//隐藏遮盖层
-(void) hiddenCoverLayer{
    [villageSearchBar resignFirstResponder];
    villageSearchBar.showsCancelButton = NO;
}

- (void)updateSearchString:(NSString*)aSearchString{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if ([aSearchString isEqualToString:@""]) {
        villageDict = basicVillageDict;
    }else{
        for (NSString *tw in [villageDict allKeys]) {
            for (Village *v in [villageDict objectForKey:tw]) {
                NSString *topWord = [[NSString alloc]init];
                for (int i = 0; i < [v.name length]; i++){
                    //返回中文字的首字母
                    topWord = [topWord stringByAppendingString:[NSString stringWithFormat:@"%c",pinyinFirstLetter([v.name characterAtIndex:i])]];
                }
                //是否包含
                NSRange foundObj=[topWord rangeOfString:aSearchString options:NSCaseInsensitiveSearch];
                if(foundObj.length>0) {
                    [array addObject:v];
                }else{
                    foundObj=[v.name rangeOfString:aSearchString options:NSCaseInsensitiveSearch];
                    if(foundObj.length>0) {
                        [array addObject:v];
                    }
                }
                villageDict =[[NSMutableDictionary alloc] init];
                [villageDict setValue:array forKey:@""];
            }
        }
    }
    [villageTableView reloadData];
}

-(void) toLoginPage{
    LoginViewController *login = [[LoginViewController alloc]init];
    [self.navigationController pushViewController:login animated:YES];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}


#pragma mark  -------网络请求回调----------
-(void)villageRequestSuccess:(ASIFormDataRequest*)request{
    NSString *villageString = request.responseString;
    NSDictionary *reqDict = [villageString JSONValue];
    
    if ([reqDict objectForKey:@"result"]) {
        NSArray *villageArray = [reqDict objectForKey:@"result"];
        for (NSDictionary *vDict in villageArray) {
            NSString *topWord = [[NSString alloc]init];
            Village * v = [[Village alloc]init];
            v.uuid = [vDict objectForKey:@"uuid"];
            v.name = [vDict objectForKey:@"name"];
            //返回中文字的首字母
            topWord = [topWord stringByAppendingString:[NSString stringWithFormat:@"%c",pinyinFirstLetter([v.name characterAtIndex:0])]];
            if ([villageDict objectForKey:topWord]) {
                [[villageDict objectForKey:topWord] addObject:v];
            }else{
                NSMutableArray *tempArray = [[NSMutableArray alloc] initWithObjects:v, nil];
                [villageDict setValue:tempArray forKey:topWord];
            }
        }
        
        
        
        basicVillageDict = villageDict;
        [villageTableView reloadData];

    }else{
        NSLog(@"请求失败");
    }
    
    [HUD hide:YES];
}

#pragma mark  -------请求错误--------
- (void)requestError:(ASIFormDataRequest*)request
{
    [HUD hide:YES];
    NSLog(@"请求失败");
    UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"梧桐邑" message:@"服务器异常" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
    [av show];
}


-(void) login:(NSDictionary *)_dict{
    //发送登录请求
    ASIFormDataRequest *loginReq=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:[RequestLinkUtil getUrlByKey:USER_LOGIN_URL]]];
    [loginReq setPostValue:[_dict objectForKey:@"loginId"] forKey:@"loginId"];//账号
    [loginReq setPostValue:[_dict objectForKey:@"password"] forKey:@"loginPassword"];//密码
    [loginReq setPostValue:IPHONE forKey:LOGIN_TYPE];//访问类型
    [loginReq setPostValue:[_dict objectForKey:@"villageId"] forKey:@"villageId"];
    [loginReq setDelegate:self];
    [loginReq setCompletionBlock:^{
        NSDictionary *reqDict = [loginReq.responseString JSONValue];
        if ([reqDict objectForKey:@"userInfo"]) {
            NSDictionary*userInfoDict = [reqDict objectForKey:@"userInfo"];
            //初始化用户信息
            UserVO *userVO = [[UserVO alloc] initLoginUserWithDict:userInfoDict loginId:[_dict objectForKey:@"loginId"] password:[_dict objectForKey:@"password"]];
            //add
            NSDictionary *dic = [userInfoDict objectForKey:@"account"];
            if (userVO.loginId.length == 0) {
                userVO.loginId = [dic objectForKey:@"loginId"];
                userVO.password = [dic objectForKey:@"loginPassword"];
                 userVO.isTempAcount = [dic objectForKey:@"isTempAcco"];
            }
            [DataCenter sharedInstance].userVO = userVO;//放入数据中心
         
            Village *village = [Village new];
            NSArray *userResidences = [userInfoDict objectForKey:@"userResidences"];
            NSDictionary *villagedic = [ [userResidences lastObject] objectForKey:@"village"];
            village.uuid = [villagedic objectForKey:@"uuid"];
            village.name = [villagedic objectForKey:@"name"];
            [DataCenter sharedInstance].village = village;//将选择的小区信息放入数据中心
            
            [[DataCenter sharedInstance] setLocalAccount];//登录后设置本地账号
            
            
            //以用户uuid和账号密码登录openfire服务器
            XMPPManager *xmppManager = [XMPPManager sharedInstance];
            xmppManager.isLoginOperation = YES;
            if ([xmppManager connect]) {
                //进入主菜单
                TableBarViewController *tabbar = [[TableBarViewController alloc]init];
                [self.navigationController presentViewController:tabbar animated:NO completion:nil];
            }else{
                [[[UIAlertView alloc]initWithTitle:@"梧桐邑" message:@"登陆失败" delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil] show];
            }
        }else{
            UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"梧桐邑" message:@"登陆失败" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
            [av show];
            
        }
        [HUD hide:YES];
    }];
    [loginReq setFailedBlock:^{
        [HUD hide:YES];
        UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"梧桐邑"
                                                  message:@"服务器异常"
                                                 delegate:nil
                                        cancelButtonTitle:@"好的"
                                        otherButtonTitles: nil];
        [av show];
        
        WZUser *user = [[WZUser MR_findByAttribute:@"loginId" withValue:[_dict objectForKey:@"loginId"]] lastObject];
        [user MR_deleteEntity];
        [[NSManagedObjectContext MR_defaultContext] MR_save];

    }];
    [loginReq startAsynchronous];
    [HUD show:YES];
}



@end
