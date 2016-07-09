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
#import "MSSRequestGenerator.h"

@interface MSSRequest ()

@property (nonatomic,strong)NSMutableDictionary *taskDict;
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
        _taskDict = [[NSMutableDictionary alloc]init];
    }
    return self;
}

- (NSURLSessionDataTask *)startWithRequestItem:(MSSRequestModel *)requestItem completion:(MSSRequestCompletionBlock)completion progress:(MSSRequestProgressBlock)progress
{
    NSURLRequest *request = nil;
    if(requestItem.request)
    {
        request = requestItem.request;
    }
    else
    {
        request = [MSSRequestGenerator generateRequestWithRequestItem:requestItem];
    }
    NSURLSessionDataTask *task = [_sessionManager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(uploadProgress.totalUnitCount > 0)
            {
                if(progress)
                {
                    progress(uploadProgress);
                }
            };
        });
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(downloadProgress.totalUnitCount > 0)
            {
                if(progress)
                {
                    progress(downloadProgress);
                }
            };
        });
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [_taskDict removeObjectForKey:@(task.taskIdentifier)];
        if(completion)
        {
            completion(responseObject,response,error);
        }
    }];
    [task resume];
    requestItem.taskIdentifier = task.taskIdentifier;
    [_taskDict setObject:task forKey:@(task.taskIdentifier)];
    return task;
}

- (void)cancelWithRequestItem:(MSSRequestModel *)requestItem
{
    NSNumber *taskKey = @(requestItem.taskIdentifier);
    NSURLSessionDataTask *task = _taskDict[taskKey];
    [task cancel];
    [_taskDict removeObjectForKey:taskKey];
}

- (void)cancelAllRequest
{
    [_taskDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSURLSessionDataTask *task = (NSURLSessionDataTask *)obj;
        [task cancel];
    }];
    [_taskDict removeAllObjects];
}

@end
