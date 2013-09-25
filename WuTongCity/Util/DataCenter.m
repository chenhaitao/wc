
#import "DataCenter.h"
#import "Topic.h"
#import "MsgComment.h"
#import "UserLocalInfo.h"
#import "CoreData+MagicalRecord.h"
#import "WZUser.h"


@implementation DataCenter
@synthesize weiboArray, userSettingDict, neighborArray;
@synthesize advertisementArray;//广告imageArray
@synthesize village;
@synthesize msgNoticeDict;
@synthesize accList;//用户本地账号集合
@synthesize errorDict;

//设置静态类
static DataCenter *sharedDataCenter = nil;
+(DataCenter *) sharedInstance{
    if (sharedDataCenter == nil) {
        sharedDataCenter = [[DataCenter alloc]init];
    } 
    return sharedDataCenter;
}

//初始化方法
-(id) init{
    if (self = [super init]) {
        self.weiboArray = [[NSMutableArray alloc]init];
        self.userVO = [[UserVO alloc] init];
        self.userSettingDict = [[NSMutableDictionary alloc]init];
        self.neighborArray = [[NSMutableArray alloc]init];
        self.advertisementArray = [[NSMutableArray alloc]init];
        self.villageArray = [[NSMutableArray alloc]init];
        self.village = [[Village alloc] init];
        self.msgNoticeDict = [[NSMutableDictionary alloc] init];

        
        
        //取得sortednames.plist绝对路径
        //sortednames.plist本身是一个NSDictionary,以键-值的形式存储字符串数组
        NSString *path=[[NSBundle mainBundle] pathForResource:@"ErrorProperty" ofType:@"plist"];
        //转换成NSDictionary对象
        self.errorDict=[[NSDictionary alloc] initWithContentsOfFile:path];
        
        //设置广告imageArray-------
        self.advertisementArray = [[NSMutableArray alloc] init];
        [self.advertisementArray addObject:@"1.png"];
        
        
        //设置消息通知----------------------------------------------
        NSMutableDictionary *msgDict1 = [[NSMutableDictionary alloc]init];
        //头像---将头像放入第一个分组
        NSMutableArray *msgArray = [[NSMutableArray alloc]init];
        [msgDict1 setObject:@"有私聊消息通知" forKey:@"title"];
        [msgDict1 setObject:@"0" forKey:@"content"];
        [msgArray addObject:msgDict1];
        [self.msgNoticeDict setObject:msgArray forKey:[NSString stringWithFormat:@"%d",1]];
        
        //将昵称、个性签名放入第二个分组
        msgArray = [[NSMutableArray alloc]init];
        msgDict1 = [[NSMutableDictionary alloc]init];
        [msgDict1 setObject:@"有人评论通知" forKey:@"title"];
        [msgDict1 setObject:@"1" forKey:@"content"];
        [msgArray addObject:msgDict1];
        [self.msgNoticeDict setObject:msgArray forKey:[NSString stringWithFormat:@"%d",2]];



    }
    return self;
}

//登录后设置本地账号
-(void) setLocalAccount{
    self.accList = [[NSMutableArray alloc] init];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"accList"]) {
        self.accList = [NSMutableArray arrayWithArray:[userDefaults objectForKey:@"accList"]];
        
        BOOL haveAccount = NO;
        for (NSDictionary *dict in self.accList) {
            if ([[dict objectForKey:@"userId"] isEqualToString:self.userVO.userId]) {//如果本地已经储存了当前登录的用户
                haveAccount = YES;
                break;
            }
        }
        if (!haveAccount) {//本地不存在当前登录的账号
            [self.accList addObject:[self setDict:self.userVO]];
            [userDefaults setObject:self.accList forKey:@"accList"];
        }
    }else{
        NSDictionary * userDict = [[NSDictionary alloc] initWithDictionary:[self setDict:self.userVO]];
        NSLog(@"%@",userDict);
       
        [self.accList addObject:userDict];
        [userDefaults setObject:self.accList forKey:@"accList"];
    }
    [userDefaults synchronize];
    NSLog(@"%@",[userDefaults objectForKey:@"accList"]);
    
    //add
    NSLog(@"%@",self.userVO);
    
    WZUser *user = [WZUser MR_findFirstByAttribute:@"userId" withValue:self.userVO.userId];
    if (user == nil) {
        user = [WZUser MR_createEntity];
    }
    user.loginId = self.userVO.loginId;
    user.loginTime = self.userVO.loginTime;
    user.nickName = self.userVO.nickName;
    user.password = self.userVO.password;
    user.userId = self.userVO.userId;
    user.villageId =  [DataCenter sharedInstance].village.uuid;
    [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfAndWait];
   
    
}


//当用户选择小区时，通过小区id在本地查找登录过的用户
-(NSDictionary *) searchLoaclAccountByVillageId{
    self.accList = [[NSMutableArray alloc] init];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"accList"]) {
        self.accList = [[NSUserDefaults standardUserDefaults] objectForKey:@"accList"];
        for (NSDictionary *dict in self.accList) {
            if ([[dict objectForKey:@"villageId"] isEqualToString:self.userVO.villageId]) {//如果本地已经储存了当前登录的用户
                return dict;
            }
        }
    }
    return nil;
}

//通过登录时间找到最近一次登录的本地用户
-(NSDictionary *) searchLocalAccountByTime{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.accList = [[NSMutableArray alloc] init];
    NSDictionary *tempDict = nil;

    self.accList = [userDefaults objectForKey:@"accList"];
    if (self.accList || self.accList.count > 0) {
        for (NSDictionary *dict in self.accList) {
            if (tempDict) {
                NSDate *tempDate = [tempDict objectForKey:@"loginTime"];
                NSDate *curDate = [dict objectForKey:@"loginTime"];
                if ([curDate timeIntervalSinceReferenceDate] - [tempDate timeIntervalSinceReferenceDate] > 0) {
                    tempDict = dict;
                }
            }else{
                tempDict = dict;
            }
        }
    }
    return tempDict;
}


-(NSDictionary *)setDict:(UserVO *)uvo{
    NSString *loginId = uvo.loginId;
    NSString *password = uvo.password;
    NSString *villageId = self.village.uuid;
    NSString *userId = uvo.userId;
    NSString *avatar = uvo.avatar;
    NSString *nickName = uvo.nickName;
    NSDate *loginTime = uvo.loginTime;
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:loginId,@"loginId",password,@"password",villageId,@"villageId",userId,@"userId",avatar,@"avatar",nickName,@"nickName",loginTime, @"loginTime", nil];
    return dict;
    
}


@end
