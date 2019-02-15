//
//  WKPayTool.h
//  秀加加
//
//  Created by sks on 2016/10/17.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"

typedef void(^completionBlock)(id obj);

typedef enum : NSUInteger {
    WKOrderTypeGoods = 1,
    WKOrderTypeAuction,   
    WKOrderTypeReward,    // reward
    WKOrderTypeCash,      // cash
    WKOrderTypeCrowd = 6      // crowd
} WKOrderType;

typedef enum : NSUInteger {
    WKPayOfTypeWeixi = 2,
    WKPayOfTypeAliPay = 4,
    WKPayOfTypeBalance = 6
} WKPayOfType;

typedef enum : NSUInteger {
    WKPayFromeTypeOrder,
    WKPayFromeTypeReward,
    WKPayFromeTypeAuction
} WKPayFromeType;

typedef enum : NSUInteger {
    WKPayResultTypeSuccess,
    WKPayResultTypeFail,
    WKPayResultBalance
} WKPayResultType;

@interface WKPayResult : NSObject

@property (nonatomic,assign) WKPayResultType resultType;

@property (nonatomic,copy) NSString *resultMsg;

@property (nonatomic,assign) WKPayOfType payType;

@property (nonatomic,copy) NSString *orderCode;
@property (nonatomic,copy) NSString *price;
@property (nonatomic,copy) NSString *createTime;

@end

@interface WKPayTool : NSObject <WXApiDelegate>

@property (nonatomic,copy) CompletionBlock block;

+ (instancetype)shareInstance;

- (void)payWith:(NSDictionary *)parameters type:(WKPayOfType)payType completionBlock:(completionBlock)block;

//+ (void)payWith:(NSDictionary *)parameters type:(WKPayOfType)payType fromType:(WKPayFromeType)fromType completionBlock:(completionBlock)block;

@end
