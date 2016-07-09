//
//  MSSResponseModel.h
//  MSSRequestManager
//
//  Created by 于威 on 16/6/18.
//  Copyright © 2016年 于威. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSSResponseModel : NSObject
/// 请求结果
@property (nonatomic,strong)NSDictionary *responseDict;
/// 是否来自缓存
@property (nonatomic,assign)BOOL isFromCache;
/// responseCode
@property (nonatomic,assign)NSInteger statusCode;
/// responseHeaders
@property (nonatomic,strong)NSDictionary *reponseHeaders;
/// error
@property (nonatomic,strong)NSError *error;

@end
