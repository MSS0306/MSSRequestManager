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
        _requestItem = requestItem;
        _isExecuting = NO;
        _isFinished = NO;
    }
    return self;
}

- (void)start
{
    @synchronized(self)
    {
        if([self isCancelled])
        {
            self.isFinished = YES;
            return;
        }
        self.isExecuting = YES;
        
        [[MSSRequest sharedInstance]uploadFileWithRequestItem:_requestItem success:^(id responseObject) {
            if([_delegate respondsToSelector:@selector(requestSuccessResponseObject:)])
            {
                [_delegate requestSuccessResponseObject:responseObject];
            }
            [self requestFinish];
        } fail:^(NSError *error) {
            if([_delegate respondsToSelector:@selector(requestFailError:)])
            {
                [_delegate requestFailError:error];
            }
            [self requestFinish];
        }progress:^(NSProgress *progress) {
            
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
    [self willChangeValueForKey:@"isExecuting"];
    _isExecuting = isExecuting;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)setIsFinished:(BOOL)isFinished
{
    [self willChangeValueForKey:@"isFinished"];
    _isFinished = isFinished;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)cancelRequest
{
    [_requestItem.task cancel];
    [super cancel];
}


@end
