//
//  MSSBatchRequestOperation.m
//  MSSRequestManager
//
//  Created by 于威 on 16/5/8.
//  Copyright © 2016年 于威. All rights reserved.
//

#import "MSSBatchRequestOperation.h"
#import "MSSRequest.h"

@interface MSSBatchRequestOperation ()

@property (nonatomic,strong)MSSRequest *request;
@property (nonatomic,strong)MSSRequestModel *requestItem;
@property (nonatomic,assign)BOOL isExecuting;
@property (nonatomic,assign)BOOL isFinished;

@end

@implementation MSSBatchRequestOperation

- (instancetype)initWithRequestItem:(MSSRequestModel *)requestItem
{
    self = [super init];
    if(self)
    {
        _request = [[MSSRequest alloc]init];
        _requestItem = requestItem;
        _isExecuting = NO;
        _isFinished = NO;
    }
    return self;
}

- (void)start
{
    @synchronized (self) {
        if([self isCancelled])
        {
            self.isFinished = YES;
            return;
        }
        self.isExecuting = YES;
        [_request uploadFileWithRequestItem:_requestItem success:^(NSURLSessionDataTask *task, id responseObject) {
            if([_delegate respondsToSelector:@selector(requestSuccessTask:responseObject:)])
            {
                [_delegate requestSuccessTask:task responseObject:responseObject];
            }
            [self requestFinish];
        } fail:^(NSURLSessionDataTask *task, NSError *error) {
            if([_delegate respondsToSelector:@selector(requestFailTask:error:)])
            {
                [_delegate requestFailTask:task error:error];
            }
            [self requestFinish];
        }];
    }
}

- (void)requestFinish
{
    self.isExecuting = NO;
    self.isFinished = YES;
}

- (BOOL)isConcurrent
{
    return YES;
}

- (void)setIsExecuting:(BOOL)isExecuting
{
    @synchronized(self) {
        [self willChangeValueForKey:@"isExecuting"];
        _isExecuting = isExecuting;
        [self didChangeValueForKey:@"isExecuting"];
    }
}

- (void)setIsFinished:(BOOL)isFinished
{
    @synchronized(self) {
        [self willChangeValueForKey:@"isFinished"];
        _isFinished = isFinished;
        [self didChangeValueForKey:@"isFinished"];
    }
}

- (void)cancelRequest
{
    [_requestItem.task cancel];
    [super cancel];
}


@end
