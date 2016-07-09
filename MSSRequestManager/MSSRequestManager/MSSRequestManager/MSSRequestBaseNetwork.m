//
//  MSSRequestBaseNetwork.m
//  MSSRequestManager
//
//  Created by 于威 on 16/7/3.
//  Copyright © 2016年 于威. All rights reserved.
//

#import "MSSRequestBaseNetwork.h"

@implementation MSSRequestBaseNetwork

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        _requestItem = [[MSSRequestModel alloc]init];
    }
    return self;
}

- (void)startRequestWithSuccess:(MSSRequestBaseNetworkSuccessBlock)success fail:(MSSRequestBaseNetworkFailBlock)fail
{
    [self startRequestWithParams:nil loadingSuperView:nil success:success fail:fail];
}

- (void)startRequestWithParams:(NSDictionary *)params success:(MSSRequestBaseNetworkSuccessBlock)success fail:(MSSRequestBaseNetworkFailBlock)fail
{
    [self startRequestWithParams:params loadingSuperView:nil success:success fail:fail];
}

- (void)startRequestWithParams:(NSDictionary *)params loadingSuperView:(UIView *)loadingSuperView success:(MSSRequestBaseNetworkSuccessBlock)success fail:(MSSRequestBaseNetworkFailBlock)fail
{
    if(params)
    {
        _requestItem.params = params;
    }
    if(loadingSuperView)
    {
        _requestItem.isShowLoadingView = YES;
        _requestItem.loadingSuperView = loadingSuperView;
    }
    // 子类重写设置请求参数
    [self setUpRequestItem];
        
    [self.manager startRequestItem:_requestItem Success:^(MSSRequestManager *manager) {
        if(success)
        {
            success(manager.responseItem,[self parseWithResponseObject:manager.responseItem.responseDict]);
        }
    } fail:^(MSSRequestManager *manager) {
        if(fail)
        {
            fail(manager.responseItem);
        }
    }];
}

- (void)cancelRequest
{
    [_manager cancelRequest];
}

- (void)setUpRequestItem
{
    NSAssert(NO, @"子类必须重写");
}

- (id)parseWithResponseObject:(id)responseObject
{
    return _manager.responseItem.responseDict;
}

- (MSSRequestManager *)manager
{
    if(!_manager)
    {
        _manager = [[MSSRequestManager alloc]init];
    }
    return _manager;
}

@end
