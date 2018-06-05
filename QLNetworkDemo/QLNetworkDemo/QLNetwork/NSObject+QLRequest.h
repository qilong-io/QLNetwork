//
//  NSObject+QLRequest.h
//  QLNetworkDemo
//
//  Created by ql on 2018/6/5.
//  Copyright © 2018年 ql. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QLRequestProtocol.h"
#import "QLAction.h"

typedef enum : NSUInteger {
    /** GET */
    QLRequestMethodGET,
    /** POST */
    QLRequestMethodPOST,
    /** UPLOAD */
    QLRequestMethodUPLOAD,
    /** DOWNLOAD */
    QLRequestMethodDOWNLOAD
    
} QLRequestMethod;

@interface NSObject (QLRequest)


@property (nonatomic, copy, nonnull) NSString *ql_url;

/**
 *  method
 */
@property (nonatomic, assign) QLRequestMethod ql_method;

/**
 *  scheme (eg: http, https, ftp)
 */
@property (nonatomic, copy, nonnull) NSString *ql_scheme;

/**
 *  host
 */
@property (nonatomic, copy, nonnull) NSString *ql_host;

/**
 *  path
 */
@property (nonatomic, copy, nonnull) NSString *ql_path;

/**
 *  parameters
 */
@property (nonatomic, retain, nonnull) id ql_params;

/**
 *  fileConfig
 */
@property (nonatomic, retain, nonnull) QLRequestFileConfig *ql_fileConfig;

/**
 是否开启缓存
 */
@property (nonatomic, assign) BOOL ql_autoCacheEnabled;

@end
