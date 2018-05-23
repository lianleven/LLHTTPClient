//
//  LYHTTPClient.h
//  LYHttpClient
//
//  Created by LianLeven on 15/12/28.
//  Copyright © 2015年 LianLeven. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
typedef NS_ENUM(NSUInteger, LYHTTPClientRequestCachePolicy){
    LYHTTPClientReturnCacheDataThenLoad = 0,///< 有缓存就先返回缓存，同步请求数据
    LYHTTPClientReloadIgnoringLocalCacheData, ///< 忽略缓存，重新请求
    LYHTTPClientReturnCacheDataElseLoad,///< 有缓存就用缓存，没有缓存就重新请求(用于数据不变时)
    LYHTTPClientReturnCacheDataDontLoad,///< 有缓存就用缓存，没有缓存就不发请求，当做请求出错处理（用于离线模式）
};

extern  NSString * const LYHTTPClientRequestCache;///< 缓存的name

@interface LLHTTPClient : AFHTTPSessionManager

/// 默认 LYHTTPClientReturnCacheDataThenLoad 的缓存方式 默认超时时间30s 可以设置。
+ (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
/// 可以自由设置超时时间，缓存方式。
+ (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
              timeoutInterval:(NSTimeInterval)timeoutInterval
                  cachePolicy:(LYHTTPClientRequestCachePolicy)cachePolicy
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

/// 默认 LYHTTPClientReturnCacheDataThenLoad 的缓存方式 默认超时时间30s 可以设置。
+ (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
/// 可以自由设置超时时间，缓存方式。
+ (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
               timeoutInterval:(NSTimeInterval)timeoutInterval
                   cachePolicy:(LYHTTPClientRequestCachePolicy)cachePolicy
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

@end
