//
//  NSString+Size.h
//  wdbo
//
//  Created by lin on 16/6/24.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Size)

- (CGSize)sizeOfStringWithFont:(UIFont *)font withMaxSize:(CGSize)size;

@end
