//
//  NSJSONSerialization+LYJSON.h
//  LLHTTPClient
//
//  Created by LianLeven on 15/12/29.
//  Copyright © 2015年 LianLeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSJSONSerialization (LLJSON)
+ (nullable NSString *)stringWithJSONObject:(nonnull id)JSONObject;
+ (nullable id)objectWithJSONString:(nonnull NSString *)JSONString;
+ (nullable id)objectWithJSONData:(nonnull NSData *)JSONData;
@end
