//
//  MSSRequest.h
//  MSSRequestManager
//
//  Created by 于威 on 16/5/7.
//  Copyright © 2016年 于威. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSSRequestModel.h"

typedef void(^MSSRequestSuccessBlock)(id responseObject);
typedef void(^MSSRequestFailBlock)(NSError *error);
typedef void(^MSSRequestProgressBlock)(NSProgress *progress);

@interface MSSRequest : NSObject

+ (MSSRequest *)sharedInstance;
/**
 *  发起一个请求
 *
 *  @param requestItem 请求参数数据对象
 *  @param success     请求成功回调
 *  @param fail        请求失败回调
 *  @param progress    进度条回调
 */
- (void)startWithRequestItem:(MSSRequestModel *)requestItem success:(MSSRequestSuccessBlock)success fail:(MSSRequestFailBlock)fail progress:(MSSRequestProgressBlock)progress;
/**
 *  发起一个上传文件请求
 *
 *  @param requestItem 请求参数数据对象
 *  @param success     请求成功回调
 *  @param fail        请求失败回调
 *  @param progress    进度条回调
 */
- (void)uploadFileWithRequestItem:(MSSRequestModel *)requestItem success:(MSSRequestSuccessBlock)success fail:(MSSRequestFailBlock)fail progress:(MSSRequestProgressBlock)progress;

/**
 *  根据request发起一个上传文件请求
 *
 *  @param request     request
 *  @param requestItem 请求参数数据对象
 *  @param success     请求成功回调
 *  @param fail        请求失败回调
 *  @param progress    进度条回调 */
- (void)uploadFileWithRequest:(NSURLRequest *)request requestItem:(MSSRequestModel *)requestItem success:(MSSRequestSuccessBlock)success fail:(MSSRequestFailBlock)fail progress:(MSSRequestProgressBlock)progress;

@end
