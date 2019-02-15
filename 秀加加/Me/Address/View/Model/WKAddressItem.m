//
//  WKAddressItem.m
//  秀加加
//
//  Created by sks on 2016/9/22.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKAddressItem.h"

@implementation WKAddressItem


- (instancetype)init{
    if (self = [super init]) {
       
        self.isSelected = NO;
    }
    return self;
}


+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{
             @"sub":NSStringFromClass([WKAddressItem class])
             };
}

@end
