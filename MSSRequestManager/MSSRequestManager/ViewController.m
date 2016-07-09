//
//  ViewController.m
//  MSSRequestManager
//
//  Created by 于威 on 16/5/7.
//  Copyright © 2016年 于威. All rights reserved.
//

#import "ViewController.h"
#import "MSSRequestManagerDefine.h"
#import "MSSAlertPopView.h"
#import "MSSRequestLoginNetWork.h"
#import "MSSRequestUploadHeadNetWork.h"
#import "MSSBatchRequest.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSArray *dataArray;
@property (nonatomic,copy)NSString *sid;
@property (nonatomic,strong)MSSBatchRequest *batchRequest;

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
    
    _batchRequest = [[MSSBatchRequest alloc]init];
    
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
        MSSRequestLoginNetWork *netWork = [[MSSRequestLoginNetWork alloc]init];
        [netWork startRequestWithParams:@{@"username":@"18617823173",@"password":@"111111"} loadingSuperView:self.view success:^(MSSResponseModel *responseItem, id resultComponents) {
            
            _sid = resultComponents[@"content"][@"sid"];
            
        } fail:^(MSSResponseModel *responseItem) {
            NSLog(@"error-->%@",responseItem.error);
        }];        
    }
    else if(indexPath.row == 1)
    {
        MSSRequestUploadHeadNetWork *netWork = [[MSSRequestUploadHeadNetWork alloc]init];
        [netWork startRequestWithParams:@{@"seller_id":@"49",@"user_id":@"1076",@"sid":[NSString stringWithFormat:@"%@",_sid]} loadingSuperView:self.view success:^(MSSResponseModel *responseItem, id resultComponents) {
            
        } fail:^(MSSResponseModel *responseItem) {
            
        }];
    }
    else if(indexPath.row == 2)
    {
        NSMutableArray *batchRequestArray = [[NSMutableArray alloc]init];
        int i = 0;
        for(i = 0;i < 5;i++)
        {
            MSSRequestModel *requestItem = [[MSSRequestModel alloc]init];
            requestItem.requestUrl = @"http://v2.toys178.com/Api/Public/Member/UpdateHead/Public/Member/UpdateHead";
            requestItem.params = @{@"seller_id":@"49",@"user_id":@"1076",@"sid":[NSString stringWithFormat:@"%@",_sid]};
            [requestItem setAFMultipartFormDataBlock:^(id<AFMultipartFormData> formData) {
                NSString *path = [[NSBundle mainBundle]pathForResource:@"browse09" ofType:@"jpg"];
                NSData *data = [[NSData alloc]initWithContentsOfFile:path];
                [formData appendPartWithFileData:data name:@"head" fileName:@"1234567.jpg" mimeType:@"image/jpeg"];
            }];
            [batchRequestArray addObject:requestItem];
        }
        
        [_batchRequest uploadBatchFileWithRequestItemArray:batchRequestArray success:^(id responseObject, NSInteger successCount) {
            NSLog(@"成功");
        } fail:^(NSError *error) {
            NSLog(@"失败");
        } finish:^(NSInteger failCount) {
            if(failCount == 0)
            {
                [MSSAlertPopView showSuccessAlertPopViewWithAlertText:@"全部图片已经上传成功，测试一下字数长的情况"];
            }
            else
            {
                MSSAlertPopView *alertView = [[MSSAlertPopView alloc]initWithAlertText:[NSString stringWithFormat:@"%ld个图片上传失败",failCount] superView:self.view];
                [alertView showPopViewWithShowTime:1.0 completion:nil];
            }
        } progress:^(CGFloat progress) {
            
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
