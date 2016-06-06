//
//  MSSBasePopView.h
//  MSSRequestManager
//
//  Created by 于威 on 16/6/5.
//  Copyright © 2016年 于威. All rights reserved.
//



#import <UIKit/UIKit.h>

typedef void(^MSSBasePopViewCompletionBlock)(void);

typedef NS_ENUM(NSInteger,MSSPopViewAnimationType)
{
    MSSPopViewAnimationAlphaType = 0,
    MSSPopViewAnimationTransformType = 1
};

@interface MSSBasePopView : UIView

/// 是否显示动画
@property (nonatomic,assign)BOOL animation;
/// 动画执行时间
@property (nonatomic,assign)NSTimeInterval time;
/// 动画类型
@property (nonatomic,assign)MSSPopViewAnimationType animationType;

/**
 *  显示弹窗
 *
 *  @return self
 */
+ (MSSBasePopView *)showPopView;
/**
 *  显示弹窗
 *
 *  @param superView 弹窗所在父视图
 *
 *  @return self
 */
+ (MSSBasePopView *)showPopViewWithSuperView:(UIView *)superView;
/**
 *  隐藏弹窗
 *
 *  @param superView  弹窗所在父视图
 */
+ (void)hidePopViewWithSuperView:(UIView *)superView;
/**
 *  隐藏弹窗
 *
 *  @param superView  弹窗所在父视图
 *  @param completion 隐藏弹窗完成回调
 */
+ (void)hidePopViewWithSuperView:(UIView *)superView completion:(MSSBasePopViewCompletionBlock)completion;
/**
 *  初始化弹窗
 *
 *  @param superView 弹窗所在父视图
 *
 *  @return self
 */
- (instancetype)initWithSuperView:(UIView *)superView;
/**
 *  显示弹窗
 */
- (void)showPopView;
/**
 *  显示弹窗
 *
 *  @param showTime   弹窗显示时间
 *  @param completion 隐藏弹窗完成回调
 */
- (void)showPopViewWithShowTime:(NSTimeInterval)showTime completion:(MSSBasePopViewCompletionBlock)completion;
/**
 *  隐藏弹窗
 *
 *  @param completion 隐藏弹窗完成回调
 */
- (void)hidePopViewWithCompletion:(MSSBasePopViewCompletionBlock)completion;

@end
