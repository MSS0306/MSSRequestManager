//
//  MSSEdgeInsetsLabel.m
//  MSSRequestManager
//
//  Created by 于威 on 16/6/9.
//  Copyright © 2016年 于威. All rights reserved.
//

#import "MSSEdgeInsetsLabel.h"

@implementation MSSEdgeInsetsLabel

- (void)setEdgeInsets:(UIEdgeInsets)edgeInsets
{
    _edgeInsets = edgeInsets;
    [self setNeedsDisplay];
}

- (void)drawTextInRect:(CGRect)rect
{
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, _edgeInsets)];
}

@end
