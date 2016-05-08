//
//  ViewController.m
//  MSSRequestManager
//
//  Created by 于威 on 16/5/7.
//  Copyright © 2016年 于威. All rights reserved.
//

#import "ViewController.h"
#import "MSSRequestManagerDefine.h"

@interface ViewController ()

@property (nonatomic,copy)NSString *sid;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    MSSRequestModel *requestItem = [[MSSRequestModel alloc]init];
//    requestItem.requestUrl = @"http://test.beta.toys178.com/Api/Assistant/Login/index";
    requestItem.requestUrl = @"http://v2.toys178.com/Api/Assistant/Login/index";
    requestItem.params = @{@"username":@"18581855415",@"password":@"111111"};
    [[MSSRequestManager sharedInstance]startWithRequestItem:requestItem success:^(NSURLSessionDataTask *task, id responseObject) {
        _sid = responseObject[@"content"][@"sid"];
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(10, 100, 100, 100);
    btn1.backgroundColor = [UIColor yellowColor];
    [btn1 addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(110, 100, 100, 100);
    btn2.backgroundColor = [UIColor blueColor];
    [btn2 addTarget:self action:@selector(batchTest) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
}

- (void)btnClick
{
    // 上传头像测试
    MSSRequestModel *requestItem = [[MSSRequestModel alloc]init];
    requestItem.requestUrl = @"http://v2.toys178.com/Api/Public/Member/UpdateHead";
    requestItem.params = @{@"seller_id":@"49",@"user_id":@"700",@"sid":[NSString stringWithFormat:@"%@",_sid]};
    NSString *path = [[NSBundle mainBundle]pathForResource:@"testtest" ofType:@"jpg"];
    NSData *data = [[NSData alloc]initWithContentsOfFile:path];
    requestItem.uploadName = @"head";
    requestItem.uploadFileName = @"1234567.jpg";
    requestItem.uploadData = data;
    [[MSSRequestManager sharedInstance]uploadFileWithRequestItem:requestItem success:^(NSURLSessionDataTask *task, id responseObject) {

    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)batchTest
{
    NSMutableArray *batchRequestArray = [[NSMutableArray alloc]init];
    int i = 0;
    for(i = 0;i < 10;i++)
    {
        MSSRequestModel *requestItem = [[MSSRequestModel alloc]init];
        requestItem.requestUrl = @"http://v2.toys178.com/Api/Public/Member/UpdateHead";
        requestItem.params = @{@"seller_id":@"49",@"user_id":@"700",@"sid":[NSString stringWithFormat:@"%@",_sid]};
        NSString *path = [[NSBundle mainBundle]pathForResource:@"testtest" ofType:@"jpg"];
        NSData *data = [[NSData alloc]initWithContentsOfFile:path];
        requestItem.uploadName = @"head";
        requestItem.uploadFileName = @"1234567.jpg";
        requestItem.uploadData = data;
        [batchRequestArray addObject:requestItem];
    }
    
    [[MSSRequestManager sharedInstance]uploadBatchFileWithRequestItemArray:batchRequestArray success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"成功");
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"失败");
    } finish:^{
        NSLog(@"完成");
    }];
    
    [self performSelector:@selector(cancel) withObject:nil afterDelay:0.3];
}

- (void)cancel
{
//    [[MSSRequestManager sharedInstance]cancelBatchRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
