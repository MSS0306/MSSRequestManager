//
//  MSSBatchRequestOperation.h
//  MSSRequestManager
//
//  Created by 于威 on 16/5/8.
//  Copyright © 2016年 于威. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSSRequestModel.h"

@class MSSBatchRequestOperation;
@protocol MSSBatchRequestOperationDelegate <NSObject>
- (void)requestSuccessResponseObject:(id)responseObject;
- (void)requestFailError:(NSError *)error;
- (void)batchOperation:(MSSBatchRequestOperation *)bacthOperation requestProgress:(NSProgress *)progress;
@end

@interface MSSBatchRequestOperation : NSOperation

@property (nonatomic,copy)NSString *operationTag;
@property (nonatomic,weak)id<MSSBatchRequestOperationDelegate> delegate;

- (instancetype)initWithRequestItem:(MSSRequestModel *)requestItem;
- (void)cancelRequest;

@end
