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
- (void)startWithRequestItem:(MSSRequestModel *)requestItem success:(MSSRequestSuccessBlock)success fail:(MSSRequestFailBlock)fail;
- (void)uploadFileWithRequestItem:(MSSRequestModel *)requestItem success:(MSSRequestSuccessBlock)success fail:(MSSRequestFailBlock)fail;
- (void)cancelWithRequestItem:(MSSRequestModel *)requestItem;
- (void)cancelAllRequest;

// 批量上传图片
- (void)uploadBatchFileWithRequestItemArray:(NSArray *)requestItemArray success:(MSSRequestSuccessBlock)success fail:(MSSRequestFailBlock)fail finish:(MSSBatchRequestFinish)finish;
- (void)cancelBatchRequest;

@end
