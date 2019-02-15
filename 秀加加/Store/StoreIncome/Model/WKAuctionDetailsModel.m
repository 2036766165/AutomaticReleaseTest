//
//  AuctionDetailsModel.m
//  秀加加
//
//  Created by 吴文豪 on 2016/10/8.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKAuctionDetailsModel.h"

@implementation WKAuctionDetailsModel

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"Products":[ActionOrderProducts class]};
}

@end

@implementation ActionOrderProducts

@end
