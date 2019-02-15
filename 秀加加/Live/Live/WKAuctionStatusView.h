//
//  WKAuctionStatusView.h
//  秀加加
//
//  Created by sks on 2016/10/11.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKGoodsHorCollectionViewCell.h"


typedef enum : NSUInteger {
    WKAuctionTypePushFlow,
    WKAuctionTypeLive
} WKAuctionType;

typedef enum : NSUInteger {
    WKCallBackTypeNormal,     // normal callback
    WKCallBackTypeAuction,    // auction
    WKCallBackTypeToRecharge, // recharge
    WKCallBackTypeConfirmAddress // confirm address
} WKCallBackType;

typedef void(^ClickBlock)(WKCallBackType type);


@interface WKAuctionStatusView : UIView

+ (void)showWithModel:(id)model screenOrientation:(WKGoodsLayoutType)screenType clientType:(WKAuctionType)clientType completionBlock:(ClickBlock)block;

+ (void)dismissView;

@end
