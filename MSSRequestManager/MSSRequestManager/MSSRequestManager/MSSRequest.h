//
//  MSSRequest.h
//  MSSRequestManager
//
//  Created by 于威 on 16/5/7.
//  Copyright © 2016年 于威. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSSRequestModel.h"

typedef void(^MSSRequestSuccessBlock)(NSURLSessionDataTask *task,id responseObject);
typedef void(^MSSRequestFailBlock)(NSURLSessionDataTask *task, NSError *error);

@interface MSSRequest : NSObject

- (void)startWithRequestItem:(MSSRequestModel *)requestItem success:(MSSRequestSuccessBlock)success fail:(MSSRequestFailBlock)fail;
- (void)uploadFileWithRequestItem:(MSSRequestModel *)requestItem success:(MSSRequestSuccessBlock)success fail:(MSSRequestFailBlock)fail;

@end
