//
//  QLRequestProtocol.h
//  QLNetworkDemo
//
//  Created by ql on 2018/6/5.
//  Copyright © 2018年 ql. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol QLRequestProtocol <NSObject>

@optional

/**
 *  配置request请求参数
 *
 *  @return NSDictionary 或者 自定义参数模型
 */
- (id)ql_requestParameters;


/**
 *  配置request的路径、请求参数等
 */
- (void)ql_requestConfigures;

@end
