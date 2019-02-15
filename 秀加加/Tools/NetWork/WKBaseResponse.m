//
//  WKBaseResponse.m
//  秀加加
//
//  Created by lin on 16/8/30.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKBaseResponse.h"

@implementation WKBaseResponse

+ (instancetype)responseParse:(id)json modelClass:(NSString *)modelClass
{
    if (json != nil) {
        
        WKBaseResponse *response = [[self class] yy_modelWithDictionary:json];

        if (response.ResultCode == 0) {
#warning 为了调试查看json,上线时去掉
            response.json = json;
            if (modelClass != nil || modelClass.length != 0) {
//                _LOGD(@"modelClass %@ response : %@",modelClass,json);
                
                response.Data = [NSClassFromString(modelClass) yy_modelWithDictionary:response.Data];
            }
            
        }else{
            if (response.ResultCode == kErrUnauthorized) {
                // 发出一个通知,踢出用户
                if (User.loginStatus == YES) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:Unauthorized object:nil];
                }
            }
//            else{
//                // 弹出提示框,显示message
//                [WKProgressHUD showText:response.ResultMessage];
//            }
        }
        
        return response;
    }
    
    return nil;
}


- (NSString *) description{
    
    NSString *result = @"";
    result = [result stringByAppendingFormat:@"responseMsg : %@\n",self.ResultMessage];
    result = [result stringByAppendingFormat:@"responseCode : %@\n",@(self.ResultCode)];
    result = [result stringByAppendingFormat:@"dataDic : %@\n",self.Data];
    
    return result;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
