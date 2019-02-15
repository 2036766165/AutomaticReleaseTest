//
//  WKAddressModel.m
//  秀加加
//
//  Created by sks on 2016/9/22.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKAddressModel.h"

@implementation WKAddressModel

@end

@implementation WKAddressListModel

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{
             @"InnerList":NSStringFromClass([WKAddressListItem class])
             };
}

@end

@implementation WKAddressListItem



@end

