//
//  WKLiveShopModel.m
//  秀加加
//
//  Created by lin on 2016/10/8.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKLiveShopModel.h"

@implementation WKLiveShopModel

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"InnerList":[WKLiveShopItemModel class]};
}

@end

@implementation WKLiveShopItemModel

@end
