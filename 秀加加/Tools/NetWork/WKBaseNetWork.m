//
//  WKBaseNetWork.m
//  秀加加
//
//  Created by lin on 16/8/30.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKBaseNetWork.h"

@implementation WKBaseNetWork

- (AFHTTPSessionManager *)httpSessionManager
{
    if (!_httpSessionManager) {
        _httpSessionManager = [AFHTTPSessionManager manager];
        _httpSessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
//
        _httpSessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        _httpSessionManager.requestSerializer.timeoutInterval = 30.0f;
        
//        [_httpSessionManager.requestSerializer setValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
//
//        _httpSessionManager.responseSerializer.acceptableContentTypes = [_httpSessionManager.responseSerializer.acceptableContentTypes setByAddingObjectsFromSet:[NSSet setWithObjects:@"application/json",@"text/plain", @"text/html",@"text/javascript",@"text/json", nil]];
        _httpSessionManager.securityPolicy = [AFSecurityPolicy defaultPolicy];
        _httpSessionManager.securityPolicy.allowInvalidCertificates = YES;
        
       
    }
    
    return _httpSessionManager;
}

- (void)addHeadFieldParamsDic:(NSDictionary *)headerFieldParamsDic
{
    if (headerFieldParamsDic) {
        
        [headerFieldParamsDic.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.httpSessionManager.requestSerializer setValue:headerFieldParamsDic[obj] forHTTPHeaderField:obj];
        }];
    }
}

- (void)requestWithMethod:(HttpRequestMethod)httpRequestMethod
               requestUrl:(NSString *)requestUrl
                    param:(NSDictionary *)param
                    model:(NSString *)model
                  success:(SuccessBlock)successBlock
                  failure:(FailureBlock)failureBlock
{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:TOKEN];
    
    if (token) {
        NSString *tokenValue = [NSString stringWithFormat:@"TokenID=%@;",token];
        [self.httpSessionManager.requestSerializer setValue:tokenValue forHTTPHeaderField:@"Cookie"];
    }
    
    [self baseRequestWithMethod:httpRequestMethod requestUrl:requestUrl param:param model:model success:successBlock failure:failureBlock];
}

- (void)requestWithMethod:(HttpRequestMethod)httpRequestMethod
               requestUrl:(NSString *)requestUrl
                    model:(NSString *)model
                  fileArr:(NSArray *)fileArr
                    param:(NSDictionary *)param
                  success:(SuccessBlock)successBlock
                  failure:(FailureBlock)failureBlock
{
    NSString *url = [WK_HostName stringByAppendingString:requestUrl];
    if (httpRequestMethod == HttpRequestMethodPost) {
        
        [self.httpSessionManager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            if ([fileArr[0] isKindOfClass:[UIImage class]]) {
                for (int i=0;i<fileArr.count;i++) {
                    
                    NSData *imageData = [self compressImage:fileArr[i] toSize:powf(1024, 2) * 2 accuracyOfLength:1024 * 40];
//                    NSData *imageData = UIImageJPEGRepresentation(fileArr[i], 0.2);
//                    NSLog(@"image Size : %ld kb",imageData.length/1024);
                    
                    [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"image%d",i] fileName:@"test.jpg" mimeType:@"image/jpg"];
                }
            }else{
                NSData *spxData = fileArr[0];
                [formData appendPartWithFileData:spxData name:@"" fileName:@"voice.spx" mimeType:@"spx"];
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            WKBaseResponse *response = [WKBaseResponse responseParse:responseObject modelClass:model];
            
            if (response.ResultCode == 0 && successBlock) {
                
                successBlock(response);
                
            }else if (response.ResultCode != 0 && failureBlock){
                
                failureBlock(response);
            }

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            WKBaseResponse *response = [WKBaseResponse new];
            response.ResultCode = error.code;
            response.ResultMessage = error.description;
            if (failureBlock) {
                failureBlock(response);
            }

        }];
    }
}

//- (NSData *)compressImage:(UIImage *)image{
//    
//}

/*
 * 返回图片压缩后的数据流
 * sourceImage: 要处理的图片
 * targetSize : 目标尺寸
 * accuracyLength: 压缩精度
 */
-(NSData *)compressImage:(UIImage *)sourceImage toSize:(NSInteger)targetSize accuracyOfLength:(NSInteger)accuracyLength
{
    NSData *imageData = UIImagePNGRepresentation(sourceImage);
    if (imageData.length < powf(1024, 2) * 2 + accuracyLength) {
        return imageData;
    }else{
        CGFloat maxQuality = 1.0;
        CGFloat minQuality = 0.0;
        int flag = 0;
        
        while (1) {
            
            CGFloat midQuality = (maxQuality + minQuality)/2;
            
            NSData *data = UIImageJPEGRepresentation(sourceImage,midQuality);
            
            if (flag == 6) {
                NSData *data = UIImageJPEGRepresentation(sourceImage,minQuality);
                return data;
            }
            
            flag++;
            
            if (data.length > powf(1024, 2) * 2 + accuracyLength) {
                NSLog(@"-----%d------%f------%ld-----",flag,midQuality,accuracyLength);

                minQuality = midQuality;
                continue;
            }else if (data.length < powf(1024, 2) - accuracyLength){
                maxQuality = midQuality;
                NSLog(@"-----%d------%f------%ld-----",flag,midQuality,accuracyLength);

                continue;
            }else{
                return data;
                break;
            }
        }
        
    }
    
    return imageData;
    
}

- (void)baseRequestWithMethod:(HttpRequestMethod)httpRequestMethod
               requestUrl:(NSString *)requestUrl
                    param:(NSDictionary *)param
                        model:(NSString *)model
                  success:(SuccessBlock)successBlock
                  failure:(FailureBlock)failureBlock
{
    NSString *url = [WK_HostName stringByAppendingString:requestUrl];
    
//    if (User.netStatus) {
//        
//        [WKProgressHUD dismiss];
//        WKPromptView *promptView = [[WKPromptView alloc]initWithFrame:CGRectMake(0, 0, WKScreenW, 50)];
//
//        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
//        [keyWindow addSubview:promptView];
//        
//        [promptView promptViewShow:@"连接失败,请检查网络!" completionBlock:^{
//            [promptView removeFromSuperview];
//        }];
//        
//        return;
//    }
    
    NSLog(@"请求的接口地址：%@,参数信息：%@",url,param);
    
    if (httpRequestMethod == HttpRequestMethodPost) {
        [self.httpSessionManager POST:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {

            WKBaseResponse *response = [WKBaseResponse responseParse:responseObject modelClass:model];
            
            [WKProgressHUD dismiss];

            if (response.ResultCode == 0 && successBlock) {
                successBlock(response);

            }else if (response.ResultCode != 0 && failureBlock){
                
                failureBlock(response);
                [WKPromptView showPromptView:response.ResultMessage];

            }

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [WKProgressHUD dismiss];

            WKBaseResponse *response = [WKBaseResponse new];
            response.ResultCode = error.code;
            response.ResultMessage = error.description;
            if (failureBlock) {
                failureBlock(response);
            }
            
            [WKPromptView showPromptView:@"网络错误，请稍等或检查网络配置"];
            //[WKProgressHUD showTopMessage:response.ResultMessage];
        }];
        
    }else if (httpRequestMethod == HttpRequestMethodGet){

        [self.httpSessionManager GET:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            [WKProgressHUD dismiss];
            NSLog(@"============%@",responseObject);
            WKBaseResponse *response = [WKBaseResponse responseParse:responseObject modelClass:model];

            if (response.ResultCode == 0 && successBlock) {

                successBlock(response);

            }else if (response.ResultCode != 0 && failureBlock){
                
                failureBlock(response);
                [WKPromptView showPromptView:response.ResultMessage];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [WKProgressHUD dismiss];

            WKBaseResponse *response = [WKBaseResponse new];
            response.ResultMessage = error.description;
            if (failureBlock) {
                failureBlock(response);
            }
            
            [WKPromptView showPromptView:@"网络错误，请稍等或检查网络配置"];

        }];
    }
}


@end
