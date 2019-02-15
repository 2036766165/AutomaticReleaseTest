//
//  WKMarkModel.m
//  wdbo
//
//  Created by sks on 16/6/22.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import "WKMarkModel.h"

@implementation WKMarkModel

- (instancetype)init{
    if (self = [super init]) {
//        self.priceTitle = @"价格";
//        self.stockTitle = @"库存";
//        self.modelTitle = @"信号";
        self.CreateTime = @"";
        self.Price = @"";
        self.ID = @"",
        self.ModelCode = @0;
        self.ModelName = nil;
        self.Stock = nil;
    }
    
    return self;
}
@end
