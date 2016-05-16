//
//  MSSBatchRequest.m
//  MSSRequestManager
//
//  Created by 于威 on 16/5/8.
//  Copyright © 2016年 于威. All rights reserved.
//

#import "MSSBatchRequest.h"

@interface MSSBatchRequest ()

@property (nonatomic,strong)NSOperationQueue *queue;
@property (nonatomic,strong)NSArray *requestItemArray;
@property (nonatomic,assign)NSInteger successCount;
@property (nonatomic,assign)NSInteger failCount;
@property (nonatomic,copy)MSSRequestSuccessBlock success;
@property (nonatomic,copy)MSSRequestFailBlock fail;
@property (nonatomic,copy)MSSBatchRequestFinish finish;

@end

@implementation MSSBatchRequest

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        _queue = [[NSOperationQueue alloc]init];
        _queue.maxConcurrentOperationCount = 3;
        _successCount = 0;
        _failCount = 0;
    }
    return self;
}

- (void)uploadBatchFileWithRequestItemArray:(NSArray *)requestItemArray success:(MSSRequestSuccessBlock)success fail:(MSSRequestFailBlock)fail finish:(MSSBatchRequestFinish)finish
{
    _success = success;
    _fail = fail;
    _finish = finish;
    _requestItemArray = requestItemArray;
    for (MSSRequestModel *requestItem in _requestItemArray)
    {
        MSSBatchRequestOperation *operation = [[MSSBatchRequestOperation alloc]initWithRequestItem:requestItem];
        operation.delegate = self;
        [_queue addOperation:operation];
    }
}

- (void)requestSuccessResponseObject:(id)responseObject
{
    if(_success)
    {
        _success(responseObject);
    }
    _successCount++;
    [self requestFinish];
}

- (void)requestFailError:(NSError *)error
{
    if(_fail)
    {
        _fail(error);
    }
    _failCount++;
    [self requestFinish];
}

- (void)requestFinish
{
    if(_successCount + _failCount == _requestItemArray.count)
    {
        if(_finish)
        {
            _finish(_failCount);
        }
    }
}

- (void)cancelBatchRequest
{
    for (MSSBatchRequestOperation *operation in _queue.operations)
    {
        [operation cancelRequest];
    }
    _failCount = _requestItemArray.count - _successCount;
    if(_finish)
    {
        _finish(_failCount);
    }
}

@end
