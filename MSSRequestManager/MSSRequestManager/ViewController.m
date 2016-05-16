//
//  ViewController.m
//  MSSRequestManager
//
//  Created by 于威 on 16/5/7.
//  Copyright © 2016年 于威. All rights reserved.
//

#import "ViewController.h"
#import "MSSRequestManagerDefine.h"
#import "AFURLSessionManager.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSArray *dataArray;
@property (nonatomic,copy)NSString *sid;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    tableView.tableFooterView = [[UIView alloc]init];
    
    _dataArray = @[@"post请求",@"上传一个文件",@"批量上传文件多个请求"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    cell.textLabel.text = _dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        MSSRequestModel *requestItem = [[MSSRequestModel alloc]init];
        requestItem.params = @{@"username":@"18617823173",@"password":@"111111"};
        requestItem.requestPath = @"Assistant/Login/index";
        requestItem.cachePolicy = MSSRequestAlwaysReplaceLocalCachePolicy;
        requestItem.cacheSecond = 30.0f;
        requestItem.cacheFolderName = @"Login";
        requestItem.requestLoadingSuperView = self.view;
        [[MSSRequestManager sharedInstance]startWithRequestItem:requestItem success:^(id responseObject) {
            _sid = responseObject[@"content"][@"sid"];
        } fail:^(NSError *error) {
            
        }];
    }
    else if(indexPath.row == 1)
    {
        MSSRequestModel *requestItem = [[MSSRequestModel alloc]init];
        requestItem.requestPath = @"Public/Member/UpdateHead";
        requestItem.params = @{@"seller_id":@"49",@"user_id":@"1076",@"sid":[NSString stringWithFormat:@"%@",_sid]};
        requestItem.requestLoadingSuperView = self.view;
        
        //    requestItem.uploadName = @"head";
        //    requestItem.uploadFileName = @"1234567.jpg";
        //    requestItem.uploadData = data;
        
        [requestItem setAFMultipartFormDataBlock:^(id<AFMultipartFormData> formData) {
            NSString *path = [[NSBundle mainBundle]pathForResource:@"testtest" ofType:@"jpg"];
            NSData *data = [[NSData alloc]initWithContentsOfFile:path];
            [formData appendPartWithFileData:data name:@"head" fileName:@"1234567.jpg" mimeType:@"image/jpeg"];
        }];
        
        [[MSSRequestManager sharedInstance]uploadFileWithRequestItem:requestItem success:^(id responseObject) {
            
        } fail:^(NSError *error) {
            
        }];
    }
    else if(indexPath.row == 2)
    {
        NSMutableArray *batchRequestArray = [[NSMutableArray alloc]init];
        int i = 0;
        for(i = 0;i < 10;i++)
        {
            MSSRequestModel *requestItem = [[MSSRequestModel alloc]init];
            requestItem.requestPath = @"Public/Member/UpdateHead";
            requestItem.params = @{@"seller_id":@"49",@"user_id":@"1076",@"sid":[NSString stringWithFormat:@"%@",_sid]};
            NSString *path = [[NSBundle mainBundle]pathForResource:@"testtest" ofType:@"jpg"];
            NSData *data = [[NSData alloc]initWithContentsOfFile:path];
            requestItem.uploadName = @"head";
            requestItem.uploadFileName = @"1234567.jpg";
            requestItem.uploadData = data;
            [batchRequestArray addObject:requestItem];
        }
        
        [[MSSRequestManager sharedInstance]uploadBatchFileWithRequestItemArray:batchRequestArray success:^(id responseObject) {
            NSLog(@"成功");
        } fail:^(NSError *error) {
            NSLog(@"失败");
        } finish:^(NSInteger failCount) {
            NSLog(@"failCount->%ld",failCount);
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
