//
//  MSSRequestManager.h
//  MSSRequestManager
//
//  Created by 于威 on 16/5/7.
//  Copyright © 2016年 于威. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSSRequestModel.h"
#import "MSSRequest.h"
#import "MSSBatchRequest.h"

@interface MSSRequestManager : NSObject

+ (MSSRequestManager *)sharedInstance;
/**
 *  发起一个请求
 *
 *  @param requestItem 请求参数数据对象
 *  @param success     请求成功回调
 *  @param fail        请求失败回调
 */
- (void)startWithRequestItem:(MSSRequestModel *)requestItem success:(MSSRequestSuccessBlock)success fail:(MSSRequestFailBlock)fail;
/**
 *  发起一个上传文件请求
 *
 *  @param requestItem 请求参数数据对象
 *  @param success     请求成功回调
 *  @param fail        请求失败回调
 */
- (void)uploadFileWithRequestItem:(MSSRequestModel *)requestItem success:(MSSRequestSuccessBlock)success fail:(MSSRequestFailBlock)fail;
/**
 *  取消指定请求
 *
 *  @param requestItem 请求参数数据对象
 */
- (void)cancelWithRequestItem:(MSSRequestModel *)requestItem;
/**
 *  取消全部请求
 */
- (void)cancelAllRequest;

/**
 *  批量上传文件，放入队列中发送多个请求
 *
 *  @param requestItemArray   请求数据对象数组
 *  @param success            请求成功回调
 *  @param fail               请求失败回调
 */
- (void)uploadBatchFileWithRequestItemArray:(NSArray *)requestItemArray success:(MSSRequestSuccessBlock)success fail:(MSSRequestFailBlock)fail finish:(MSSBatchRequestFinish)finish;
/**
 *  取消批量上传全部请求
 */
- (void)cancelBatchRequest;

@end
