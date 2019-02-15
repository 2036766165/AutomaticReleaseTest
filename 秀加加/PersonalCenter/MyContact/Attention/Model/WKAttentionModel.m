//
//  WKAttentionModel.m
//  秀加加
//
//  Created by lin on 2016/9/20.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKAttentionModel.h"

@implementation WKAttentionModel

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"InnerList":[WKAttentionItemModel class]};
}

@end


@implementation WKAttentionItemModel

@end
