//
//  RequestLinkUtil.m
//  TestServlet
//
//  Created by alan on 12-7-13.
//  Copyright (c) 2012年 my conpany. All rights reserved.
//

#import "RequestLinkUtil.h"


@implementation RequestLinkUtil

+(NSString *)getUrlByKey:(NSInteger)key{
    switch (key) {
        case CHECK_CODE_URL://校验码
            return [SERVER_DEFAULT_ADDRESS stringByAppendingString:@"/validateCode.do"];
        case USER_REGISTER_URL://注册
            return [SERVER_DEFAULT_ADDRESS stringByAppendingString:@"/user/userRegister.do"];
        case USER_LOGIN_URL://登录
            return [SERVER_DEFAULT_ADDRESS stringByAppendingString:@"/logonAction.do"];
        case USER_CREATE://快速注册
            return [SERVER_DEFAULT_ADDRESS stringByAppendingString:@"/user/userRegister.do"];
            //邻居说---------------------------------------------------------------------------------------------
        case PUBLIC_BLOG_LIST://邻居说列表
            return [SERVER_DEFAULT_ADDRESS stringByAppendingString:@"/m/publicBlog/publicBlogList.do"];
        case PUBLIC_BLOG_LOAD://邻居说列表---其他用户
            return [SERVER_DEFAULT_ADDRESS stringByAppendingString:@"/m/publicBlog/publicBlogLoad.do"];
        case PUBLIC_BLOG_CREATE://发布邻居说-普通话题
            return [SERVER_DEFAULT_ADDRESS stringByAppendingString:@"/m/publicBlog/publicBlogCreate.do"];
        case PUBLIC_BLOG_PRAISES://发布邻居说-赞
            return [SERVER_DEFAULT_ADDRESS stringByAppendingString:@"/m/publicBlog/publicBlogModify.do"];
//            
            
            
        case COMMENT_LIST://邻居说评论列表
            return [SERVER_DEFAULT_ADDRESS stringByAppendingString:@"/m/publicBlog/pbCommentList.do"];
        case COMMENT_CREATE://发布邻居说评论
            return [SERVER_DEFAULT_ADDRESS stringByAppendingString:@"/m/publicBlog/pbCommentCreate.do"];
        case POSTER_LOAD://?pageNo=1&pageSize=10 --广告列表
            return [SERVER_DEFAULT_ADDRESS stringByAppendingString:@"/m/publicBlog/pbPosterLoad.do"];
        case POSTER_BY_UUID://查看广告
            return [SERVER_DEFAULT_ADDRESS stringByAppendingString:@"/webSite/poster/posterByUuid.do"];
 
       //邻居---------------------------------------------------------------------------------------------     
        case USER_LIST://邻居/限制列表--type=neighborList    屏蔽列表type=shieldList
            return [SERVER_DEFAULT_ADDRESS stringByAppendingString:@"/m/user/userList.do"];
        case USER_LOAD://邻居查看
            return [SERVER_DEFAULT_ADDRESS stringByAppendingString:@"/m/user/userLoad.do"];
        case USER_SHIELD://屏蔽邻居
            return [SERVER_DEFAULT_ADDRESS stringByAppendingString:@"/m/user/userShield.do"];
        case USER_RESTRICT://限制邻居
            return [SERVER_DEFAULT_ADDRESS stringByAppendingString:@"/m/user/userRestrict.do"];
        case CANCEL_R_S://取消限制/屏蔽
            return [SERVER_DEFAULT_ADDRESS stringByAppendingString:@"/m/personal/customizationDelete.do"];
        case USER_STICK://邻居置顶
            return [SERVER_DEFAULT_ADDRESS stringByAppendingString:@"/m/user/userStick.do"];
        

            
            

        //小区---------------------------------------------------------------------------------------------  
        case VILLAGE_LIST://小区列表
            return [SERVER_DEFAULT_ADDRESS stringByAppendingString:@"/m/village/villageList.do"];
        case VILLAGE_APPLY://小区申请
            return [SERVER_DEFAULT_ADDRESS stringByAppendingString:@"/m/village/villageApply.do"];
        case VILLAGE_CHAGNE://小区更换
            return [SERVER_DEFAULT_ADDRESS stringByAppendingString:@"/m/village/villageChange.do"];
        case RESIDENCE_LOAD://住宅查询
            return [SERVER_DEFAULT_ADDRESS stringByAppendingString:@"/m/village/residenceLoad.do"];
        case RESIDENCE_CREATE://住宅保存
            return [SERVER_DEFAULT_ADDRESS stringByAppendingString:@"/m/personal/residenceCreate.do"];
        case RESIDENCE_MODIFY://住宅修改
            return [SERVER_DEFAULT_ADDRESS stringByAppendingString:@"/m/personal/residenceModify.do"];
            
        //用户设置---------------------------------------------------------------------------------------------
        case AVATAR_UPLOAD://当前用户（自己）信息
            return [SERVER_DEFAULT_ADDRESS stringByAppendingString:@"/m/personal/avatarUpLoad.do"];
        case PERSONAL_MODIFY://用户信息修改
            return [SERVER_DEFAULT_ADDRESS stringByAppendingString:@"/m/personal/personalModify.do"];
        case PERSONALITY_MODIFY://
            return [SERVER_DEFAULT_ADDRESS stringByAppendingString:@"/m/personal/personalityModify.do"];
            
            
            
//            /m/personal/personalModify.do
//        case 43://当前用户（自己）信息
//            return [SERVER_DEFAULT_ADDRESS stringByAppendingString:@"/user/userSelfQuery.do"];
//        case 43://当前用户（自己）信息
//            return [SERVER_DEFAULT_ADDRESS stringByAppendingString:@"/user/userSelfQuery.do"];

//        case OTHER_USER_QUERY2://屏蔽用户列表
//            return [SERVER_DEFAULT_ADDRESS stringByAppendingString:@"/user/otherUserQuery.do"];
//        case OTHER_USER_QUERY4://限制用户列表
//            return [SERVER_DEFAULT_ADDRESS stringByAppendingString:@"/user/otherUserQuery.do"];
            
            
            
            
//        case K_GET_LEVEL_BUILDINFO:
//            return [SERVER_DEFAULT_ADDRESS stringByAppendingString:@"/buildLevelAction.do?method=buildlevelInfo"];
//        case K_GET_LEVEL_USERBUILDLEV:
//            return [SERVER_DEFAULT_ADDRESS stringByAppendingString:@"/userInfoAction.do?method=login"];
        case DOWNLOAD_FILE:
            return [SERVER_DEFAULT_ADDRESS stringByAppendingString:@"/downloadFile.do?uuid="];

    }
    return nil;
}

@end
