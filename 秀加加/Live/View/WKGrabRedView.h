//
//  WKGrabRedView.h
//  秀加加
//
//  Created by sks on 2017/3/16.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WKMessage;

typedef enum : NSUInteger {
    WKRedEvenlopeTypeUser,
    WKRedEvenlopeTypeSystem
} WKRedEvenlopeType;

@interface WKGrabRedView : NSObject

+ (void)grabRedEnvelopeOn:(UIView *)superView message:(WKMessage *)message callBack:(void(^)())callBack;

@end
