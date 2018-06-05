//
//  QLViewModelProtocol.h
//  QLNetworkDemo
//
//  Created by ql on 2018/6/5.
//  Copyright © 2018年 ql. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  请求成功block
 */
typedef void (^successBlock)(id responseObject);

/**
 *  请求失败block
 */
typedef void (^failureBlock) (NSError *error);

/**
 *  监听进度响应block
 */
typedef void (^progressBlock)(NSProgress * progress);

@protocol QLViewModelProtocol <NSObject>

@optional

/**
 *  加载数据
 */
- (NSURLSessionTask *)ql_viewModelWithProgress:(progressBlock)progress success:(successBlock)success failure:(failureBlock)failure;

@end
