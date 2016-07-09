//
//  MSSRequestUploadHeadNetWork.m
//  MSSRequestManager
//
//  Created by 于威 on 16/7/10.
//  Copyright © 2016年 于威. All rights reserved.
//

#import "MSSRequestUploadHeadNetWork.h"

@implementation MSSRequestUploadHeadNetWork

- (void)setUpRequestItem
{
    self.requestItem.requestUrl = @"http://v2.toys178.com/Api/Public/Member/UpdateHead";
    self.requestItem.loadingType = MSSRequestProgressType;
    self.requestItem.failAlertText = @"上传头像失败";
    self.requestItem.isShowSussessAlertView = YES;
    self.requestItem.successAlertText = @"上传成功";
    [self.requestItem setAFMultipartFormDataBlock:^(id<AFMultipartFormData> formData) {
        NSString *path = [[NSBundle mainBundle]pathForResource:@"browse09" ofType:@"jpg"];
        NSData *data = [[NSData alloc]initWithContentsOfFile:path];
        [formData appendPartWithFileData:data name:@"head" fileName:@"1234567.jpg" mimeType:@"image/jpeg"];
    }];
}

//- (id)parseWithResponseObject:(id)responseObject
//{
//    // 此处可由子类解析，返回相应的Model
//    return model;
//}

@end
