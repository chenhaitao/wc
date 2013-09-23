////
////  SendRequestData.m
////  CampaignPro
////
////  Created by Ronnie on 12-8-29.
////  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
////
//
//#import "SendRequestData.h"
//
//@implementation SendRequestData
//@synthesize urlBykey,dataDic,responseContents;
//
//-(NSString *)sendRequestBySyn{
//    NSString * regURLStr = [RequestLinkUtil getUrlByKey:urlBykey];
//    NSLog(@"%@====",regURLStr);
//    NSURL * regURL = [NSURL URLWithString:regURLStr];
//    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:regURL];
//    
//    NSEnumerator * enumeratorKey = [dataDic keyEnumerator];
//    
//    for (NSString *key in enumeratorKey) {
//        
//        [request addPostValue:[dataDic valueForKey:key] forKey:key];
//    }
//    [request setDelegate:self];
//    [request setDidFinishSelector:@selector(requestSuccess:)];
//    [request setDidFailSelector:@selector(requestError:)];
//    [request startSynchronous];
//    
//    NSError *error = [request error];
//    
//    //返回结果没有出错，且不为空
//    if (!error) {
//        responseContents = [request responseString];
//    }else{
//        if (request.error.domain == NetworkRequestErrorDomain) {
//            NSString *errorMsg = nil;
//            switch ([request.error code]) {
//                case ASIConnectionFailureErrorType:
//                    errorMsg = @"无法连接到网络";
//                    break;
//                case ASIRequestTimedOutErrorType:
//                    errorMsg = @"访问超时";
//                    break;
//                case ASIAuthenticationErrorType:
//                    errorMsg = @"服务器身份验证失败";
//                    break;
//                case ASIRequestCancelledErrorType:
//                    //errorMsg = @"request is cancelled";
//                    errorMsg = @"服务器请求已取消";
//                    break;
//                case ASIUnableToCreateRequestErrorType:
//                    //errorMsg = @"ASIUnableToCreateRequestErrorType";
//                    errorMsg = @"无法创建服务器请求";
//                    break;
//                case ASIInternalErrorWhileBuildingRequestType:
//                    //errorMsg = @"ASIInternalErrorWhileBuildingRequestType";
//                    errorMsg = @"服务器请求创建异常";
//                    break;
//                case ASIInternalErrorWhileApplyingCredentialsType:
//                    //errorMsg = @"ASIInternalErrorWhileApplyingCredentialsType";
//                    errorMsg = @"服务器请求异常";
//                    break;
//                case ASIFileManagementError:
//                    //errorMsg = @"ASIFileManagementError";
//                    errorMsg = @"服务器请求异常";
//                    break;
//                case ASIUnhandledExceptionError:
//                    //errorMsg = @"ASIUnhandledExceptionError";
//                    errorMsg = @"未知请求异常异常";
//                    break;
//                default:
//                    errorMsg = @"服务器故障或网络链接失败！";
//                    break;
//            }
//            if ([request.error code] != ASIRequestCancelledErrorType) {
//                NSLog(@"error detail:%@\n",request.error.userInfo);
//                NSLog(@"error code:%d",[request.error code]);
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
//                                                                message:errorMsg 
//                                                               delegate:nil
//                                                      cancelButtonTitle:@"取消"
//                                                      otherButtonTitles:nil];
//                    [alert show];
//                }
//            }
//    }
//    return responseContents;
//
//}
//
//-(NSString *)sendRequestByAsyn{
//    NSString * regURLStr = [RequestLinkUtil getUrlByKey:urlBykey];
//    //    CCLOG(@"%@====",regURLStr);
//    NSURL * regURL = [NSURL URLWithString:regURLStr];
//    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:regURL];
//    
//    NSEnumerator * enumeratorKey = [dataDic keyEnumerator];
//    
//    for (NSString *key in enumeratorKey) {
//        
//        [request addPostValue:[dataDic valueForKey:key] forKey:key];
//    }
//    
//    [request startAsynchronous];
//    
//    NSError *error = [request error];
//    
//    //返回结果没有出错，且不为空
//    if (!error && [request responseString]!=nil) {
//        responseContents = [request responseString];
//        NSLog(@"%@",responseContents);
//    }else {
//        //        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:PROMPT
//        //                                                       message:SERVICE_ERROR
//        //                                                      delegate:self
//        //                                             cancelButtonTitle:OK
//        //                                             otherButtonTitles:nil];
//        //        [alert show];
//        return nil;
//    }
//    return responseContents;
//}
//
//
//@end
