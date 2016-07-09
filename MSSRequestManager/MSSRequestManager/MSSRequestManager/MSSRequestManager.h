//
//  MSSRequestManager.h
//  MSSRequestManager
//
//  Created by 于威 on 16/7/3.
//  Copyright © 2016年 于威. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSSRequestModel.h"
#import "MSSResponseModel.h"

@class MSSRequestManager;
typedef void(^MSSRequestManagerSuccessBlock)(MSSRequestManager *manager);
typedef void(^MSSRequestManagerFailBlock)(MSSRequestManager *manager);

@interface MSSRequestManager : NSObject

@property (nonatomic,strong,readonly)MSSResponseModel *responseItem;
@property (nonatomic,strong,readonly)MSSRequestModel *requestItem;
/**
 *  发起一个请求
 *
 *  @param requestItem 请求数据对象
 *  @param success     请求成功回调
 *  @param fail        请求失败回调 
 */
- (void)startRequestItem:(MSSRequestModel *)requestItem Success:(MSSRequestManagerSuccessBlock)success fail:(MSSRequestManagerFailBlock)fail;
/**
 *  取消当前请求
 */
- (void)cancelRequest;

@end
