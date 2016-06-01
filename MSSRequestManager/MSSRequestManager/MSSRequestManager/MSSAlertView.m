//
//  MSSAlertView.m
//  MSSRequestManager
//
//  Created by 于威 on 16/6/1.
//  Copyright © 2016年 于威. All rights reserved.
//

#import "MSSAlertView.h"

@interface MSSAlertView ()

@property (nonatomic,strong)UILabel *alertLabel;
@property (nonatomic,strong)UIView *maskView;

@end

@implementation MSSAlertView

+ (void)showAlertViewWithText:(NSString *)text delay:(NSTimeInterval)time
{
    UIView *superView = [UIApplication sharedApplication].keyWindow;
    MSSAlertView *alertView = [[MSSAlertView alloc]initWithAlertText:text frame:superView.bounds];
    alertView.backgroundColor = [UIColor clearColor];
    [superView addSubview:alertView];
    
    [alertView hideAlertViewWithDelayTime:time];
}

- (instancetype)initWithAlertText:(NSString *)text frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.alpha = 0;
        _maskView = [[UIView alloc]init];
        _maskView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
        _maskView.layer.cornerRadius = 5.0f;
        _maskView.layer.masksToBounds = YES;
        [self addSubview:_maskView];
        
        _alertLabel = [[UILabel alloc]init];
        _alertLabel.textAlignment = NSTextAlignmentCenter;
        _alertLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        _alertLabel.textColor = [UIColor whiteColor];
        [_maskView addSubview:_alertLabel];

        [self showAlertViewWithText:text];
    }
    return self;
}

- (void)showAlertViewWithText:(NSString *)text
{
    CGRect textRect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_alertLabel.font} context:nil];
    CGSize size = textRect.size;
    CGRect rect = _maskView.frame;
    rect.size.width = size.width + 20;
    rect.size.height = size.height + 30;
    _maskView.frame = rect;
    _maskView.center = self.center;
    _alertLabel.text = text;
    _alertLabel.frame = _maskView.bounds;
    self.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    }];
}

- (void)hideAlertViewWithDelayTime:(NSTimeInterval)time
{
    [self performSelector:@selector(hideAlertView) withObject:nil afterDelay:time];
}

- (void)hideAlertView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
