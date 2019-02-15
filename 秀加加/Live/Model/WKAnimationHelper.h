//
//  WKAnimationHelper.h
//  秀加加
//
//  Created by sks on 2017/2/8.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    WKAimationBid,         // 出价
    WKAimationAuction
} WKAimation;

@interface WKAnimationHelper : NSObject

+ (void)showAnimation:(WKAimation)animation OnView:(UIView *)view withInfo:(id)info callback:(void(^)(WKAimation,NSInteger))callback;


@end
