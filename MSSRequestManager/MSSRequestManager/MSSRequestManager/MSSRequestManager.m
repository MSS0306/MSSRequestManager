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
#import "MSSProgressView.h"

@interface MSSRequestManager ()

@property (nonatomic,strong)NSMutableArray *requestItemArray;
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
    }
    return self;
}

- (void)startWithRequestItem:(MSSRequestModel *)requestItem success:(MSSRequestSuccessBlock)success fail:(MSSRequestFailBlock)fail
{
    // 显示加载框
    if(requestItem.isShowLoadingView)
    {
        if(!requestItem.requestLoadingSuperView)
        {
            requestItem.requestLoadingSuperView = [UIApplication sharedApplication].keyWindow;
        }
        [MSSRequestLoadingView showRequestLoadingViewWithSuperView:requestItem.requestLoadingSuperView];
    }

    [[MSSRequest sharedInstance]startWithRequestItem:requestItem success:^(id responseObject) {
        [self hideRequestViewWithRequestItem:requestItem];
        // 请求成功提示弹框
        [self showSuccessAlertViewWithRequestItem:requestItem];
        [_requestItemArray removeObject:requestItem];
        if(success)
        {
            success(responseObject);
        }
    } fail:^(NSError *error) {
        [self hideRequestViewWithRequestItem:requestItem];
        // 请求失败提示弹框
        [self showFailAlertViewWithRequestItem:requestItem];
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
    MSSProgressView *progressView = nil;
    // 显示进度条
    if(requestItem.isShowProgressView)
    {
        if(!requestItem.requestProgressSuperView)
        {
            requestItem.requestProgressSuperView = [UIApplication sharedApplication].keyWindow;
        }
        progressView = [MSSProgressView showProgressViewWithSuperView:requestItem.requestProgressSuperView];
    }
    // 显示加载框
    else if(requestItem.isShowLoadingView)
    {
        if(!requestItem.requestLoadingSuperView)
        {
            requestItem.requestLoadingSuperView = [UIApplication sharedApplication].keyWindow;
        }
        [MSSRequestLoadingView showRequestLoadingViewWithSuperView:requestItem.requestLoadingSuperView];
    }
    [[MSSRequest sharedInstance]uploadFileWithRequestItem:requestItem success:^(id responseObject) {
        [self hideRequestViewWithRequestItem:requestItem];
        // 请求成功提示弹框
        [self showSuccessAlertViewWithRequestItem:requestItem];
        [_requestItemArray removeObject:requestItem];
        if(success)
        {
            success(responseObject);
        }
    } fail:^(NSError *error) {
        [self hideRequestViewWithRequestItem:requestItem];
        // 请求失败提示弹框
        [self showFailAlertViewWithRequestItem:requestItem];
        [_requestItemArray removeObject:requestItem];
        if(fail)
        {
            fail(error);
        }
    } progress:^(NSProgress *progress) {
        if(requestItem.isShowProgressView)
        {
            progressView.progress = progress.fractionCompleted;
        }
    }];
    [_requestItemArray addObject:requestItem];
}
// 请求成功提示弹框
- (void)showSuccessAlertViewWithRequestItem:(MSSRequestModel *)requestItem
{
    if(requestItem.isShowSussessAlertView)
    {
        if(requestItem.successAlertText)
        {
            [MSSAlertView showAlertViewWithText:requestItem.successAlertText delay:1.0f];
        }
    }
}
// 请求失败提示弹框
- (void)showFailAlertViewWithRequestItem:(MSSRequestModel *)requestItem
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
    [self hideRequestViewWithRequestItem:requestItem];
    [requestItem.task cancel];
    [_requestItemArray removeObject:requestItem];
}

- (void)cancelAllRequest
{
    for (MSSRequestModel *requestItem in _requestItemArray)
    {
        [self hideRequestViewWithRequestItem:requestItem];
        [requestItem.task cancel];
    }
    [_requestItemArray removeAllObjects];
}

- (void)hideRequestViewWithRequestItem:(MSSRequestModel *)requestItem
{
    // 隐藏进度条
    if(requestItem.isShowProgressView)
    {
        [MSSProgressView hideProgressViewWithSuperView:requestItem.requestProgressSuperView];
    }
    // 隐藏加载框
    else if(requestItem.isShowLoadingView)
    {
        [MSSRequestLoadingView hideRequestLoadingViewWithSuperView:requestItem.requestLoadingSuperView];
    }
}

#pragma mark BatchRequest Method
// 批量上传图片
- (void)uploadBatchFileWithRequestItemArray:(NSArray *)requestItemArray success:(MSSRequestSuccessBlock)success fail:(MSSRequestFailBlock)fail finish:(MSSBatchRequestFinishBlock)finish
{
    MSSProgressView *progressView = [MSSProgressView showProgressViewWithSuperView:[UIApplication sharedApplication].keyWindow];
    [self.batchRequest uploadBatchFileWithRequestItemArray:requestItemArray success:^(id responseObject,NSInteger successCount) {
        progressView.fileCountText = [NSString stringWithFormat:@"%ld",self.batchRequest.successCount];
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
        [progressView hideProgressView];
        if(finish)
        {
            finish(failCount);
        }
    } progress:^(CGFloat progress) {
        progressView.progress = progress;
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
