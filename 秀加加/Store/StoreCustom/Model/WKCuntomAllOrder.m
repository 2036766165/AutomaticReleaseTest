
//
//  WKCuntomAllOrder.m
//  wdbo
//
//  Created by Chang_Mac on 16/7/3.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import "WKCuntomAllOrder.h"

@implementation WKCuntomAllOrder

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"Products":[WKProducts class]};
}

@end

@implementation WKProducts

@end