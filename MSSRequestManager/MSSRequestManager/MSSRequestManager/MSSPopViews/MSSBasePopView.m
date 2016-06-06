//
//  MSSBasePopView.m
//  MSSRequestManager
//
//  Created by 于威 on 16/6/5.
//  Copyright © 2016年 于威. All rights reserved.
//

#import "MSSBasePopView.h"

@implementation MSSBasePopView

+ (MSSBasePopView *)showPopView
{
    MSSBasePopView *popView = [[self alloc]initWithSuperView:[UIApplication sharedApplication].keyWindow];
    [popView showPopView];
    return popView;
}

+ (MSSBasePopView *)showPopViewWithSuperView:(UIView *)superView
{
    MSSBasePopView *popView = [[self alloc]initWithSuperView:superView];
    [popView showPopView];
    return popView;
}

+ (void)hidePopViewWithSuperView:(UIView *)superView
{
    [self hidePopViewWithSuperView:superView completion:nil];
}

+ (void)hidePopViewWithSuperView:(UIView *)superView completion:(MSSBasePopViewCompletionBlock)completion
{
    for (UIView *subView in superView.subviews)
    {
        if([subView isKindOfClass:[self class]])
        {
            MSSBasePopView *popView = (MSSBasePopView *)subView;
            [popView hidePopViewWithCompletion:completion];
            break;
        }
    }
}

- (instancetype)initWithSuperView:(UIView *)superView
{
    self = [super initWithFrame:superView.bounds];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        _animation = NO;
        _animationType = MSSPopViewAnimationAlphaType;
        _time = 0.3;
        [superView addSubview:self];
    }
    return self;
}

- (void)showPopView
{
    [self showPopViewWithShowTime:0 completion:nil];
}

- (void)showPopViewWithShowTime:(NSTimeInterval)showTime completion:(MSSBasePopViewCompletionBlock)completion
{
    if(_animation)
    {
        if(_animationType == MSSPopViewAnimationAlphaType)
        {
            self.alpha = 0;
            [UIView animateWithDuration:_time animations:^{
                self.alpha = 1;
            }completion:^(BOOL finished) {
                if(showTime > 0)
                {
                    [self performSelector:@selector(hidePopViewWithCompletion:) withObject:completion afterDelay:showTime];
                }
            }];
        }
        else if(_animationType == MSSPopViewAnimationTransformType)
        {
            self.transform = CGAffineTransformMakeScale(0.1, 0.1);
            [UIView animateWithDuration:_time animations:^{
                self.transform = CGAffineTransformMakeScale(1.0, 1.0);
            }completion:^(BOOL finished) {
                if(showTime > 0)
                {
                    [self performSelector:@selector(hidePopViewWithCompletion:) withObject:completion afterDelay:showTime];
                }
            }];
        }
    }
}

- (void)hidePopViewWithCompletion:(MSSBasePopViewCompletionBlock)completion
{
    if(_animation)
    {
        if(_animationType == MSSPopViewAnimationAlphaType)
        {
            self.alpha = 1;
            [UIView animateWithDuration:_time animations:^{
                self.alpha = 0;
            }completion:^(BOOL finished) {
                [self removeFromSuperview];
                if(completion)
                {
                    completion();
                }
            }];
        }
        else if(_animationType == MSSPopViewAnimationTransformType)
        {
            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
            [UIView animateWithDuration:_time animations:^{
                self.transform = CGAffineTransformMakeScale(0.1, 0.1);
            }completion:^(BOOL finished) {
                [self removeFromSuperview];
                if(completion)
                {
                    completion();
                }
            }];
        }
    }
    else
    {
        [self removeFromSuperview];
        if(completion)
        {
            completion();
        }
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if(!newSuperview)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    }
}

@end
