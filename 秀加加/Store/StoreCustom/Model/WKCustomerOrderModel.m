//
//  WKCustomerOrderModel.m
//  秀加加
//  客户的所有订单数据，客户详情页面使用
//  Created by ZHAOHL on 2016/10/13.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKCustomerOrderModel.h"

@implementation WKCustomerOrderModel

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"InnerList":[WKCustomerListOrder class]};
}

@end

@implementation WKCustomerListOrder

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"Products":[WKCustomerListProduct class]};
}

@end


@implementation WKCustomerListProduct

@end
