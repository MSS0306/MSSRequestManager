//
//  MSSBatchRequestOperation.h
//  MSSRequestManager
//
//  Created by 于威 on 16/5/8.
//  Copyright © 2016年 于威. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSSRequestModel.h"

@protocol MSSBatchRequestOperationDelegate <NSObject>
- (void)requestSuccessResponseObject:(id)responseObject;
- (void)requestFailError:(NSError *)error;
@end

@interface MSSBatchRequestOperation : NSOperation

@property (nonatomic,weak)id<MSSBatchRequestOperationDelegate> delegate;

- (instancetype)initWithRequestItem:(MSSRequestModel *)requestItem;
- (void)cancelRequest;

@end
