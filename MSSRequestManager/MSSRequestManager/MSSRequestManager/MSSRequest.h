//
//  MSSRequest.h
//  MSSRequestManager
//
//  Created by 于威 on 16/5/7.
//  Copyright © 2016年 于威. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MSSRequestModel;

typedef void(^MSSRequestCompletionBlock)(id responseObject,NSURLResponse *response,NSError *error);
typedef void(^MSSRequestProgressBlock)(NSProgress *progress);

@interface MSSRequest : NSObject

+ (MSSRequest *)sharedInstance;
/**
 *  发起一个请求
 *
 *  @param requestItem 请求数据对象
 *  @param completion  请求结果回调
 *  @param progress    进度条回调
 *
 *  @return task
 */
- (NSURLSessionDataTask *)startWithRequestItem:(MSSRequestModel *)requestItem completion:(MSSRequestCompletionBlock)completion progress:(MSSRequestProgressBlock)progress;
/**
 *  取消指定请求
 *
 *  @param requestItem 请求数据对象
 */
- (void)cancelWithRequestItem:(MSSRequestModel *)requestItem;
/**
 *  取消全部请求
 */
- (void)cancelAllRequest;

@end
