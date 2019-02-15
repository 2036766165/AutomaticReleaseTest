//
//  WKVideoPauseView.h
//  秀加加
//
//  Created by sks on 2016/10/28.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKGoodsHorCollectionViewCell.h"

@class WKHomePlayModel;

// 直播暂停
@interface WKVideoPauseView : UIView

typedef enum{
    StartShow = 1, //开始直播
    LeavingOnGoods = 2, //直播离开
    LeavingOnLive = 3
    
}ShowTypeEnum;

- (instancetype)initWithFrame:(CGRect)frame PlayModel:(WKHomePlayModel *)model;

- (void)setLiveType:(ShowTypeEnum)type rect:(CGRect)rect;

@end
