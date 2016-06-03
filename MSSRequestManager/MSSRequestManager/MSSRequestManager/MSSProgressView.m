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

@property (nonatomic,strong)UIView *progressView;
@property (nonatomic,strong)CAShapeLayer *progressLayer;
@property (nonatomic,strong)UILabel *progressLabel;
@property (nonatomic,strong)UILabel *fileCountLabel;// 文件上传成功个数

@end

@implementation MSSProgressView

+ (MSSProgressView *)showProgressViewWithSuperView:(UIView *)superView
{
    MSSProgressView *progressView = [[MSSProgressView alloc]initWithFrame:superView.bounds];
    progressView.backgroundColor = [UIColor clearColor];
    [superView addSubview:progressView];
    return progressView;
}

+ (void)hideProgressViewWithSuperView:(UIView *)superView
{
    for (UIView *subView in superView.subviews)
    {
        if([subView isKindOfClass:[MSSProgressView class]])
        {
            MSSProgressView *progressView = (MSSProgressView *)subView;
            [progressView hideProgressView];
            break;
        }
    }
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
    _progressView = [[UIView alloc]initWithFrame:CGRectMake((self.frame.size.width - 80) / 2, (self.frame.size.height - 80) / 2, 80, 80)];
    [self addSubview:_progressView];
    
    _progressLabel = [[UILabel alloc]initWithFrame:_progressView.bounds];
    _progressLabel.font = [UIFont systemFontOfSize:10.0f];
    _progressLabel.textAlignment = NSTextAlignmentCenter;
    _progressLabel.textColor = [UIColor purpleColor];
    [_progressView addSubview:_progressLabel];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(_progressView.frame.size.width / 2, _progressView.frame.size.height / 2)
                    radius:(_progressView.frame.size.width - drawLineWith) / 2
                startAngle:0
                  endAngle:M_PI * 2
                 clockwise:YES];
    
    CAShapeLayer *trackLayer = [CAShapeLayer layer];
    trackLayer.frame = _progressView.bounds;
    trackLayer.path = path.CGPath;
    trackLayer.lineWidth = drawLineWith;
    trackLayer.strokeColor = [[UIColor lightGrayColor]CGColor];
    trackLayer.fillColor = [[UIColor clearColor]CGColor];
    [_progressView.layer addSublayer:trackLayer];
    
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.frame = _progressView.bounds;
    _progressLayer.path = path.CGPath;
    _progressLayer.lineWidth = drawLineWith;
    _progressLayer.strokeEnd = 0.0;
    _progressLayer.strokeColor = [[UIColor orangeColor]CGColor];
    _progressLayer.fillColor = [[UIColor clearColor]CGColor];
    [_progressView.layer addSublayer:_progressLayer];
    
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
        NSNumber *number = [NSNumber numberWithFloat:progress];
        NSString *percent = [NSNumberFormatter localizedStringFromNumber:number numberStyle:NSNumberFormatterPercentStyle];
        _progressLabel.text = percent;
    }
}

- (void)hideProgressView
{
    [self removeFromSuperview];
}

- (void)setFileCountText:(NSString *)fileCountText
{
    _fileCountText = fileCountText;
    if(!_fileCountLabel)
    {
        _fileCountLabel = [[UILabel alloc]init];
        _fileCountLabel.textAlignment = NSTextAlignmentCenter;
        _fileCountLabel.textColor = [UIColor magentaColor];
        _fileCountLabel.frame = CGRectMake(CGRectGetMinX(_progressView.frame), CGRectGetMaxY(_progressView.frame), _progressView.frame.size.width, 50);
        _fileCountLabel.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:_fileCountLabel];
    }
    _fileCountLabel.text = [NSString stringWithFormat:@"已上传%@张",_fileCountText];
}

@end


