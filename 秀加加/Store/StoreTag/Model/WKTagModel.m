//
//  WKTagModel.m
//  aa
//
//  Created by Chang_Mac on 16/9/21.
//  Copyright © 2016年 Chang_Mac. All rights reserved.
//

#import "WKTagModel.h"

@implementation WKTagModel

+(NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"TagList":NSStringFromClass([WkTagTitle class])};
    
}

@end


@implementation WkTagTitle

@end
