//
//  MSSRequestManager.m
//  MSSRequestManager
//
//  Created by 于威 on 16/5/7.
//  Copyright © 2016年 于威. All rights reserved.
//

#import "MSSRequestManager.h"

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
    [_request startWithRequestItem:requestItem success:^(NSURLSessionDataTask *task, id responseObject) {
        [_requestItemArray removeObject:requestItem];
        if(success)
        {
            success(task,responseObject);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [_requestItemArray removeObject:requestItem];
        if(fail)
        {
            fail(task,error);
        }
    }];
    [_requestItemArray addObject:requestItem];
}

- (void)uploadFileWithRequestItem:(MSSRequestModel *)requestItem success:(MSSRequestSuccessBlock)success fail:(MSSRequestFailBlock)fail
{
    [_request uploadFileWithRequestItem:requestItem success:^(NSURLSessionDataTask *task, id responseObject) {
        if(success)
        {
            success(task,responseObject);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        if(fail)
        {
            fail(task,error);
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
    [self.batchRequest uploadBatchFileWithRequestItemArray:requestItemArray success:^(NSURLSessionDataTask *task, id responseObject) {
        if(success)
        {
            success(task,responseObject);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        if(fail)
        {
            fail(task,error);
        }
    } finish:^{
        if(finish)
        {
            finish();
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
