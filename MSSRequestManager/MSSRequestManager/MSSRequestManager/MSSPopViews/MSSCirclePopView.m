//
//  MSSCirclePopView.m
//  MSSRequestManager
//
//  Created by 于威 on 16/6/6.
//  Copyright © 2016年 于威. All rights reserved.
//

#import "MSSCirclePopView.h"

@interface MSSCirclePopView ()

@property (nonatomic,strong)UIImageView *loadingImageView;
@property (nonatomic,strong)CABasicAnimation *rotationAnimation;

@end

@implementation MSSCirclePopView

- (instancetype)initWithSuperView:(UIView *)superView
{
    self = [super initWithSuperView:superView];
    if(self)
    {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    _loadingImageView = [[UIImageView alloc]init];
    _loadingImageView.image = [UIImage imageNamed:@"requestManagerCircleImageView"];
    _loadingImageView.frame = CGRectMake((self.frame.size.width - 50) / 2, (self.frame.size.height - 50) / 2, 50, 50);
    [self addSubview:_loadingImageView];
    
    _rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    _rotationAnimation.toValue = [NSNumber numberWithFloat:(2 * M_PI)];
    _rotationAnimation.duration = 0.6f;
    _rotationAnimation.repeatCount = FLT_MAX;
    [self startAnimation];
}

- (void)startAnimation
{
    _loadingImageView.hidden = NO;
    [_loadingImageView.layer addAnimation:_rotationAnimation
                                   forKey:@"rotateAnimation"];
}

- (void)stopAnimation
{
    _loadingImageView.hidden = YES;
    [_loadingImageView.layer removeAnimationForKey:@"rotateAnimation"];
}


@end
