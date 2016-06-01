//
//  MSSRequestLoadingView.h
//  MSSRequestManager
//
//  Created by 于威 on 16/5/16.
//  Copyright © 2016年 于威. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSSRequestLoadingView : UIView

/**
 *  显示加载等待框
 *
 *  @param superView 父视图
 *
 *  @return 当前加载框
 */
+ (MSSRequestLoadingView *)showRequestLoadingViewWithSuperView:(UIView *)superView;
/**
 *  隐藏加载等待框
 */
- (void)hideRequestLoadingView;

@end
