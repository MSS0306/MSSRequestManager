//
//  MSSRequestLoadingView.h
//  MSSRequestManager
//
//  Created by 于威 on 16/5/16.
//  Copyright © 2016年 于威. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSSRequestLoadingView : UIView

+ (void)showRequestLoadingViewWithSuperView:(UIView *)superView;
+ (void)hideRequestLoadingViewWithSuperView:(UIView *)superView;

@end
