//
//  WKOrderStatusModel.m
//  wdbo
//
//  Created by lin on 16/6/29.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import "WKOrderStatusModel.h"

@implementation WKOrderStatusModel

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"InnerList":[WKOrderStatusItemModel class]};
}

@end

@implementation WKOrderStatusItemModel

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"Products":[WKOrderProduct class]};
}

@end

@implementation WKOrderProduct

@end
