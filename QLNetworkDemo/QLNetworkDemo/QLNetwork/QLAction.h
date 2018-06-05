//
//  QLAction.h
//  QLNetworkDemo
//
//  Created by ql on 2018/6/5.
//  Copyright © 2018年 ql. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QLNetSingLeton.h"
#import "QLRequestProtocol.h"

/**
 *  请求成功block
 */
typedef void (^successBlock)(id responseObject);

/**
 *  请求失败block
 */
typedef void (^failureBlock) (NSError *error);

/**
 *  请求响应block
 */
typedef void (^responseBlock)(id dataObj, NSError *error);

/**
 *  监听进度响应block
 */
typedef void (^progressBlock)(NSProgress * progress);

@interface QLAction : NSObject

QLNetSingLetonH(QLAction)

/**
 *  请求超时时间
 */
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

/**
*  发送请求Block(在block内部配置request)
*/
- (NSURLSessionTask *)sendRequestBlock:(id (^)(NSObject *request))requestBlock progress:(progressBlock)progress success:(successBlock)success failure:(failureBlock)failure;

/**
 *  发送请求(在外部配置request)
 */
- (NSURLSessionTask *)sendRequest:(id)request progress:(progressBlock)progress success:(successBlock)success failure:(failureBlock)failure;


/**
 * 设置请求头
 */
- (void)setRequestHeardObject:(NSString *)object forKey:(NSString *)key;

@end


/**
 *  用来封装上文件数据的模型类
 */
@interface QLRequestFileConfig : NSObject

/**
 *  文件数据
 */
@property (nonatomic, strong) NSData *fileData;

/**
 *  服务器接收参数名
 */
@property (nonatomic, copy) NSString *name;

/**
 *  文件名
 */
@property (nonatomic, copy) NSString *fileName;

/**
 *  文件类型
 */
@property (nonatomic, copy) NSString *mimeType;



+ (instancetype)fileConfigWithfileData:(NSData *)fileData name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType;


- (instancetype)initWithfileData:(NSData *)fileData name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType;


@end
