//
//  WKOrderDetailModel.m
//  wdbo
//
//  Created by lin on 16/09/26
//  Copyright (c) Walkingtec. All rights reserved.
//

#import "WKOrderDetailModel.h"

@implementation WKOrderDetailModel

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"Products" : [WKOrderProducts class]};
}

@end

@implementation WKOrderProducts

@end
