//
//  MSSRequestConfig.h
//  MSSRequestManager
//
//  Created by 于威 on 16/7/4.
//  Copyright © 2016年 于威. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSSRequestModel.h"

@interface MSSRequestConfig : NSObject
/**
 *  通用请求参数配置
 *
 *  @return 通用请求参数
 */
+ (NSDictionary *)commonParams;

#pragma mark MSSRequestModel defaultConfig
+ (MSSRequestMethod)requestMethod;
+ (MSSRequestCachePolicy)cachePolicy;
+ (NSTimeInterval)timeInterval;
+ (BOOL)isShowLoadingView;
+ (BOOL)isShowFailAlertView;
+ (BOOL)isShowSussessAlertView;

@end
