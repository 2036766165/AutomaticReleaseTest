//
//  WKPayTool.m
//  秀加加
//
//  Created by sks on 2016/10/17.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKPayTool.h"
#import "WKShowInputView.h"
#import "WKStoreRechargeViewController.h"
#import "AppDelegate.h"
#import "NSObject+XWAdd.h"

@interface WKPayTool ()<NSMutableCopying,NSCopying>

@property (nonatomic,assign) WKPayFromeType fromType;

@end

@implementation WKPayTool

+ (id)allocWithZone:(struct _NSZone *)zone{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

+ (instancetype)shareInstance{
    return [[self alloc] init];
}


- (id)copyWithZone:(NSZone *)zone{
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone{
    return self;
}

- (void)payWith:(NSDictionary *)parameters type:(WKPayOfType)payType completionBlock:(completionBlock)block{

    self.block = block;
    
    [WKProgressHUD showLoadingGifText:@""];

    [WKHttpRequest normalPay:HttpRequestMethodPost url:WKPayUrl param:parameters success:^(WKBaseResponse *response) {
        
        [WKProgressHUD dismiss];
//        NSLog(@"response : %@",response);
        if (payType == WKPayOfTypeWeixi) {
            
            NSDictionary *dict = [self dictionaryWithJsonString:response.Data];

            PayReq *weixiPay = [[PayReq alloc] init];
            weixiPay.nonceStr = dict[@"noncestr"];
            weixiPay.package = dict[@"package"];
            weixiPay.sign = dict[@"sign"];
            weixiPay.prepayId = dict[@"prepayid"];
            weixiPay.partnerId = dict[@"partnerid"];
            weixiPay.timeStamp = [dict[@"timestamp"] intValue];
            
            [WXApi sendReq:weixiPay];
            
        }else if (payType == WKPayOfTypeAliPay){
            
//            NSDictionary *dict = [self dictionaryWithJsonString:response.Data];

            NSString *appScheme = @"wdboshow";
            
            [[AlipaySDK defaultService] payOrder:response.Data fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                NSLog(@"call back reslut = %@",resultDic);
                
                NSNumber *resultCode = resultDic[@"resultStatus"];
                
                WKPayResultType resultType;
                
                switch (resultCode.integerValue) {
                    case 9000:
                        resultType = WKPayResultTypeSuccess;
                        break;
                        
                    case 6001:{
                        resultType = WKPayResultTypeFail;
                        
                        [WKPromptView showPromptView:@"用户取消支付"];
                    }
                        break;
                        
                    default:{
                        resultType = WKPayResultTypeFail;
                        [WKPromptView showPromptView:resultDic[@"memo"]];
                    }
                        break;
                }
                
                WKPayResult *payResult = [[WKPayResult alloc] init];
                payResult.payType = WKPayOfTypeAliPay;
                payResult.resultType = resultType;
                payResult.resultMsg = resultDic[@"memo"];

                if (self.block) {
                    self.block(payResult);
                }
                
            }];
            
        }else{
            
            NSString *reminder = response.Data;
            
            __block WKPayResultType resultType = WKPayResultTypeFail;
            
            if ([response.Data isEqualToString:@"002"]) {
//                reminder = @"订单已支付";
            }else if ([response.Data isEqualToString:@"001"]){
//                reminder = @"账户余额不足";
                [self xw_postNotificationWithName:@"BALANCE" userInfo:nil];

                
                
            }else{
                resultType = WKPayResultTypeSuccess;
                
                WKPayResult *payResult = [[WKPayResult alloc] init];
                payResult.payType = WKPayOfTypeBalance;
                payResult.resultType = resultType;
                payResult.resultMsg = reminder;
                
                if (self.block) {
                    self.block(payResult);
                }

//                [WKPromptView showPromptView:reminder];

            }
            
            
            
        }
        
    } failure:^(WKBaseResponse *response) {
        [WKProgressHUD dismiss];
    }];
}

// 微信支付的回调
- (void)onResp:(BaseResp *)resp{
    if ([resp isKindOfClass:[PayResp class]]) {
        NSString *strMsg;
        WKPayResultType resultType;
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                resultType = WKPayResultTypeSuccess;
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
            case -2:{
                [WKPromptView showPromptView:@"用户取消支付"];
            }
                break;

            default:{
                
                resultType = WKPayResultTypeFail;
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                [WKPromptView showPromptView:resp.errStr];
            }
                break;
        }
        
        WKPayResult *payResult = [[WKPayResult alloc] init];
        payResult.payType = WKPayOfTypeWeixi;
        payResult.resultType = resultType;
        payResult.resultMsg = strMsg;
    
        if (self.block) {
            self.block(payResult);
        }
    }
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

- (void)dealloc{
    NSLog(@"------释放支付对象------");
}

@end

@implementation WKPayResult

@end
