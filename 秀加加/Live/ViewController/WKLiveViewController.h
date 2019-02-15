//
//  WKLiveViewController.h
//  wdbo
//
//  Created by lin on 16/6/20.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import "ViewController.h"
#import <libksygpulive/libksygpulive.h>
#import "WKHomePlayModel.h"

typedef enum : NSUInteger {
    WKLiveFromHotSaler,      // 热门
    WKLiveFromHotGoods       // 热卖
} WKLiveFrom;

typedef enum{
    WKLiveWatch,  //观众
    WKLiveHost    //主播
} WKUserType;

@interface WKLiveViewController : ViewController

- (instancetype)initWithHomeList:(id)homeList from:(WKLiveFrom)from;

@property (copy, nonatomic) void (^playStop)() ;//结束播放回调

@end
