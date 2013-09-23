//
//  ConstantValue.h
//  TestServlet
//
//  Created by alan on 12-7-13.
//  Copyright (c) 2012年 my conpany. All rights reserved.
//

//#define SERVER_DEFAULT_ADDRESS @"http://www.baidu.com"
#define SERVER_DEFAULT_ADDRESS @"http://v2.wutongyi.com"
//#define SERVER_DEFAULT_ADDRESS @"http://192.168.1.109:8080/webSite"
//#define SERVER_DEFAULT_ADDRESS @"http://192.168.1.115:8080/wtyws/"
//#define SERVER_DEFAULT_ADDRESS @"http://192.168.1.114:8080"

//------------------------注册登录-----------------------
//校验码
#define CHECK_CODE_URL      1 
//用户注册
#define USER_REGISTER_URL   2
//用户登录
#define USER_LOGIN_URL      3
//快速注册
#define USER_CREATE         4  

//-----------------------邻居说---------------------------------
#define PUBLIC_BLOG_LIST    10//邻居说列表
#define PUBLIC_BLOG_LOAD    11//邻居说列表--其他用户发布的所有邻居说
#define PUBLIC_BLOG_CREATE  12//发布邻居说-普通话题
#define PUBLIC_BLOG_PRAISES 13//赞

#define COMMENT_LIST        15//邻居说评论列表
#define COMMENT_CREATE      16//发布邻居说评论


#define POSTER_LOAD         20//广告列表
#define POSTER_BY_UUID      21//查看广告

//-----------------------邻居---------------------------------
//邻居列表
#define USER_LIST 30
//邻居查看
#define USER_LOAD 31
//屏蔽邻居
#define USER_SHIELD 32
//限制邻居
#define USER_RESTRICT 33
//取消限制/屏蔽
#define CANCEL_R_S  34
//邻居置顶
#define USER_STICK  35


//-----------------------小区---------------------------------
//小区列表
#define VILLAGE_LIST  40
//小区申请
#define VILLAGE_APPLY  41
//小区更改
#define VILLAGE_CHAGNE  42
//住宅查询
#define RESIDENCE_LOAD  43
//住宅保存
#define RESIDENCE_CREATE 44

#define RESIDENCE_MODIFY 45




#define AVATAR_UPLOAD 100
#define PERSONAL_MODIFY 101//个人信息修改
#define PERSONALITY_MODIFY  102//个性化信息修改



#define DOWNLOAD_FILE 200

////屏蔽用户列表
//#define OTHER_USER_QUERY2 8
////限制用户列表
//#define OTHER_USER_QUERY4 10
