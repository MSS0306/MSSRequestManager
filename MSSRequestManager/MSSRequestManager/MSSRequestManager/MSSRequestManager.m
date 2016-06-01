//
//  MSSRequestManager.m
//  MSSRequestManager
//
//  Created by 于威 on 16/5/7.
//  Copyright © 2016年 于威. All rights reserved.
//

#import "MSSRequestManager.h"
#import "MSSRequestLoadingView.h"
#import "MSSAlertView.h"

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
    MSSRequestLoadingView *requestLoadingView = nil;
    if(requestItem.isShowLoadingView)
    {
        UIView *superView = requestItem.requestLoadingSuperView ? requestItem.requestLoadingSuperView : [UIApplication sharedApplication].keyWindow;
        requestLoadingView = [MSSRequestLoadingView showRequestLoadingViewWithSuperView:superView];
    }
    [_request startWithRequestItem:requestItem success:^(id responseObject) {
        // 隐藏加载框
        if(requestItem.isShowLoadingView)
        {
            [requestLoadingView hideRequestLoadingView];
        }
        [_requestItemArray removeObject:requestItem];
        if(success)
        {
            success(responseObject);
        }
    } fail:^(NSError *error) {
        // 请求失败提示弹框
        [self showAlertViewWithRequestItem:requestItem];
        // 隐藏加载框
        if(requestItem.isShowLoadingView)
        {
            [requestLoadingView hideRequestLoadingView];
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
    MSSRequestLoadingView *requestLoadingView = nil;
    if(requestItem.isShowLoadingView)
    {
        UIView *superView = requestItem.requestLoadingSuperView ? requestItem.requestLoadingSuperView : [UIApplication sharedApplication].keyWindow;
        requestLoadingView = [MSSRequestLoadingView showRequestLoadingViewWithSuperView:superView];
    }
    [_request uploadFileWithRequestItem:requestItem success:^(id responseObject) {
        // 隐藏加载框
        if(requestItem.isShowLoadingView)
        {
            [requestLoadingView hideRequestLoadingView];
        }
        if(success)
        {
            success(responseObject);
        }
    } fail:^(NSError *error) {
        // 隐藏加载框
        if(requestItem.isShowLoadingView)
        {
            [requestLoadingView hideRequestLoadingView];
        }
        // 请求失败提示弹框
        [self showAlertViewWithRequestItem:requestItem];
        if(fail)
        {
            fail(error);
        }
    }];
    [_requestItemArray addObject:requestItem];
}
// 请求失败提示弹框
- (void)showAlertViewWithRequestItem:(MSSRequestModel *)requestItem
{
    if(requestItem.isShowFailAlertView)
    {
        NSString *alertText = nil;
        if(requestItem.failAlertText)
        {
            alertText = requestItem.failAlertText;
        }
        else
        {
            alertText = @"网络异常";
        }
        [MSSAlertView showAlertViewWithText:alertText delay:1.0f];
    }
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
