//
//  WKGoodsHorCollectionViewCell.h
//  秀加加
//
//  Created by sks on 2016/10/11.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKLiveRecordingView.h"
@class WKGoodsListItem;

typedef enum : NSUInteger {
    WKGoodsLayoutTypeHoriztal,  //横屏
    WKGoodsLayoutTypeVertical   //竖屏
} WKGoodsLayoutType;

typedef enum : NSUInteger {
    WKClientTypePushFlow,
    WKClientTypePlay
} WKClientType;

@interface WKGoodsHorCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *recommand;       // 推荐标识
@property (strong, nonatomic) WKLiveRecordingView * recordView;//录音

- (void)setModel:(id)model type:(WKGoodsLayoutType)type clientType:(WKClientType)clientType;

@end
