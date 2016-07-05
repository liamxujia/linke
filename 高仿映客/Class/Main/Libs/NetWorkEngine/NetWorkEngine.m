
//  Created byon 15/7/15.
//  Copyright (c) 2015年 All rights reserved.
//

#import "NetWorkEngine.h"
#import "AFNetworking.h"

@interface NetWorkEngine()
@property (nonatomic, strong)AFHTTPRequestOperationManager * manager;

@end
@implementation NetWorkEngine
+ (NetWorkEngine *)shareNetWorkEngine
{
    static NetWorkEngine * data = nil;
    static dispatch_once_t onceToKen;
    dispatch_once(&onceToKen, ^{
        data = [[NetWorkEngine alloc] init];
    });
    return data;
}
// 取消请求数据的方法
- (void)cancelDataRequest
{
    [self.manager.operationQueue cancelAllOperations];
}
// 回调成功失败的方法

// 异步Post数据请求
- (void)AFJSONPostRequest:(NSString *)urlString
{
    NSString * str = [[NSString stringWithFormat:@"%@",urlString]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",str);
    // 格式
    NSDictionary *dic = @{@"format":@"json"};
    NSLog(@"%@",dic);
    self.manager = [[AFHTTPRequestOperationManager alloc] init];
    // 取消请求数据
    [self cancelDataRequest];
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    //成功方法
    [_manager POST:str parameters:dic success:^(AFHTTPRequestOperation * operation, id responseObject) {
        NSLog(@"%@",responseObject);
        self.successfulBlock(responseObject);
        
        //失败方法
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        NSLog(@"%@",error);
        //         self.failBlock(error);
    }];
}

// 同步Get数据请求
- (void)AfJSONGetRequest:(NSString *)urlString
{
    NSString * str = [[NSString stringWithFormat:@"%@",urlString]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * dic = @{@"format":@"json"};
    self.manager = [[AFHTTPRequestOperationManager alloc] init];
    //
    [_manager GET:str parameters:dic success:^(AFHTTPRequestOperation * operation, id responseObject) {
        self.successfulBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        self.failBlock(error);
        
    }];
}






@end