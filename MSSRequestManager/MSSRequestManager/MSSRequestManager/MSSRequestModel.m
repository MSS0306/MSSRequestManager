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
    }
    return self;
}


@end
