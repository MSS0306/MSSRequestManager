//
//  MSSAlertPopView.m
//  MSSRequestManager
//
//  Created by 于威 on 16/6/6.
//  Copyright © 2016年 于威. All rights reserved.
//

#import "MSSAlertPopView.h"

static const float alertDefaultTime = 1.0f;

@interface MSSAlertPopView ()

@property (nonatomic,copy)NSString *alertText;
@property (nonatomic,assign)MSSAlertPopViewType type;

@end

@implementation MSSAlertPopView

+ (void)showAlertPopViewWithAlertText:(NSString *)alertText
{
    MSSAlertPopView *alertPopView = [[MSSAlertPopView alloc]initWithAlertText:alertText superView:[UIApplication sharedApplication].keyWindow];
    [alertPopView showPopViewWithShowTime:alertDefaultTime completion:nil];
}

+ (void)showSuccessAlertPopViewWithAlertText:(NSString *)alertText
{
    MSSAlertPopView *alertPopView = [[MSSAlertPopView alloc]initWithAlertText:alertText type:MSSAlertPopViewSuccessType superView:[UIApplication sharedApplication].keyWindow];
    [alertPopView showPopViewWithShowTime:alertDefaultTime completion:nil];
}

+ (void)showFailAlertPopViewWithAlertText:(NSString *)alertText
{
    MSSAlertPopView *alertPopView = [[MSSAlertPopView alloc]initWithAlertText:alertText type:MSSAlertPopViewFailType superView:[UIApplication sharedApplication].keyWindow];
    [alertPopView showPopViewWithShowTime:alertDefaultTime completion:nil];
}

- (instancetype)initWithAlertText:(NSString *)alertText superView:(UIView *)superView
{
    return  [self initWithAlertText:alertText type:MSSAlertPopViewDefaultType superView:superView];
}

- (instancetype)initWithAlertText:(NSString *)alertText type:(MSSAlertPopViewType)type superView:(UIView *)superView
{
    self = [super initWithSuperView:superView];
    {
        _alertText = alertText;
        _type = type;
        self.animation = YES;
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    UIView *maskView = [[UIView alloc]init];
    maskView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    maskView.layer.cornerRadius = 5.0f;
    maskView.layer.masksToBounds = YES;
    [self addSubview:maskView];
    
    UILabel *alertLabel = [[UILabel alloc]init];
    alertLabel.textAlignment = NSTextAlignmentCenter;
    alertLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    alertLabel.textColor = [UIColor whiteColor];
    [maskView addSubview:alertLabel];
    
    CGRect textRect = [_alertText boundingRectWithSize:CGSizeMake(MAXFLOAT,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:alertLabel.font} context:nil];
    CGSize size = textRect.size;
    CGFloat width = size.width + 40;
    CGFloat height = size.height + 30;
    alertLabel.text = _alertText;

    if(_type == MSSAlertPopViewDefaultType)
    {
        maskView.frame = CGRectMake((self.frame.size.width - width) / 2, (self.frame.size.height - height) / 2, width, height);
        alertLabel.frame = maskView.bounds;
    }
    else
    {
        UIImageView *alertImageView = [[UIImageView alloc]init];
        alertImageView.frame = CGRectMake((width - 42) / 2, 10, 42, 42);
        if(_type == MSSAlertPopViewSuccessType)
        {
            alertImageView.image = [UIImage imageNamed:@"requestManagerSuccess"];
        }
        else if(_type == MSSAlertPopViewFailType)
        {
            alertImageView.image = [UIImage imageNamed:@"requestManagerFail"];
        }
        [maskView addSubview:alertImageView];
        
        maskView.frame = CGRectMake((self.frame.size.width - width) / 2, (self.frame.size.height - height) / 2, width, height + 42);
        alertLabel.frame = CGRectMake(0, maskView.frame.size.height - height, maskView.frame.size.width, height);
    }
}


@end
