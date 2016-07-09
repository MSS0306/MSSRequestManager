//
//  MSSRequestConfig.m
//  MSSRequestManager
//
//  Created by 于威 on 16/7/4.
//  Copyright © 2016年 于威. All rights reserved.
//

#import "MSSRequestConfig.h"

@implementation MSSRequestConfig

+ (NSDictionary *)commonParams
{
    return nil;
}

#pragma mark MSSRequestModel defaultConfig
+ (MSSRequestMethod)requestMethod
{
    return MSSRequestPostMethod;
}

+ (MSSRequestCachePolicy)cachePolicy
{
    return MSSRequestDefaultCachePolicy;
}

+ (NSTimeInterval)timeInterval
{
    return 60.0f;
}

+ (BOOL)isShowLoadingView
{
    return NO;
}

+ (BOOL)isShowFailAlertView
{
    return YES;
}

+ (BOOL)isShowSussessAlertView
{
    return NO;
}


@end
