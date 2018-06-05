//
//  QLAction.m
//  QLNetworkDemo
//
//  Created by ql on 2018/6/5.
//  Copyright © 2018年 ql. All rights reserved.
//

#import "QLAction.h"
#import <AFNetworking/AFNetworking.h>
#import "NSObject+QLRequest.h"
#import "QLNetworkCache.h"
#import "QLNetworkCache.h"

static NSString * const QLRequestUrlPath = @"QLRequestUrlPath";
static NSString * const QLRequestParameters = @"QLRequestParameters";

@interface QLAction()

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;

/**
 *  scheme
 */
@property (nonatomic, copy) NSString *scheme;

/**
 *  host
 */
@property (nonatomic, copy) NSString *host;

@end

@implementation QLAction

QLNetSingLetonM(QLAction)

- (void)setRequestHeardObject:(NSString *)object forKey:(NSString *)key {
    [self.sessionManager.requestSerializer setValue:object forHTTPHeaderField:key];
    
    QLog(@"%@", object);
}

//使用证书
//- (AFHTTPSessionManager *)sessionManager {
//    if (_sessionManager == nil) {
//        _sessionManager = [AFHTTPSessionManager manager];
//        _sessionManager.responseSerializer  = [AFJSONResponseSerializer serializer];
////        _sessionManager.responseSerializer  = [AFHTTPResponseSerializer serializer];
//
//        _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
//
//         [_sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//        _sessionManager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain",nil];
//        [_sessionManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
//        _sessionManager.requestSerializer.timeoutInterval = 20;
//        [_sessionManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
//
//        [_sessionManager setSecurityPolicy:[QLAction customSecurityPolicy]];
//
//    }
//    return _sessionManager;
//}

- (AFHTTPSessionManager *)sessionManager {
    if (_sessionManager == nil) {
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.responseSerializer  = [AFJSONResponseSerializer serializer];
        _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        [_sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        _sessionManager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain",nil];
        _sessionManager.requestSerializer.timeoutInterval = (!self.timeoutInterval ?: self.timeoutInterval);
    }
    return _sessionManager;
}

+ (AFSecurityPolicy *)customSecurityPolicy
{
    //先导入证书，找到证书的路径
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"chain" ofType:@"cer"];
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    //AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    //如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = NO;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    NSSet *set = [[NSSet alloc] initWithObjects:certData, nil];
    securityPolicy.pinnedCertificates = set;
    
    return securityPolicy;
}

- (NSURLSessionTask *)sendRequest:(id)request progress:(progressBlock)progress success:(successBlock)success failure:(failureBlock)failure {
    
    if ([request respondsToSelector:@selector(ql_requestConfigures)]) {
        [request ql_requestConfigures];
    }
    
    NSObject *requestObject = (NSObject *)request;
    NSURLSessionTask *sessionDataTask = nil;
    
    switch (requestObject.ql_method) {
            
        case QLRequestMethodGET:
            sessionDataTask = [self get:request progress:progress success:success failure:failure];
            break;
            
        case QLRequestMethodPOST:
            sessionDataTask = [self post:request progress:progress success:success failure:failure];
            break;
            
        case QLRequestMethodUPLOAD:
            sessionDataTask = [self upload:request progress:progress success:success failure:failure];
            break;
            
        case QLRequestMethodDOWNLOAD:
            sessionDataTask = [self download:request progress:progress success:success failure:failure];
            break;
            
        default:
            break;
    }
    return sessionDataTask;
}


- (NSURLSessionTask *)sendRequestBlock:(id (^)(NSObject *request))requestBlock progress:(progressBlock)progress success:(successBlock)success failure:(failureBlock)failure {
    
    if (requestBlock) {
        NSObject *requestObj = [[NSObject alloc]init];
        return [self sendRequest:requestBlock(requestObj) progress:progress success:success failure:failure];
    }else {
        return nil;
    }
}

- (NSURLSessionDataTask *)get:(id)request progress:(progressBlock)progress success:(successBlock)success failure:(failureBlock)failure {
    
    NSObject *requestObject = (NSObject *)request;
    NSDictionary *requestDictionary = [self requestObject:request];
    NSString *urlPath = requestDictionary[QLRequestUrlPath];
    NSDictionary *parameters = requestDictionary[QLRequestParameters];
    
    AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
    
    // 请求头中加一个时间戳
    [self.sessionManager.requestSerializer setValue:[NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]] forHTTPHeaderField:@"timestamp"];
    
    //    response.removesKeysWithNullValues = YES;
    self.sessionManager.responseSerializer = response;
    self.sessionManager.requestSerializer.timeoutInterval = 20.0f;
    
    return [self.sessionManager GET:urlPath parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            if (downloadProgress) progress(downloadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            if (responseObject) success(responseObject);
            
            if (requestObject.ql_autoCacheEnabled) { // set cache
                [QLNetworkCache setHttpCache:responseObject URL:urlPath parameters:parameters];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            if (error) {
                failure(error);
                
                if (requestObject.ql_autoCacheEnabled) { // get cache
                    id responseObject = [QLNetworkCache httpCacheForURL:urlPath parameters:parameters];
                    if (responseObject) success(responseObject);
                }
            }
        }
    }];
}

- (NSURLSessionDataTask *)post:(id)request progress:(progressBlock)progress success:(successBlock)success failure:(failureBlock)failure {
    
    NSObject *requestObject = (NSObject *)request;
    
    NSDictionary *requestDictionary = [self requestObject:request];
    
    NSString *urlPath = requestDictionary[QLRequestUrlPath];
    NSDictionary *parameters = requestDictionary[QLRequestParameters];
    AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
    self.sessionManager.requestSerializer.timeoutInterval = 20.0f;
    
    // 请求头中加一个时间戳
    [self.sessionManager.requestSerializer setValue:[NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]] forHTTPHeaderField:@"timestamp"];
    
    response.removesKeysWithNullValues = NO;
    self.sessionManager.responseSerializer = response;
    
    return [self.sessionManager POST:urlPath parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            if (uploadProgress) progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            if (responseObject) success(responseObject);
            
            if (requestObject.ql_autoCacheEnabled) { // set cache
                [QLNetworkCache setHttpCache:responseObject URL:urlPath parameters:parameters];
            }
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            if (error) failure(error);
            
            if (requestObject.ql_autoCacheEnabled) { // get cache
                id responseObject = [QLNetworkCache httpCacheForURL:urlPath parameters:parameters];
                if (responseObject) success(responseObject);
            }
        }
    }];
}


- (NSURLSessionDataTask *)upload:(id)request progress:(progressBlock)progress success:(successBlock)success failure:(failureBlock)failure {
    
    NSDictionary *requestDictionary = [self requestObject:request];
    NSString *urlPath = requestDictionary[QLRequestUrlPath];
    NSDictionary *parameters = requestDictionary[QLRequestParameters];
    
    NSObject *requestObject = (NSObject *)request;
    
    return [self.sessionManager POST:urlPath parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:requestObject.ql_fileConfig.fileData name:requestObject.ql_fileConfig.name fileName:requestObject.ql_fileConfig.fileName mimeType:requestObject.ql_fileConfig.mimeType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            if (uploadProgress) progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            if (responseObject) success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            if (error) failure(error);
        }
    }];
}

- (NSURLSessionDownloadTask *)download:(id)request progress:(progressBlock)progress success:(successBlock)success failure:(failureBlock)failure {
    
    NSDictionary *requestDictionary = [self requestObject:request];
    NSString *urlPath = requestDictionary[QLRequestUrlPath];
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:sessionConfiguration];
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:urlPath]];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:req progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            if (downloadProgress) progress(downloadProgress);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSURL *documentUrl = [[NSFileManager defaultManager] URLForDirectory :NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        
        return [documentUrl URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (failure) {
            if (error) failure(error);
        }
        if (success) {
            if (response) success(response);
        }
    }];
    
    [downloadTask resume];
    return downloadTask;
}


- (NSDictionary *)requestObject:(id)request {
    
    NSObject *requestObject = (NSObject *)request;
    
    // urlPath
    NSString *urlPath = nil;
    if (requestObject.ql_url.length) {
        urlPath = requestObject.ql_url;
    } else {
        NSString *scheme = nil;
        NSString *host = nil;
        scheme = (self.scheme.length > 0) ? self.scheme : requestObject.ql_scheme;
        host = (self.host.length > 0) ? self.host : requestObject.ql_host;
        urlPath = [NSString stringWithFormat:@"%@://%@%@",scheme, host, requestObject.ql_path];
    }
    
    // parameters
    id parameters = nil;
    if ([request respondsToSelector:@selector(ql_requestParameters)]) {
        parameters = [request ql_requestParameters];
    } else if ([request respondsToSelector:@selector(setQl_params:)]) {
        parameters = requestObject.ql_params;
    }
    
    return @{
             QLRequestUrlPath : urlPath,
             QLRequestParameters : parameters ? : @""
             };
}


@end

