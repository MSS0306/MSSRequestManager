//
//  MSSRequestConfig.m
//  MSSRequestManager
//
//  Created by 于威 on 16/7/4.
//  Copyright © 2016年 于威. All rights reserved.
//

#import "MSSRequestConfig.h"
#import "OpenUDID.h"

@implementation MSSRequestConfig

+ (NSDictionary *)commonParams
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    // 唯一标识，三方库OpenUDID
    [params setObject:[OpenUDID value] forKey:@"openUDID"];
    
    // device params
    UIDevice *device = [UIDevice currentDevice];
    [params setObject:device.name forKey:@"deviceName"];
    [params setObject:device.model forKey:@"deviceModel"];
    [params setObject:device.localizedModel forKey:@"deviceLocalizedModel"];
    [params setObject:device.systemName forKey:@"deviceSystemName"];
    [params setObject:device.systemVersion forKey:@"deviceSystemVersion"];
    
    // version params
    NSDictionary *infoDictionary = [[NSBundle mainBundle]infoDictionary];
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *appBuildVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
    [params setObject:appVersion forKey:@"appVersion"];
    [params setObject:appBuildVersion forKey:@"appBuildVersion"];
        
    return params;
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
