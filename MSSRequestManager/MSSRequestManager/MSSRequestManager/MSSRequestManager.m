//
//  MSSRequestManager.m
//  MSSRequestManager
//
//  Created by 于威 on 16/7/3.
//  Copyright © 2016年 于威. All rights reserved.
//

#import "MSSRequestManager.h"
#import "MSSRequest.h"
#import "MSSRequestCache.h"
#import "MSSBasePopView.h"
#import "MSSCirclePopView.h"
#import "MSSProgressPopView.h"
#import "MSSAlertPopView.h"

@implementation MSSRequestManager

- (instancetype)init
{
    if(self)
    {
        _responseItem = [[MSSResponseModel alloc]init];
    }
    return self;
}

- (void)startRequestItem:(MSSRequestModel *)requestItem Success:(MSSRequestManagerSuccessBlock)success fail:(MSSRequestManagerFailBlock)fail
{
    _requestItem = requestItem;
    if(_requestItem.cachePolicy == MSSRequestUseLocalCachePolicy)
    {
        // 判断缓存时间是否已过期
        if(![[MSSRequestCache sharedInstance]cacheIsTimeOutWithRequestItem:_requestItem])
        {
            // 未过期读取缓存
            NSDictionary *cacheDict = [self readCache];
            if(cacheDict)
            {
                success(self);
                return;
            }
        }
    }
    MSSBasePopView *loadingView = [self showPopViewWithRequestItem:_requestItem];
    // 发送请求
    [[MSSRequest sharedInstance]startWithRequestItem:_requestItem completion:^(id responseObject, NSURLResponse *response, NSError *error) {
        
        [self hideRequestViewWithRequestItem:_requestItem];
        
        if([response isKindOfClass:[NSHTTPURLResponse class]])
        {
            _responseItem.reponseHeaders = ((NSHTTPURLResponse *)response).allHeaderFields;
            _responseItem.statusCode = ((NSHTTPURLResponse *)response).statusCode;
        }
        // 请求失败
        if(error)
        {
            _responseItem.error = error;
            [self requestSuccess:success fail:fail];
            // 显示失败提示
            [self showFailAlertViewWithRequestItem:_requestItem];
        }
        // 请求成功
        else
        {
            if([responseObject isKindOfClass:[NSDictionary class]])
            {
                _responseItem.responseDict = responseObject;
                [self requestSuccess:success];
            }
            // 显示成功提示
            [self showSuccessAlertViewWithRequestItem:_requestItem];
        }
    } progress:^(NSProgress *progress) {
        if(_requestItem.isShowLoadingView && _requestItem.loadingType == MSSRequestProgressType)
        {
            MSSProgressPopView *progressPopView = (MSSProgressPopView *)loadingView;
            progressPopView.progress = progress.fractionCompleted;
        }
    }];
}

- (void)cancelRequest
{
    [[MSSRequest sharedInstance]cancelWithRequestItem:_requestItem];
    [self hideRequestViewWithRequestItem:_requestItem];
}

- (void)requestSuccess:(MSSRequestManagerSuccessBlock)success
{
    if(_requestItem.cachePolicy == MSSRequestAlwaysReplaceLocalCachePolicy || _requestItem.cachePolicy == MSSRequestUseLocalCachePolicy)
    {
        // 写入缓存
        [[MSSRequestCache sharedInstance]writeToCacheWithRequestItem:_requestItem dict:_responseItem.responseDict];
    }
    if(success)
    {
        success(self);
    }
}

- (void)requestSuccess:(MSSRequestManagerSuccessBlock)success fail:(MSSRequestManagerFailBlock)fail
{
    // 请求失败读取缓存
    if(_requestItem.cachePolicy == MSSRequestAlwaysReplaceLocalCachePolicy)
    {
        NSDictionary *cacheDict = [self readCache];
        if(cacheDict)
        {
            success(self);
        }
        else
        {
            if(fail)
            {
                fail(self);
            }
        }
    }
    else
    {
        if(fail)
        {
            fail(self);
        }
    }
}

- (NSDictionary *)readCache
{
    // 读取缓存
    NSDictionary *dict = [[MSSRequestCache sharedInstance]getCacheDictWithRequestItem:_requestItem];
    if(dict)
    {
        _responseItem.isFromCache = YES;
        _responseItem.responseDict = dict;
    }
    return dict;
}

#pragma mark PopView Method
// 显示loading框
- (MSSBasePopView *)showPopViewWithRequestItem:(MSSRequestModel *)requestItem
{
    if(requestItem.isShowLoadingView)
    {
        if(!requestItem.loadingSuperView)
        {
            requestItem.loadingSuperView = [UIApplication sharedApplication].keyWindow;
        }
        MSSBasePopView *popView = nil;
        if(requestItem.loadingType == MSSRequestCircleType)
        {
            popView = [[MSSCirclePopView alloc]initWithSuperView:requestItem.loadingSuperView];
        }
        else
        {
            popView = [[MSSProgressPopView alloc]initWithSuperView:requestItem.loadingSuperView];
        }
        [popView showPopView];
        return popView;
    }
    return nil;
}

// 隐藏loading框
- (void)hideRequestViewWithRequestItem:(MSSRequestModel *)requestItem
{
    if(requestItem.isShowLoadingView)
    {
        [MSSBasePopView hidePopViewWithSuperView:requestItem.loadingSuperView];
    }
}

// 请求成功提示弹框
- (void)showSuccessAlertViewWithRequestItem:(MSSRequestModel *)requestItem
{
    if(requestItem.isShowSussessAlertView)
    {
        if(requestItem.successAlertText)
        {
            [MSSAlertPopView showSuccessAlertPopViewWithAlertText:requestItem.successAlertText];
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
        [MSSAlertPopView showFailAlertPopViewWithAlertText:alertText];
    }
}


@end
