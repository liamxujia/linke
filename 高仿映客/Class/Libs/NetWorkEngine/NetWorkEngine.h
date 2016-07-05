//
//  NetWorkEngine.h
//
//
//  Created by sun on 15/7/15.
//  Copyright (c) 2015年  All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^SuccessfulBlock)(id object);
typedef void (^FailBlock)(NSError *error);
@interface NetWorkEngine : NSObject
@property (nonatomic, copy)SuccessfulBlock successfulBlock;// 成功回调属性
@property (nonatomic, copy)FailBlock failBlock;// 失败回调属性
// 成功失败回调方法
//- (id)initWithSuccessfulBlock:(SuccessfulBlock)successfulBlock
//failBlock:(FailBlock)failBlock;
+ (NetWorkEngine *)shareNetWorkEngine;
- (void)AFJSONPostRequest:(NSString *)urlString;
- (void)AfJSONGetRequest:(NSString *)urlString;

// 请求队列
@property (nonatomic, strong)NSOperationQueue * operationQueue;
// 取消请求数据
- (void)cancelDataRequest;
@end