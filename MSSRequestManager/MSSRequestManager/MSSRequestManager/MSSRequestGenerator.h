//
//  MSSRequestGenerator.h
//  MSSRequestManager
//
//  Created by 于威 on 16/6/18.
//  Copyright © 2016年 于威. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSSRequestModel.h"

@interface MSSRequestGenerator : NSObject

/**
 *  生成Request对象
 *
 *  @param requestItem 请求参数数据对象
 *
 *  @return request
 */
+ (NSURLRequest *)generateRequestWithRequestItem:(MSSRequestModel *)requestItem;

@end
