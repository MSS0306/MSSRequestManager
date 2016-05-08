//
//  MSSBatchRequest.h
//  MSSRequestManager
//
//  Created by 于威 on 16/5/8.
//  Copyright © 2016年 于威. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSSRequest.h"
#import "MSSBatchRequestOperation.h"

typedef void(^MSSBatchRequestFinish)(void);

@interface MSSBatchRequest : NSObject<MSSBatchRequestOperationDelegate>
- (void)uploadBatchFileWithRequestItemArray:(NSArray *)requestItemArray success:(MSSRequestSuccessBlock)success fail:(MSSRequestFailBlock)fail finish:(MSSBatchRequestFinish)finish;
- (void)cancelBatchRequest;
@end
