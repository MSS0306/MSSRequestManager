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

@interface MSSRequest ()

@property (nonatomic,strong)AFHTTPSessionManager *sessionManager;// 此对象创建多个会有内存泄漏

@end

@implementation MSSRequest

+ (MSSRequest *)sharedInstance
{
    static MSSRequest *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc]init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _sessionManager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:sessionConfiguration];
        _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    }
    return self;
}

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
    [self setSessionManagerWithRequestItem:requestItem];
    
    NSURLSessionTask *task = nil;
    if(requestItem.requestType == MSSRequestModelGetType)
    {
        task = [_sessionManager GET:requestItem.requestUrl parameters:requestItem.params progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self requestSuccessWithRequestItem:requestItem responseObject:responseObject success:success];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self requestFailWithRequestItem:requestItem error:error success:success fail:fail];
        }];
    }
    else
    {
        task = [_sessionManager POST:requestItem.requestUrl parameters:requestItem.params progress:^(NSProgress * _Nonnull uploadProgress) {
            
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
- (void)uploadFileWithRequestItem:(MSSRequestModel *)requestItem success:(MSSRequestSuccessBlock)success fail:(MSSRequestFailBlock)fail progress:(MSSRequestProgressBlock)progress
{
    NSURLSessionTask *task = nil;
    // 优先使用设置AFMultipartFormDataBlock属性的请求
    if(requestItem.AFMultipartFormDataBlock)
    {
        task = [_sessionManager POST:requestItem.requestUrl parameters:requestItem.params constructingBodyWithBlock:requestItem.AFMultipartFormDataBlock progress:^(NSProgress * _Nonnull uploadProgress) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(uploadProgress.totalUnitCount > 0)
                {
                    if(progress)
                    {
                        progress(uploadProgress);
                    }
                };
            });
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
        task = [_sessionManager POST:requestItem.requestUrl parameters:requestItem.params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
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

// 根据request上传文件
- (void)uploadFileWithRequest:(NSURLRequest *)request requestItem:(MSSRequestModel *)requestItem success:(MSSRequestSuccessBlock)success fail:(MSSRequestFailBlock)fail progress:(MSSRequestProgressBlock)progress
{
    NSURLSessionTask *task = [_sessionManager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(uploadProgress.totalUnitCount > 0)
            {
                if(progress)
                {
                    progress(uploadProgress);
                }
            };
        });
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if(error)
        {
            if(fail)
            {
                fail(error);
            }
        }
        else
        {
            if(success)
            {
                success(responseObject);
            }
        }
    }];
    [task resume];
    if(task)
    {
        requestItem.task = task;
    }
}

#pragma mark Private Method
// 初始化AFHTTPSessionManager
- (void)setSessionManagerWithRequestItem:(MSSRequestModel *)requestItem
{
    if(requestItem.requestSerializerType == MSSRequestSerializerHttpType)
    {
        _sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    else if(requestItem.requestSerializerType == MSSRequestSerializerJsonType)
    {
        _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    _sessionManager.requestSerializer.timeoutInterval = requestItem.timeInterval;
    if(requestItem.requestHeaders)
    {
        [requestItem.requestHeaders enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [_sessionManager.requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }
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
