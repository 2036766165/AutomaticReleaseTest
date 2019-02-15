//
//  WKLiveShopListModel.m
//  秀加加
//
//  Created by lin on 2016/10/12.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKLiveShopListModel.h"

@implementation WKLiveShopListModel

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"GoodsPicList":[WKLiveShopPicModelItem class],
             @"GoodsModelList":[WKLiveShopListModelItem class]};
}

@end


@implementation WKLiveShopPicModelItem

- (instancetype)init{
    if (self = [super init]) {
        self.imageView = [[UIImageView alloc] init];
    }
    return self;
}

@end

@implementation WKLiveShopListModelItem

@end
