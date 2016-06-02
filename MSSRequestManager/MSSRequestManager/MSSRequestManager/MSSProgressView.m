//
//  MSSProgressView.m
//  MSSRequestManager
//
//  Created by 于威 on 16/6/1.
//  Copyright © 2016年 于威. All rights reserved.
//


#import "MSSProgressView.h"

static const CGFloat drawLineWith = 5.0f;

@interface MSSProgressView ()

@property (nonatomic,strong)CAShapeLayer *progressLayer;
@property (nonatomic,strong)UILabel *progressLabel;

@end

@implementation MSSProgressView

+ (MSSProgressView *)showProgressViewWithSuperView:(UIView *)superView
{
    MSSProgressView *progressView = [[MSSProgressView alloc]initWithFrame:superView.bounds];
    progressView.backgroundColor = [UIColor clearColor];
    [superView addSubview:progressView];
    return progressView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createProgressView];
    }
    return self;
}

- (void)createProgressView
{
    // 进度条
    UIView *progressView = [[UIView alloc]initWithFrame:CGRectMake((self.frame.size.width - 80) / 2, (self.frame.size.height - 80) / 2, 80, 80)];
    [self addSubview:progressView];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(progressView.frame.size.width / 2, progressView.frame.size.height / 2)
                    radius:(progressView.frame.size.width - drawLineWith) / 2
                startAngle:0
                  endAngle:M_PI * 2
                 clockwise:YES];
    
    CAShapeLayer *trackLayer = [CAShapeLayer layer];
    trackLayer.frame = progressView.bounds;
    trackLayer.path = path.CGPath;
    trackLayer.lineWidth = drawLineWith;
    trackLayer.strokeColor = [[UIColor lightGrayColor]CGColor];
    trackLayer.fillColor = [[UIColor clearColor]CGColor];
    [progressView.layer addSublayer:trackLayer];
    
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.frame = progressView.bounds;
    _progressLayer.path = path.CGPath;
    _progressLayer.lineWidth = drawLineWith;
    _progressLayer.strokeEnd = 0.0;
    _progressLayer.strokeColor = [[UIColor orangeColor]CGColor];
    _progressLayer.fillColor = [[UIColor clearColor]CGColor];
    [progressView.layer addSublayer:_progressLayer];
    
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    if(_progress <= 1.0)
    {
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.2f];
        [_progressLayer setStrokeEnd:_progress];
        [CATransaction commit];
    }
}

- (void)hideProgressView
{
    [self removeFromSuperview];
}

@end


