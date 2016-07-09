//
//  MSSRequestModel.h
//  MSSNetworkingManager
//
//  Created by 于威 on 16/5/1.
//  Copyright © 2016年 于威. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFURLRequestSerialization.h"


typedef NS_ENUM(NSInteger,MSSRequestSerializerType)
{
    MSSRequestSerializerHttpType = 0,
    MSSRequestSerializerJsonType
};

typedef NS_ENUM(NSInteger,MSSRequestCachePolicy)
{
    MSSRequestDefaultCachePolicy = 0,// 不使用缓存
    MSSRequestAlwaysReplaceLocalCachePolicy = 1,// 总是请求网络替换本地缓存，请求失败或者没网时使用本地缓存
    MSSRequestUseLocalCachePolicy = 2// 使用本地缓存，本地缓存不存在或者缓存时间过期的时候请求网络
};

typedef NS_ENUM(NSInteger,MSSRequestMethod)
{
    MSSRequestGetMethod = 0,
    MSSRequestPostMethod = 1,
    MSSRequestHeadMethod = 2,
    MSSRequestPutMethod = 3,
    MSSRequestPatchMethod = 4,
    MSSRequestDeleteMethod = 5
};

typedef NS_ENUM(NSInteger,MSSRequestLoadingType)
{
    MSSRequestCircleType = 0,// 转圈类型
    MSSRequestProgressType = 1// 进度条类型
};

@interface MSSRequestModel : NSObject
/// 请求任务唯一标识
@property (nonatomic,assign)NSInteger taskIdentifier;
/*
 设置请求属性
 */
/// post/get方法，默认为post方法
@property (nonatomic,assign)MSSRequestMethod requestMethod;
/// url地址
@property (nonatomic,copy)NSString *requestUrl;
/// 参数
@property (nonatomic,strong)NSDictionary *params;
/// heaer
@property (nonatomic,strong)NSDictionary *requestHeaders;
/// 请求超时时间，默认为60秒
@property (nonatomic,assign)NSTimeInterval timeInterval;
/// 请求格式
@property (nonatomic,assign)MSSRequestSerializerType requestSerializerType;
/// 上传formData
@property (nonatomic,copy)void(^AFMultipartFormDataBlock)(id<AFMultipartFormData>);
/// 自定义NSUrlRequest
@property (nonatomic,strong)NSURLRequest *request;
/*
 弹框相关设置
 */
/// 是否显示加载框
@property (nonatomic,assign)BOOL isShowLoadingView;
/// 设置加载框父视图（默认加在window上）
@property (nonatomic,strong)UIView *loadingSuperView;
/// 加载框类型
@property (nonatomic,assign)MSSRequestLoadingType loadingType;
/// 请求成功是否弹出提示框（默认关闭提示）
@property (nonatomic,assign)BOOL isShowSussessAlertView;
/// 请求成功弹出提示框内容
@property (nonatomic,copy)NSString *successAlertText;
/// 请求失败是否弹出提示框（默认开启提示）
@property (nonatomic,assign)BOOL isShowFailAlertView;
/// 请求失败弹出提示框内容
@property (nonatomic,copy)NSString *failAlertText;
/*
 缓存设置
 */
/// 指定缓存文件夹，按业务分文件夹便于清空缓存
@property (nonatomic,copy)NSString *cacheFolderName;
/// 缓存策略
@property (nonatomic,assign)MSSRequestCachePolicy cachePolicy;
/// cachePolicy为MSSRequestUseLocalCachePolicy时可设置缓存秒数
@property (nonatomic,assign)NSTimeInterval cacheSecond;


@end
