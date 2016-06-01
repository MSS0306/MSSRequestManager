//
//  MSSAlertView.h
//  MSSRequestManager
//
//  Created by 于威 on 16/6/1.
//  Copyright © 2016年 于威. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSSAlertView : UIView

/**
 *  显示提示框
 *
 *  @param text 提示文字
 *  @param time 提示文字时间
 */
+ (void)showAlertViewWithText:(NSString *)text delay:(NSTimeInterval)time;

@end
