//
//  WKGoodsModel.m
//  秀加加
//
//  Created by sks on 2016/9/18.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKGoodsModel.h"
#import "WKMarkModel.h"
#import "WKImageModel.h"

@implementation WKGoodsListModel

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{
             @"InnerList":NSStringFromClass([WKGoodsListItem class])
             };
}

@end

@implementation WKGoodsListItem

- (instancetype)init{
    if (self = [super init]) {
        self.isSelected = NO;
    }
    return self;
}

@end

@implementation WKGoodsModel

- (instancetype)init{
    if (self = [super init]) {
        self.GoodsModelList = @[];
        self.GoodsPicList = @[];
    }
    return self;
}

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{
             @"GoodsModelList":NSStringFromClass([WKMarkModel class]),
             @"GoodsVirtualInfoList":NSStringFromClass([WKImageModel class]),
             @"GoodsPicList":NSStringFromClass([WKImageModel class])
             };
}

@end
