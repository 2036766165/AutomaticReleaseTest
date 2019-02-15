//
//  WKOrderNoticeModel.m
//  wdbo
//
//  Created by lin on 16/6/27.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import "WKOrderNoticeModel.h"

@implementation WKOrderNoticeModel

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"ListNoticeInfo":[WKListNoticeInfo class],
             @"ListMemberNoticeInfo":[WKListNoticeInfo class]};
}

@end

@implementation WKListNoticeInfo

@end