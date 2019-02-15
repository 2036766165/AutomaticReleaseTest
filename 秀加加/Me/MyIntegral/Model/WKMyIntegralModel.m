//
//  WKMyIntegralModel.m
//  秀加加
//
//  Created by lin on 2016/9/20.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKMyIntegralModel.h"

@implementation WKMyIntegralModel

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"InnerList":[WKMyIntegralItemModel class]};
}

@end

@implementation WKMyIntegralItemModel

@end
