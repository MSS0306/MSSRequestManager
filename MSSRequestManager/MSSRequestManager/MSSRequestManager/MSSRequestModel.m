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
        _requestType = MSSRequestModelPostType;
        _uploadMimeType = @"image/jpeg";
    }
    return self;
}


@end
