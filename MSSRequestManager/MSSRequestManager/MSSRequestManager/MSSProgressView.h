//
//  MSSProgressView.h
//  MSSRequestManager
//
//  Created by 于威 on 16/6/1.
//  Copyright © 2016年 于威. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSSProgressView : UIView

@property (nonatomic,assign)CGFloat progress;
@property (nonatomic,copy)NSString *fileCountText;

/**
 *  显示进度条
 *
 *  @param superView 进度条父视图
 *
 *  @return 当前进度条View
 */
+ (MSSProgressView *)showProgressViewWithSuperView:(UIView *)superView;
/**
 *  隐藏近图条
 *
 *  @param superView 父视图
 */
+ (void)hideProgressViewWithSuperView:(UIView *)superView;
/**
 *  隐藏进度条
 */
- (void)hideProgressView;

@end
