//
//  AccountMgrViewController.m
//  WuTongCity
//
//  Created by alan  on 13-9-18.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "AccountMgrViewController.h"
#import "AccountMgrCell.h"
#import "WZUser.h"

@interface AccountMgrViewController ()

@end

@implementation AccountMgrViewController


-(id)init{
    if (self = [super init]) {
        accountArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //账号列表
    accountTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height) style:UITableViewStylePlain];
    accountTableView.dataSource = self;
    accountTableView.delegate = self;
 
    [self.view addSubview:accountTableView];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self reloadAccountList];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;//返回分组数量,即Array的数量
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [accountArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WZUser *user = [accountArray objectAtIndex:[indexPath row]];
    static NSString * tableIdentifier=@"accountTableViewCell";
    
    AccountMgrCell *cell=[tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if(cell==nil){
        cell=[[AccountMgrCell alloc]initWithUser:user];
//        [cell.shieldingBtn addTarget:self action:@selector(shieldingUser:) forControlEvents:UIControlEventTouchUpInside];//屏蔽
    }
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"";
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WZUser *user = [accountArray objectAtIndex:[indexPath row]];

    resetPasswordViewController = [[ResetPasswordViewController alloc]initWithUser:user];
    resetPasswordViewController.navigationItem.title = @"个人信息";
    resetPasswordViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:resetPasswordViewController animated:YES];

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        WZUser *user = [accountArray objectAtIndex:indexPath.row];
       // NSMutableArray *tempArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"accList"];
        
//        for (NSDictionary *dict in tempArray) {
//            NSString *curUserId = [dict objectForKey:@"userId"];
//            NSString *tempUserId = [tempDict objectForKey:@"userId"];
//            
//        }
        [user MR_deleteEntity];
        [[NSManagedObjectContext MR_defaultContext] MR_save];
        
        
        [accountArray removeObjectAtIndex:indexPath.row];
        
//        
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"accList"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        
//        [[NSUserDefaults standardUserDefaults] setObject:accountArray forKey:@"accList"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        // Delete the row from the data source.
        [accountTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除纪录";
}

-(void) reloadAccountList{
    [accountArray removeAllObjects];
   // accountArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"accList"];
    accountArray =  [NSMutableArray arrayWithArray: [WZUser MR_findAll]];
}

@end
