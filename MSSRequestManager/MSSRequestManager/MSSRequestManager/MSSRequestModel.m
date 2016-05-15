//
//  MSSRequestModel.m
//  MSSNetworkingManager
//
//  Created by 于威 on 16/5/1.
//  Copyright © 2016年 于威. All rights reserved.
//

#import "MSSRequestModel.h"

@implementation MSSRequestModel

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        _isFromCache = NO;
        _requestType = MSSRequestModelPostType;
        _uploadMimeType = @"image/jpeg";
        _cachePolicy = MSSRequestDefaultCachePolicy;
        _timeInterval = 60.0f;
        _baseUrl = @"http://v2.toys178.com/";
    }
    return self;
}

- (void)setRequestPath:(NSString *)requestPath
{
    _requestPath = requestPath;
    if(_baseUrl.length > 0)
    {
        _requestUrl = [NSString stringWithFormat:@"%@%@",_baseUrl,_requestPath];
    }
}


@end
