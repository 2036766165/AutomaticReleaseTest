//
//  WKVirtualWorldModel.m
//  秀加加
//
//  Created by sks on 2017/2/15.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import "WKVirtualWorldModel.h"
#import "WKImageModel.h"

@implementation WKVirtualWorldModel

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{
             @"VirtualInfoList":NSStringFromClass([WKImageModel class])
             };
}

@end
