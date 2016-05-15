//
//  MSSRequest.m
//  MSSRequestManager
//
//  Created by 于威 on 16/5/7.
//  Copyright © 2016年 于威. All rights reserved.
//

#import "MSSRequest.h"
#import "AFNetworking.h"
#import "MSSRequestCache.h"

@implementation MSSRequest

// 普通Get,Post请求
- (void)startWithRequestItem:(MSSRequestModel *)requestItem success:(MSSRequestSuccessBlock)success fail:(MSSRequestFailBlock)fail
{
    if(requestItem.cachePolicy == MSSRequestUseLocalCachePolicy)
    {
        // 判断缓存时间是否已过期
        if(![[MSSRequestCache sharedInstance]cacheIsTimeOutWithRequestItem:requestItem])
        {
            // 未过期读取缓存
            NSDictionary *cacheDict = [self readCacheWithRequestItem:requestItem];
            if(cacheDict)
            {
                success(cacheDict);
                return;
            }
        }
    }
    AFHTTPSessionManager *sessionManager = [self createSessionManagerWithRequestItem:requestItem];
    NSURLSessionTask *task = nil;
    if(requestItem.requestType == MSSRequestModelGetType)
    {
        task = [sessionManager GET:requestItem.requestUrl parameters:requestItem.params progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self requestSuccessWithRequestItem:requestItem responseObject:responseObject success:success];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self requestFailWithRequestItem:requestItem error:error success:success fail:fail];
        }];
    }
    else
    {
        task = [sessionManager POST:requestItem.requestUrl parameters:requestItem.params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self requestSuccessWithRequestItem:requestItem responseObject:responseObject success:success];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self requestFailWithRequestItem:requestItem error:error success:success fail:fail];
        }];
    }
    if(task)
    {
        requestItem.task = task;
    }
}

// 上传文件
- (void)uploadFileWithRequestItem:(MSSRequestModel *)requestItem success:(MSSRequestSuccessBlock)success fail:(MSSRequestFailBlock)fail
{
    AFHTTPSessionManager *sessionManager = [self createSessionManagerWithRequestItem:requestItem];
    NSURLSessionTask *task = nil;
    // 优先使用设置AFMultipartFormDataBlock属性的请求
    if(requestItem.AFMultipartFormDataBlock)
    {
        task = [sessionManager POST:requestItem.requestUrl parameters:requestItem.params constructingBodyWithBlock:requestItem.AFMultipartFormDataBlock progress:^(NSProgress * _Nonnull uploadProgress) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                
//            });
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if(success)
            {
                success(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if(fail)
            {
                fail(error);
            }
        }];
    }
    else if(requestItem.uploadData)
    {
        task = [sessionManager POST:requestItem.requestUrl parameters:requestItem.params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            if(requestItem.uploadData)
            {
                [formData appendPartWithFileData:requestItem.uploadData name:requestItem.uploadName fileName:requestItem.uploadFileName mimeType:requestItem.uploadMimeType];
            }
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if(success)
            {
                success(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if(fail)
            {
                fail(error);
            }
        }];
    }
    if(task)
    {
        requestItem.task = task;
    }
}

#pragma mark Private Method
// 初始化AFHTTPSessionManager
- (AFHTTPSessionManager *)createSessionManagerWithRequestItem:(MSSRequestModel *)requestItem
{
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:sessionConfiguration];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    sessionManager.requestSerializer.timeoutInterval = requestItem.timeInterval;    
    if(requestItem.headers)
    {
        [requestItem.headers enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [sessionManager.requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }
    return sessionManager;
}

- (void)requestSuccessWithRequestItem:(MSSRequestModel *)requestItem responseObject:(id)responseObject success:(MSSRequestSuccessBlock)success
{
    if([responseObject isKindOfClass:[NSDictionary class]])
    {
        requestItem.responseDict = responseObject;
        if(requestItem.cachePolicy == MSSRequestAlwaysReplaceLocalCachePolicy || requestItem.cachePolicy == MSSRequestUseLocalCachePolicy)
        {
            // 写入缓存
            [[MSSRequestCache sharedInstance]writeToCacheWithRequestItem:requestItem];
        }
    }
    if(success)
    {
        success(responseObject);
    }
}

- (void)requestFailWithRequestItem:(MSSRequestModel *)requestItem error:(NSError *)error success:(MSSRequestSuccessBlock)success fail:(MSSRequestFailBlock)fail
{
    // 请求失败读取缓存
    if(requestItem.cachePolicy == MSSRequestAlwaysReplaceLocalCachePolicy)
    {
        NSDictionary *cacheDict = [self readCacheWithRequestItem:requestItem];
        if(cacheDict)
        {
            success(cacheDict);
        }
        else
        {
            if(fail)
            {
                fail(error);
            }
        }
    }
    else
    {
        if(fail)
        {
            fail(error);
        }
    }
}

- (NSDictionary *)readCacheWithRequestItem:(MSSRequestModel *)requestItem
{
    // 读取缓存
    NSDictionary *dict = [[MSSRequestCache sharedInstance]getCacheDictWithRequestItem:requestItem];
    if(dict)
    {
        requestItem.isFromCache = YES;
    }
    return dict;
}


@end
