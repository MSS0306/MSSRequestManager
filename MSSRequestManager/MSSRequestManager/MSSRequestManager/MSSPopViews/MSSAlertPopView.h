//
//  MSSAlertPopView.h
//  MSSRequestManager
//
//  Created by 于威 on 16/6/6.
//  Copyright © 2016年 于威. All rights reserved.
//

#import "MSSBasePopView.h"

typedef NS_ENUM(NSInteger,MSSAlertPopViewType)
{
    MSSAlertPopViewDefaultType = 0,// 默认类型
    MSSAlertPopViewSuccessType = 1,// 成功类型
    MSSAlertPopViewFailType = 2// 失败类型
};

@interface MSSAlertPopView : MSSBasePopView
/**
 *  显示提示弹窗
 *
 *  @param alertText 弹窗内容
 */
+ (void)showAlertPopViewWithAlertText:(NSString *)alertText;
/**
 *  成功提示弹窗
 *
 *  @param alertText 弹窗内容
 */
+ (void)showSuccessAlertPopViewWithAlertText:(NSString *)alertText;
/**
 *  失败提示弹窗
 *
 *  @param alertText 弹窗内容
 */
+ (void)showFailAlertPopViewWithAlertText:(NSString *)alertText;
/**
 *  初始化视图
 *
 *  @param alertText 弹框文字内容
 *  @param superView 所在父视图
 *
 *  @return self
 */
- (instancetype)initWithAlertText:(NSString *)alertText superView:(UIView *)superView;
/**
 *  初始化视图
 *
 *  @param alertText 弹框文字内容
 *  @param type      弹框类型
 *  @param superView 所在父视图
 *
 *  @return self
 */
- (instancetype)initWithAlertText:(NSString *)alertText type:(MSSAlertPopViewType)type superView:(UIView *)superView;

@end
