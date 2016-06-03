//
//  MSSBatchRequest.h
//  MSSRequestManager
//
//  Created by 于威 on 16/5/8.
//  Copyright © 2016年 于威. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSSBatchRequestOperation.h"
#import "MSSRequest.h"

typedef void(^MSSBatchRequestSuccessBlock)(id responseObject,NSInteger successCount);
typedef void(^MSSBatchRequestFailBlock)(NSError *error);
typedef void(^MSSBatchRequestFinishBlock)(NSInteger failCount);
typedef void(^MSSBatchRequestProgressBlock)(CGFloat progress);

@interface MSSBatchRequest : NSObject<MSSBatchRequestOperationDelegate>

@property (nonatomic,assign)NSInteger successCount;// 请求成功个数
/**
 *  批量上传文件，放入队列中发送多个请求
 *
 *  @param requestItemArray   请求数据对象数组
 *  @param success            请求成功回调
 *  @param fail               请求失败回调
 *  @param finish             请求全部完成回调
 *  @param progress           进度条回调
 */
- (void)uploadBatchFileWithRequestItemArray:(NSArray *)requestItemArray success:(MSSBatchRequestSuccessBlock)success fail:(MSSBatchRequestFailBlock)fail finish:(MSSBatchRequestFinishBlock)finish progress:(MSSBatchRequestProgressBlock)progress;
/**
 *  取消全部请求
 */
- (void)cancelBatchRequest;
@end
