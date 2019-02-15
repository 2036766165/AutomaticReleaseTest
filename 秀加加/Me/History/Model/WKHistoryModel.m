//
//  WKHistoryModel.m
//  秀加加
//
//  Created by lin on 2016/9/19.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKHistoryModel.h"

@implementation WKHistoryModel

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"InnerList":[WKHistoryItemModel class]};
}

@end

@implementation WKHistoryItemModel

@end
