//
//  MSSRequestGenerator.m
//  MSSRequestManager
//
//  Created by 于威 on 16/6/18.
//  Copyright © 2016年 于威. All rights reserved.
//

#import "MSSRequestGenerator.h"
#import "AFURLRequestSerialization.h"
#import "MSSRequestConfig.h"

@implementation MSSRequestGenerator

+ (NSURLRequest *)generateRequestWithRequestItem:(MSSRequestModel *)requestItem
{
    AFHTTPRequestSerializer *requestSerializer = nil;
    if(requestItem.requestSerializerType == MSSRequestSerializerHttpType)
    {
        requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    else if(requestItem.requestSerializerType == MSSRequestSerializerJsonType)
    {
        requestSerializer = [AFJSONRequestSerializer serializer];
    }
    requestSerializer.timeoutInterval = requestItem.timeInterval;
    if(requestItem.requestHeaders)
    {
        [requestItem.requestHeaders enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    
    NSDictionary *commonParams = [MSSRequestConfig commonParams];
    if(commonParams)
    {
        [params addEntriesFromDictionary:commonParams];
    }
    [params addEntriesFromDictionary:requestItem.params];
    
    NSMutableURLRequest *request = nil;
    if(requestItem.AFMultipartFormDataBlock)
    {
        request = [requestSerializer multipartFormRequestWithMethod:[self getRequestMethodWithMethod:requestItem.requestMethod] URLString:requestItem.requestUrl parameters:params constructingBodyWithBlock:requestItem.AFMultipartFormDataBlock error:nil];
    }
    else
    {
        request = [requestSerializer requestWithMethod:[self getRequestMethodWithMethod:requestItem.requestMethod] URLString:requestItem.requestUrl parameters:params error:nil];
    }
    return request;
}

+ (NSString *)getRequestMethodWithMethod:(MSSRequestMethod)method
{
    switch (method)
    {
        case MSSRequestGetMethod:
            return @"GET";
            break;
            
        case MSSRequestPostMethod:
            return @"POST";
            break;
            
        case MSSRequestHeadMethod:
            return @"HEAD";
            break;
            
        case MSSRequestPutMethod:
            return @"PUT";
            break;
            
        case MSSRequestPatchMethod:
            return @"PATCH";
            break;
            
        case MSSRequestDeleteMethod:
            return @"DELETE";
            break;
    }
}

@end
