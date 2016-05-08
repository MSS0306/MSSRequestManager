//
//  MSSRequestModel.h
//  MSSNetworkingManager
//
//  Created by 于威 on 16/5/1.
//  Copyright © 2016年 于威. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,MSSRequestModelType)
{
    MSSRequestModelGetType = 0,
    MSSRequestModelPostType
};

@interface MSSRequestModel : NSObject

// 当前任务
@property (nonatomic,strong)NSURLSessionTask *task;
// post/get方法，默认为post方法
@property (nonatomic,assign)MSSRequestModelType requestType;
// url地址
@property (nonatomic,copy)NSString *requestUrl;
// 参数
@property (nonatomic,strong)NSDictionary *params;
// heaer
@property (nonatomic,strong)NSDictionary *headers;
/*
 上传文件
 */
// 文件data
@property (nonatomic,copy)NSData *uploadData;
// 服务端对应的名称
@property (nonatomic,copy)NSString *uploadName;
// 上传图片名称，默认为image/jpeg
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
@property (nonatomic,copy)NSString *uploadMimeType;

@end
