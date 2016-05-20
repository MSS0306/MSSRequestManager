//
//  MSSRequestModel.h
//  MSSNetworkingManager
//
//  Created by 于威 on 16/5/1.
//  Copyright © 2016年 于威. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFURLRequestSerialization.h"

@class AFURLRequestSerialization;

typedef NS_ENUM(NSInteger,MSSRequestCachePolicy)
{
    MSSRequestDefaultCachePolicy = 0,// 不使用缓存
    MSSRequestAlwaysReplaceLocalCachePolicy = 1,// 总是请求网络替换本地缓存，请求失败或者没网时使用本地缓存
    MSSRequestUseLocalCachePolicy = 2// 使用本地缓存，本地缓存不存在的时候请求网络
};

typedef NS_ENUM(NSInteger,MSSRequestModelType)
{
    MSSRequestModelGetType = 0,
    MSSRequestModelPostType
};

@interface MSSRequestModel : NSObject

/*
 执行请求时，封装时赋值
 */
/// 当前任务
@property (nonatomic,strong)NSURLSessionTask *task;
/// 结果response
@property (nonatomic,strong)NSDictionary *responseDict;
/// 是否来自缓存
@property (nonatomic,assign)BOOL isFromCache;

/*
 设置请求属性
 */
/// post/get方法，默认为post方法
@property (nonatomic,assign)MSSRequestModelType requestType;
/// baseUrl和requestPath共同使用（setRequestPath方法中赋值requestUrl）
@property (nonatomic,copy)NSString *baseUrl;
/// baseUrl和requestPath共同使用（setRequestPath方法中赋值requestUrl）
@property (nonatomic,copy)NSString *requestPath;
/// url地址
@property (nonatomic,copy)NSString *requestUrl;
/// 参数
@property (nonatomic,strong)NSDictionary *params;
/// heaer
@property (nonatomic,strong)NSDictionary *headers;
/// 请求超时时间，默认为60秒
@property (nonatomic,assign)NSTimeInterval timeInterval;
/// 设置加载框父视图（需要加载框时设置）
@property (nonatomic,strong)UIView *requestLoadingSuperView;

/*
 缓存设置
 */
/// 指定缓存文件夹，按业务分文件夹便于清空缓存
@property (nonatomic,copy)NSString *cacheFolderName;
/// 缓存策略
@property (nonatomic,assign)MSSRequestCachePolicy cachePolicy;
/// cachePolicy为MSSRequestUseLocalCachePolicy时可设置缓存秒数
@property (nonatomic,assign)NSTimeInterval cacheSecond;
/*
 上传文件
 */
/// 自己实现上传formData
@property (nonatomic,copy)void(^AFMultipartFormDataBlock)(id<AFMultipartFormData>);
/// 文件data
@property (nonatomic,copy)NSData *uploadData;
/// 服务端对应的名称
@property (nonatomic,copy)NSString *uploadName;
/// 上传图片名称
@property (nonatomic,copy)NSString *uploadFileName;
/*
 - `image/tiff`
 - `image/jpeg`
 - `image/gif`
 - `image/png`
 - `image/ico`
 - `image/x-icon`
 - `image/bmp`
 - `image/x-bmp`
 - `image/x-xbitmap`
 - `image/x-win-bitmap`
 */
/// 默认为image/jpeg
@property (nonatomic,copy)NSString *uploadMimeType;

@end
