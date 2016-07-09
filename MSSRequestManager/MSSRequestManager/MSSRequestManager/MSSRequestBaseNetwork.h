//
//  MSSRequestBaseNetwork.h
//  MSSRequestManager
//
//  Created by 于威 on 16/7/3.
//  Copyright © 2016年 于威. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSSRequestManager.h"

typedef void(^MSSRequestBaseNetworkSuccessBlock)(MSSResponseModel *responseItem,id resultComponents);
typedef void(^MSSRequestBaseNetworkFailBlock)(MSSResponseModel *responseItem);

@interface MSSRequestBaseNetwork : NSObject

@property (nonatomic,strong)MSSRequestManager *manager;
@property (nonatomic,strong)MSSRequestModel *requestItem;

/**
 *  发起一个请求
 *
 *  @param success 请求成功回调
 *  @param fail    请求失败回调
 */
- (void)startRequestWithSuccess:(MSSRequestBaseNetworkSuccessBlock)success fail:(MSSRequestBaseNetworkFailBlock)fail;
/**
 *  发起一个请求
 *
 *  @param params  请求参数
 *  @param success 请求成功回调
 *  @param fail    请求失败回调
 */
- (void)startRequestWithParams:(NSDictionary *)params success:(MSSRequestBaseNetworkSuccessBlock)success fail:(MSSRequestBaseNetworkFailBlock)fail;
/**
 *  发起一个请求
 *
 *  @param params           请求参数
 *  @param loadingSuperView 请求加载框父视图
 *  @param success          请求成功回调
 *  @param fail             请求失败回调
 */
- (void)startRequestWithParams:(NSDictionary *)params loadingSuperView:(UIView *)loadingSuperView success:(MSSRequestBaseNetworkSuccessBlock)success fail:(MSSRequestBaseNetworkFailBlock)fail;

/**
 *  取消当前请求
 */
- (void)cancelRequest;

/**
 *  子类重写：设置请求参数
 */
- (void)setUpRequestItem;
/**
 *  子类重写：解析
 *
 *  @return 解析结果
 */
- (id)parseWithResponseObject:(id)responseObject;

@end
