//
//  MSSRequestLoginNetWork.m
//  MSSRequestManager
//
//  Created by 于威 on 16/7/10.
//  Copyright © 2016年 于威. All rights reserved.
//

#import "MSSRequestLoginNetWork.h"

@implementation MSSRequestLoginNetWork

- (void)setUpRequestItem
{
    self.requestItem.requestUrl = @"http://v2.toys178.com/Api/Assistant/Login/index";
    self.requestItem.cachePolicy = MSSRequestUseLocalCachePolicy;
    self.requestItem.cacheSecond = 10.0f;
    self.requestItem.cacheFolderName = @"Login";
    self.requestItem.loadingType = MSSRequestCircleType;
    self.requestItem.isShowSussessAlertView = YES;
    self.requestItem.successAlertText = @"登录成功";
}


//- (id)parseWithResponseObject:(id)responseObject
//{
//    // 此处可由子类解析，返回相应的Model
//    return model;
//}

@end
