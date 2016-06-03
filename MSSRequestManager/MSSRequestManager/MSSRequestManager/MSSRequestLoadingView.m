//
//  MSSRequestLoadingView.m
//  MSSRequestManager
//
//  Created by 于威 on 16/5/16.
//  Copyright © 2016年 于威. All rights reserved.
//

#import "MSSRequestLoadingView.h"

@interface MSSRequestLoadingView ()

@property (nonatomic,strong)UIImageView *requestLoadingImageView;
@property (nonatomic,strong)CABasicAnimation *rotationAnimation;

@end

@implementation MSSRequestLoadingView

+ (MSSRequestLoadingView *)showRequestLoadingViewWithSuperView:(UIView *)superView
{
    MSSRequestLoadingView *requestLoadingView = [[MSSRequestLoadingView alloc]initWithFrame:superView.bounds];
    requestLoadingView.backgroundColor = [UIColor clearColor];
    [superView addSubview:requestLoadingView];
    return requestLoadingView;
}

+ (void)hideRequestLoadingViewWithSuperView:(UIView *)superView
{
    for (UIView *subView in superView.subviews)
    {
        if([subView isKindOfClass:[MSSRequestLoadingView class]])
        {
            MSSRequestLoadingView *requestLoadingView = (MSSRequestLoadingView *)subView;
            [requestLoadingView hideRequestLoadingView];
            break;
        }
    }
}

- (void)hideRequestLoadingView
{
    [self stopAnimation];
    [self removeFromSuperview];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _requestLoadingImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        _requestLoadingImageView.image = [UIImage imageNamed:@"MSSRequestLoadingImageView"];
        _requestLoadingImageView.center = self.center;
        [self addSubview:_requestLoadingImageView];
        
        _rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        _rotationAnimation.toValue = [NSNumber numberWithFloat:(2 * M_PI)];
        _rotationAnimation.duration = 0.6f;
        _rotationAnimation.repeatCount = FLT_MAX;
        [self startAnimation];
    }
    return self;
}

- (void)startAnimation
{
    _requestLoadingImageView.hidden = NO;
    [_requestLoadingImageView.layer addAnimation:_rotationAnimation
                      forKey:@"rotateAnimation"];
}

- (void)stopAnimation
{
    _requestLoadingImageView.hidden = YES;
    [_requestLoadingImageView.layer removeAnimationForKey:@"rotateAnimation"];
}

@end
