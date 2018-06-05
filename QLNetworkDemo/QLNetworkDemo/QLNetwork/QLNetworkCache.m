//
//  QLNetworkCache.m
//  QLNetworkDemo
//
//  Created by ql on 2018/6/5.
//  Copyright © 2018年 ql. All rights reserved.
//

#import "QLNetworkCache.h"
#import <YYCache/YYCache.h>

static NSString *const NetworkResponseCache = @"NetworkResponseCache";
static YYCache *_dataCache;

@implementation QLNetworkCache

+ (void)initialize
{
    _dataCache = [YYCache cacheWithName:NetworkResponseCache];
}

+ (BOOL)containCacheForURL:(NSString *)URL parameters:(NSDictionary *)parameters {
    
    NSString *cacheKey = [self cacheKeyWithURL:URL parameters:parameters];
    return [_dataCache containsObjectForKey:cacheKey];
}

+ (void)setHttpCache:(id)httpData URL:(NSString *)URL parameters:(NSDictionary *)parameters
{
    NSString *cacheKey = [self cacheKeyWithURL:URL parameters:parameters];
    //异步缓存,不会阻塞主线程
    [_dataCache setObject:httpData forKey:cacheKey withBlock:nil];
}

+ (id)httpCacheForURL:(NSString *)URL parameters:(NSDictionary *)parameters
{
    NSString *cacheKey = [self cacheKeyWithURL:URL parameters:parameters];
    return [_dataCache objectForKey:cacheKey];
}

+ (NSInteger)getAllHttpCacheSize
{
    return [_dataCache.diskCache totalCost];
}

+ (void)removeAllHttpCache
{
    [_dataCache.diskCache removeAllObjects];
}

+ (NSString *)cacheKeyWithURL:(NSString *)URL parameters:(NSDictionary *)parameters
{
    
    if(!parameters || [parameters isEqual: @""]) { return URL; }
    
    NSData *stringData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    NSString *paraString = [[NSString alloc] initWithData:stringData encoding:NSUTF8StringEncoding];
    
    NSString *cacheKey = [NSString stringWithFormat:@"%@%@",URL,paraString];
    
    return cacheKey;
}

@end
