//
//  MSSRequestManager.m
//  MSSRequestManager
//
//  Created by 于威 on 16/5/7.
//  Copyright © 2016年 于威. All rights reserved.
//

#import "MSSRequestManager.h"
#import "MSSRequestLoadingView.h"

@interface MSSRequestManager ()

@property (nonatomic,strong)NSMutableArray *requestItemArray;
@property (nonatomic,strong)MSSRequest *request;
@property (nonatomic,strong)MSSBatchRequest *batchRequest;

@end

@implementation MSSRequestManager

+ (MSSRequestManager *)sharedInstance
{
    static MSSRequestManager *sharedInstance;
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
        _requestItemArray = [[NSMutableArray alloc]init];
        _request = [[MSSRequest alloc]init];
    }
    return self;
}

- (void)startWithRequestItem:(MSSRequestModel *)requestItem success:(MSSRequestSuccessBlock)success fail:(MSSRequestFailBlock)fail
{
    // 显示加载框
    if(requestItem.requestLoadingSuperView)
    {
        [MSSRequestLoadingView showRequestLoadingViewWithSuperView:requestItem.requestLoadingSuperView];
    }
    
    [_request startWithRequestItem:requestItem success:^(id responseObject) {
        // 隐藏加载框
        if(requestItem.requestLoadingSuperView)
        {
            [MSSRequestLoadingView hideRequestLoadingViewWithSuperView:requestItem.requestLoadingSuperView];
        }
        [_requestItemArray removeObject:requestItem];
        if(success)
        {
            success(responseObject);
        }
    } fail:^(NSError *error) {
        // 隐藏加载框
        if(requestItem.requestLoadingSuperView)
        {
            [MSSRequestLoadingView hideRequestLoadingViewWithSuperView:requestItem.requestLoadingSuperView];
        }
        [_requestItemArray removeObject:requestItem];
        if(fail)
        {
            fail(error);
        }
    }];
    [_requestItemArray addObject:requestItem];
}

- (void)uploadFileWithRequestItem:(MSSRequestModel *)requestItem success:(MSSRequestSuccessBlock)success fail:(MSSRequestFailBlock)fail
{
    // 显示加载框
    if(requestItem.requestLoadingSuperView)
    {
        [MSSRequestLoadingView showRequestLoadingViewWithSuperView:requestItem.requestLoadingSuperView];
    }
    [_request uploadFileWithRequestItem:requestItem success:^(id responseObject) {
        // 隐藏加载框
        if(requestItem.requestLoadingSuperView)
        {
            [MSSRequestLoadingView hideRequestLoadingViewWithSuperView:requestItem.requestLoadingSuperView];
        }
        if(success)
        {
            success(responseObject);
        }
    } fail:^(NSError *error) {
        // 隐藏加载框
        if(requestItem.requestLoadingSuperView)
        {
            [MSSRequestLoadingView hideRequestLoadingViewWithSuperView:requestItem.requestLoadingSuperView];
        }
        if(fail)
        {
            fail(error);
        }
    }];
    [_requestItemArray addObject:requestItem];
}

#pragma mark Cancel Method
- (void)cancelWithRequestItem:(MSSRequestModel *)requestItem
{
    [requestItem.task cancel];
    [_requestItemArray removeObject:requestItem];
}

- (void)cancelAllRequest
{
    for (MSSRequestModel *requestItem in _requestItemArray)
    {
        [requestItem.task cancel];
    }
    [_requestItemArray removeAllObjects];
}

#pragma mark BatchRequest Method
// 批量上传图片
- (void)uploadBatchFileWithRequestItemArray:(NSArray *)requestItemArray success:(MSSRequestSuccessBlock)success fail:(MSSRequestFailBlock)fail finish:(MSSBatchRequestFinish)finish
{
    [self.batchRequest uploadBatchFileWithRequestItemArray:requestItemArray success:^(id responseObject) {
        if(success)
        {
            success(responseObject);
        }
    } fail:^(NSError *error) {
        if(fail)
        {
            fail(error);
        }
    } finish:^(NSInteger failCount) {
       if(finish)
       {
           finish(failCount);
       }
    }];
}

- (MSSBatchRequest *)batchRequest
{
    if(!_batchRequest)
    {
        _batchRequest = [[MSSBatchRequest alloc]init];
    }
    return _batchRequest;
}

- (void)cancelBatchRequest
{
    [_batchRequest cancelBatchRequest];
}

@end
