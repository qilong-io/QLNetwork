//
//  NSObject+QLRequest.m
//  QLNetworkDemo
//
//  Created by ql on 2018/6/5.
//  Copyright © 2018年 ql. All rights reserved.
//

#import "NSObject+QLRequest.h"
#import <objc/runtime.h>

@implementation NSObject (QLRequest)

- (BOOL)ql_autoCacheEnabled {
    return [objc_getAssociatedObject(self, @selector(ql_autoCacheEnabled)) integerValue];
}

- (void)setQl_autoCacheEnabled:(BOOL)ql_autoCacheEnabled {
    objc_setAssociatedObject(self, @selector(ql_autoCacheEnabled), [NSNumber numberWithBool:ql_autoCacheEnabled], OBJC_ASSOCIATION_ASSIGN);
}

/**
 *  url
 */
- (NSString *)ql_url {
    return objc_getAssociatedObject(self, @selector(ql_url));
}

- (void)setQl_url:(NSString *)ql_url {
    objc_setAssociatedObject(self, @selector(ql_url), ql_url, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

/**
 *  method
 */
- (QLRequestMethod)ql_method {
    return [objc_getAssociatedObject(self, @selector(ql_method)) integerValue];
}
- (void)setQl_method:(QLRequestMethod)ql_method {
    objc_setAssociatedObject(self, @selector(ql_method), @(ql_method), OBJC_ASSOCIATION_ASSIGN);
}


- (NSString *)ql_scheme {
    return objc_getAssociatedObject(self, @selector(ql_scheme));
}
- (void)setQl_scheme:(NSString *)ql_scheme {
    objc_setAssociatedObject(self, @selector(ql_scheme), ql_scheme, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

/**
 *  host
 */
- (NSString *)ql_host {
    return objc_getAssociatedObject(self, @selector(ql_host));
}
- (void)setQl_host:(NSString *)ql_host {
    objc_setAssociatedObject(self, @selector(ql_host), ql_host, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

/**
 *  path
 */
- (NSString *)ql_path {
    return objc_getAssociatedObject(self, @selector(ql_path));
}
- (void)setQl_path:(NSString *)ql_path{
    objc_setAssociatedObject(self, @selector(ql_path), ql_path, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

/**
 *  parameters
 */
- (id)ql_params {
    return objc_getAssociatedObject(self, @selector(ql_params));
}

- (void)setQl_params:(id)ql_params {
    objc_setAssociatedObject(self, @selector(ql_params), ql_params, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


/**
 *  fileConfig
 */
- (QLRequestFileConfig *)ql_fileConfig {
    return objc_getAssociatedObject(self, @selector(ql_fileConfig));
}

- (void)setQl_fileConfig:(QLRequestFileConfig *)ql_fileConfig {
    objc_setAssociatedObject(self, @selector(ql_fileConfig), ql_fileConfig, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
