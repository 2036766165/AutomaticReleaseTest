//
//  WKOrderFixExpressModel.m
//  秀加加
//
//  Created by lin on 2016/9/27.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKOrderFixExpressModel.h"

@implementation WKOrderFixExpressModel

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"Data":[WKOrderFixExpressItemModel class]};
}

@end

@implementation WKOrderFixExpressItemModel

@end