//
//  MSSRequestModel.m
//  MSSNetworkingManager
//
//  Created by 于威 on 16/5/1.
//  Copyright © 2016年 于威. All rights reserved.
//

#import "MSSRequestModel.h"
#import "MSSRequestConfig.h"

@implementation MSSRequestModel

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        _requestMethod = [MSSRequestConfig requestMethod];
        _cachePolicy = [MSSRequestConfig cachePolicy];
        _timeInterval = [MSSRequestConfig timeInterval];
        _isShowLoadingView = [MSSRequestConfig isShowLoadingView];
        _isShowFailAlertView = [MSSRequestConfig isShowFailAlertView];
        _isShowSussessAlertView = [MSSRequestConfig isShowSussessAlertView];
    }
    return self;
}

@end
