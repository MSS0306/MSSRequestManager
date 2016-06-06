//
//  MSSProgressPopView.h
//  MSSRequestManager
//
//  Created by 于威 on 16/6/6.
//  Copyright © 2016年 于威. All rights reserved.
//

#import "MSSBasePopView.h"

@interface MSSProgressPopView : MSSBasePopView

@property (nonatomic,assign)CGFloat progress;
@property (nonatomic,copy)NSString *fileCountText;

- (instancetype)initWithSuperView:(UIView *)superView;

@end
