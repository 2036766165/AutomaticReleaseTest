//
//  NSString+Size.m
//  wdbo
//
//  Created by lin on 16/6/24.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import "NSString+Size.h"

@implementation NSString (Size)

- (CGSize)sizeOfStringWithFont:(UIFont *)font withMaxSize:(CGSize)size {
    
    return [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
}

@end
