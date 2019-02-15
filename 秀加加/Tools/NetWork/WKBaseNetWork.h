//
//  WKBaseNetWork.h
//  秀加加
//
//  Created by lin on 16/8/30.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKBaseResponse.h"
#import <AFNetworking/AFNetworking.h>

typedef NS_ENUM(NSUInteger,HttpRequestMethod) {
    HttpRequestMethodGet = 0,
    HttpRequestMethodPost =1
};

typedef void(^SuccessBlock)(WKBaseResponse *response);
typedef void(^FailureBlock)(WKBaseResponse *response);

@interface WKBaseNetWork : NSObject

@property (nonatomic,strong) AFHTTPSessionManager *httpSessionManager;

- (void)requestWithMethod:(HttpRequestMethod)httpRequestMethod
                       requestUrl:(NSString *)requestUrl
                            param:(NSDictionary *)param
                            model:(NSString *)model
                          success:(SuccessBlock)successBlock
                          failure:(FailureBlock)failureBlock;

- (void)requestWithMethod:(HttpRequestMethod)httpRequestMethod
               requestUrl:(NSString *)requestUrl
                    model:(NSString *)model
                  fileArr:(NSArray *)fileArr
                    param:(NSDictionary *)param
                  success:(SuccessBlock)successBlock
                  failure:(FailureBlock)failureBlock;
@end
