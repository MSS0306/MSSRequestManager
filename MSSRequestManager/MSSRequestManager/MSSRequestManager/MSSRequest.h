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

@interface MSSRequest : NSObject

// 普通Get,Post请求
- (void)startWithRequestItem:(MSSRequestModel *)requestItem success:(MSSRequestSuccessBlock)success fail:(MSSRequestFailBlock)fail;
// 上传文件
- (void)uploadFileWithRequestItem:(MSSRequestModel *)requestItem success:(MSSRequestSuccessBlock)success fail:(MSSRequestFailBlock)fail;

@end
