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
@property (nonatomic,assign)int64_t totalLength;// 所有请求总长度
@property (nonatomic,assign)int64_t completedLength;// 完成的进度
@property (nonatomic,strong)NSMutableDictionary *operationCompletedDict;// 每个线程完成的进度
@property (nonatomic,assign)NSInteger failCount;// 请求失败个数
@property (nonatomic,copy)MSSBatchRequestSuccessBlock success;
@property (nonatomic,copy)MSSBatchRequestFailBlock fail;
@property (nonatomic,copy)MSSBatchRequestFinishBlock finish;
@property (nonatomic,copy)MSSBatchRequestProgressBlock progress;

@end

@implementation MSSBatchRequest

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        _queue = [[NSOperationQueue alloc]init];
        _queue.maxConcurrentOperationCount = 4;
        _successCount = 0;
        _failCount = 0;
        _totalLength = 0;
        _completedLength = 0;
        _operationCompletedDict = [[NSMutableDictionary alloc]init];
    }
    return self;
}

- (void)uploadBatchFileWithRequestItemArray:(NSArray *)requestItemArray success:(MSSBatchRequestSuccessBlock)success fail:(MSSBatchRequestFailBlock)fail finish:(MSSBatchRequestFinishBlock)finish progress:(MSSBatchRequestProgressBlock)progress
{
    _successCount = 0;
    _failCount = 0;
    _totalLength = 0;
    _completedLength = 0;
    [_operationCompletedDict removeAllObjects];
    _success = success;
    _fail = fail;
    _finish = finish;
    _progress = progress;
    _requestItemArray = requestItemArray;
    int i = 0;
    for (MSSRequestModel *requestItem in _requestItemArray)
    {
        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:requestItem.requestUrl parameters:requestItem.params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            if(requestItem.uploadData)
            {
                [formData appendPartWithFileData:requestItem.uploadData name:requestItem.uploadName fileName:requestItem.uploadFileName mimeType:requestItem.uploadMimeType];
            }
        } error:nil];
        NSString *uploadLength = request.allHTTPHeaderFields[@"Content-Length"];
        if(uploadLength)
        {
            _totalLength += [uploadLength longLongValue];
        }
        MSSBatchRequestOperation *operation = [[MSSBatchRequestOperation alloc]initWithRequest:request requestItem:requestItem];
        operation.operationTag = [NSString stringWithFormat:@"%d",i + 1];
        operation.delegate = self;
        [_queue addOperation:operation];
        i++;
    }
}

- (void)requestSuccessResponseObject:(id)responseObject
{
    _successCount++;
    [self requestFinish];
    if(_success)
    {
        _success(responseObject,_successCount);
    }
}

- (void)requestFailError:(NSError *)error
{
    _failCount++;
    [self requestFinish];
    if(_fail)
    {
        _fail(error);
    }
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

- (void)batchOperation:(MSSBatchRequestOperation *)bacthOperation requestProgress:(NSProgress *)progress
{
    [_operationCompletedDict setObject:[NSString stringWithFormat:@"%lld",progress.completedUnitCount] forKey:bacthOperation.operationTag];
    if(bacthOperation.isFinished)
    {
        _completedLength += [_operationCompletedDict[bacthOperation.operationTag]longLongValue];
        [_operationCompletedDict removeObjectForKey:bacthOperation.operationTag];
    }
    __block int64_t uploadingProgress = 0;
    [_operationCompletedDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        uploadingProgress += [obj longLongValue];
    }];
    
    if(_progress)
    {
        CGFloat resultProgress = (CGFloat)(uploadingProgress + _completedLength) / (CGFloat)(_totalLength);
        _progress(resultProgress);
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
