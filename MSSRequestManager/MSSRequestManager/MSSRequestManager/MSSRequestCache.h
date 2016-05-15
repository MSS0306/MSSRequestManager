//
//  MSSRequestCache.h
//  MSSRequestManager
//
//  Created by 于威 on 16/5/9.
//  Copyright © 2016年 于威. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSSRequestModel.h"

@interface MSSRequestCache : NSObject

+ (MSSRequestCache *)sharedInstance;
// 获取缓存
- (NSDictionary *)getCacheDictWithRequestItem:(MSSRequestModel *)requestItem;
// 写入缓存
- (void)writeToCacheWithRequestItem:(MSSRequestModel *)requestItem;
// 清空指定缓存
- (void)clearCacheWithRequestItem:(MSSRequestModel *)requestItem;
// 清空指定文件夹内的缓存
- (void)clearFolderCacheWithRequestItem:(MSSRequestModel *)requestItem;
// 清空全部缓存
- (void)clearAllCache;
// 判断缓存是否过期
- (BOOL)cacheIsTimeOutWithRequestItem:(MSSRequestModel *)requestItem;

@end
