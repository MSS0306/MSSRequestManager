//
//  MSSRequest.m
//  MSSRequestManager
//
//  Created by 于威 on 16/5/7.
//  Copyright © 2016年 于威. All rights reserved.
//

#import "MSSRequest.h"
#import "AFNetworking.h"

@implementation MSSRequest

- (void)startWithRequestItem:(MSSRequestModel *)requestItem success:(MSSRequestSuccessBlock)success fail:(MSSRequestFailBlock)fail
{
    AFHTTPSessionManager *sessionManager = [self createSessionManagerWithRequestItem:requestItem];
    NSURLSessionTask *task = nil;
    if(requestItem.requestType == MSSRequestModelGetType)
    {
        task = [sessionManager GET:requestItem.requestUrl parameters:requestItem.params progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if(success)
            {
                success(task,responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if(fail)
            {
                fail(task,error);
            }
        }];
    }
    else
    {
        task = [sessionManager POST:requestItem.requestUrl parameters:requestItem.params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if(success)
            {
                success(task,responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if(fail)
            {
                fail(task,error);
            }
        }];
    }
    if(task)
    {
        requestItem.task = task;
    }
}

- (void)uploadFileWithRequestItem:(MSSRequestModel *)requestItem success:(MSSRequestSuccessBlock)success fail:(MSSRequestFailBlock)fail
{
    AFHTTPSessionManager *sessionManager = [self createSessionManagerWithRequestItem:requestItem];
    NSURLSessionTask *task = [sessionManager POST:requestItem.requestUrl parameters:requestItem.params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if(requestItem.uploadData)
        {
            [formData appendPartWithFileData:requestItem.uploadData name:requestItem.uploadName fileName:requestItem.uploadFileName mimeType:requestItem.uploadMimeType];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success)
        {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(fail)
        {
            fail(task,error);
        }
    }];
    if(task)
    {
        requestItem.task = task;
    }
}

#pragma mark Private Method
- (AFHTTPSessionManager *)createSessionManagerWithRequestItem:(MSSRequestModel *)requestItem
{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    if(requestItem.headers)
    {
        [requestItem.headers enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [sessionManager.requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }
    return sessionManager;
}

@end
