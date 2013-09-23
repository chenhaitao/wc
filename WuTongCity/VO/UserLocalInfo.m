//
//  UserLocalInfo.m
//  WuTongCity
//
//  Created by alan  on 13-9-18.
//  Copyright (c) 2013年 alan. All rights reserved.
//

#import "UserLocalInfo.h"

@implementation UserLocalInfo

@synthesize loginId;
@synthesize password;
@synthesize villageId;
@synthesize userId;
@synthesize avatar;
@synthesize nickName;
@synthesize loginTime;



- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.loginId forKey:@"loginId"];
    [encoder encodeObject:self.password forKey:@"password"];
    [encoder encodeObject:self.villageId forKey:@"villageId"];
    [encoder encodeObject:self.userId forKey:@"userId"];
    [encoder encodeObject:self.avatar forKey:@"avatar"];
    [encoder encodeObject:self.nickName forKey:@"nickName"];
    [encoder encodeObject:self.loginTime forKey:@"loginTime"];
}
- (id)initWithCoder:(NSCoder *)decoder
{
    if(self = [super init])
    {
        self.loginId = [decoder decodeObjectForKey:@"loginId"];
        self.password = [decoder decodeObjectForKey:@"password"];
        self.villageId = [decoder decodeObjectForKey:@"villageId"];
        self.userId = [decoder decodeObjectForKey:@"userId"];
        self.avatar = [decoder decodeObjectForKey:@"avatar"];
        self.nickName = [decoder decodeObjectForKey:@"nickName"];
        self.loginTime = [decoder decodeObjectForKey:@"loginTime"];
    }
    return  self;
}

//-(UserLocalInfo *)setUserLocal:(UserVO *)uvo{
//    
//    UserLocalInfo *userLocal = [[UserLocalInfo alloc] init];
//    userLocal.loginId = uvo.loginId;
//    userLocal.password = uvo.password;
//    userLocal.villageId = self.village.uuid;
//    userLocal.userId = uvo.userId;
//    userLocal.avatar = uvo.avatar;
//    userLocal.nickName = uvo.nickName;
//    userLocal.loginTime = uvo.loginTime;
//    return userLocal;
//}

@end
