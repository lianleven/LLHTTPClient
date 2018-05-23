//
//  LLHTTPClient.m
//  LLHTTPClient
//
//  Created by LianLeven on 15/12/28.
//  Copyright © 2015年 LianLeven. All rights reserved.
//

#import "LLHTTPClient.h"
#import <YYCache/YYCache.h>
#import "NSJSONSerialization+LLJSON.h"
static NSString * const LLHTTPClientURLString = @"https://api.app.net/";
NSString * const LLHTTPClientRequestCache = @"LLHTTPClientRequestCache";
static NSTimeInterval const LLHTTPClientTimeoutInterval = 30;
typedef NS_ENUM(NSUInteger, LLHTTPClientRequestType) {
    LLHTTPClientRequestTypeGET = 0,
    LLHTTPClientRequestTypePOST,
};
@implementation LLHTTPClient

#pragma mark - public
//优先使用缓存
+ (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
    return [self requestMethod:LLHTTPClientRequestTypeGET urlString:URLString parameters:parameters timeoutInterval:LLHTTPClientTimeoutInterval cachePolicy:LLHTTPClientReturnCacheDataThenLoad success:success failure:failure];
}
+ (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
              timeoutInterval:(NSTimeInterval)timeoutInterval
                  cachePolicy:(LLHTTPClientRequestCachePolicy)cachePolicy
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
    return [self requestMethod:LLHTTPClientRequestTypeGET urlString:URLString parameters:parameters timeoutInterval:timeoutInterval cachePolicy:cachePolicy success:success failure:failure];
}
//优先使用缓存
+ (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
    return [self requestMethod:LLHTTPClientRequestTypePOST urlString:URLString parameters:parameters timeoutInterval:LLHTTPClientTimeoutInterval cachePolicy:LLHTTPClientReturnCacheDataThenLoad success:success failure:failure];
}
+ (NSURLSessionDataTask *)POST:(NSString *)URLString
                   parameters:(id)parameters
              timeoutInterval:(NSTimeInterval)timeoutInterval
                  cachePolicy:(LLHTTPClientRequestCachePolicy)cachePolicy
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
    return [self requestMethod:LLHTTPClientRequestTypePOST urlString:URLString parameters:parameters timeoutInterval:timeoutInterval cachePolicy:cachePolicy success:success failure:failure];
}

#pragma mark - private
+ (NSURLSessionDataTask *)requestMethod:(LLHTTPClientRequestType)type
                              urlString:(NSString *)URLString
                             parameters:(id)parameters
                        timeoutInterval:(NSTimeInterval)timeoutInterval
                            cachePolicy:(LLHTTPClientRequestCachePolicy)cachePolicy
                                success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
    URLString = URLString.length?URLString:@"";
    NSString *cacheKey = URLString;
    if (parameters) {
        if (![NSJSONSerialization isValidJSONObject:parameters]) return nil;//参数不是json类型
        NSData *data = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
        NSString *paramStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        cacheKey = [cacheKey stringByAppendingString:paramStr];
    }
    
    YYCache *cache = [[YYCache alloc] initWithName:LLHTTPClientRequestCache];
    cache.memoryCache.shouldRemoveAllObjectsOnMemoryWarning = YES;
    cache.memoryCache.shouldRemoveAllObjectsWhenEnteringBackground = YES;
    
   
    
    id object = [cache objectForKey:cacheKey];
    
    
    switch (cachePolicy) {
        case LLHTTPClientReturnCacheDataThenLoad: {//先返回缓存，同时请求
            if (object) {
                success(nil,object);
            }
            break;
        }
        case LLHTTPClientReloadIgnoringLocalCacheData: {//忽略本地缓存直接请求
            //不做处理，直接请求
            break;
        }
        case LLHTTPClientReturnCacheDataElseLoad: {//有缓存就返回缓存，没有就请求
            if (object) {//有缓存
                success(nil,object);
                return nil;
            }
            break;
        }
        case LLHTTPClientReturnCacheDataDontLoad: {//有缓存就返回缓存,从不请求（用于没有网络）
            if (object) {//有缓存
                success(nil,object);
                
            }
            return nil;//退出从不请求
        }
        default: {
            break;
        }
    }
    return [self requestMethod:type urlString:URLString parameters:parameters timeoutInterval:timeoutInterval cache:cache cacheKey:cacheKey success:success failure:failure];
    
}
+ (NSURLSessionDataTask *)requestMethod:(LLHTTPClientRequestType)type
                              urlString:(NSString *)URLString
                             parameters:(id)parameters
                        timeoutInterval:(NSTimeInterval)timeoutInterval
                                  cache:(YYCache *)cache
                               cacheKey:(NSString *)cacheKey
                                success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
     LLHTTPClient *manager = [LLHTTPClient sharedClient];
     [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
     manager.requestSerializer.timeoutInterval = timeoutInterval;
     [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    switch (type) {
        case LLHTTPClientRequestTypeGET:{
            return [manager GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if ([responseObject isKindOfClass:[NSData class]]) {
                    responseObject = [NSJSONSerialization objectWithJSONData:responseObject];
                }
                [cache setObject:responseObject forKey:cacheKey];//YYCache 已经做了responseObject为空处理
                !success?:success(task,responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                !failure?:failure(task, error);
            }];
            break;
        }
        case LLHTTPClientRequestTypePOST:{
            return [manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if ([responseObject isKindOfClass:[NSData class]]) {
                    responseObject = [NSJSONSerialization objectWithJSONData:responseObject];
                }
                [cache setObject:responseObject forKey:cacheKey];//YYCache 已经做了responseObject为空处理
                !success?:success(task,responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                !failure?:failure(task, error);
            }];
            break;
        }
        default:
            break;
    }
    
}
/// URLString 应该是全url 上传单个文件
+ (NSURLSessionUploadTask *)upload:(NSString *)URLString filePath:(NSString *)filePath parameters:(id)parameters{
    NSURL *URL = [NSURL URLWithString:URLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
    NSURLSessionUploadTask *uploadTask = [[LLHTTPClient client] uploadTaskWithRequest:request fromFile:fileUrl progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"Success: %@ %@", response, responseObject);
        }
    }];
    [uploadTask resume];
    return uploadTask;
}
+ (instancetype)sharedClient{
    static LLHTTPClient *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [LLHTTPClient client];
        
    });
    return sharedClient;
}
+ (instancetype)client{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
   return [[LLHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:LLHTTPClientURLString] sessionConfiguration:configuration];
    
}
@end
