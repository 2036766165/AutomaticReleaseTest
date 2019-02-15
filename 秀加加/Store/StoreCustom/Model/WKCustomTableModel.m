//
//  WKCustomTableModel.m
//  秀加加
//
//  Created by Chang_Mac on 16/10/10.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKCustomTableModel.h"

@implementation WKCustomTableModel

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"InnerList":[CustomInnerList class]};
}

@end

@implementation CustomInnerList

@end
