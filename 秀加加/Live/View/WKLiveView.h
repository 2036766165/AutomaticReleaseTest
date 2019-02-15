//
//  WKLiveView.h
//  秀加加
//
//  Created by lin on 2016/10/8.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKHomePlayModel.h"
#import "WKAuctionShopModel.h"
#import "WKGoodsHorCollectionViewCell.h"
#import "WKInputView.h"

@class WKOnLineMd,WKAuctionStatusModel,WKPayView;

typedef enum{
    ClickChatType = 1001,
    ClickShopType,
    ClickVirType,
    ClickCashType,
    ClickShareType,
    ClickExitType,
    ClickIconType,
    ClickAuctionType,
    ClickChatListType,
    ClickBalanceType,
    ClickLiveTypeRedBag,
    ClickLiveTypeToRecharge,
    ClickLiveTypeVirtual,
    ClickLiveTypeRank,
    ClickLiveTypeToOnlineList,   // to online list vc
    ClickLiveTypeRedPacketDetail,
    ClickLiveTypeFoolishActivity
}ClickLiveType;

typedef enum : NSUInteger {
    WKVideoStatusPause,
    WKVideoStatusPlay,
    WKVideoStatusStop
} WKVideoStatus;

@protocol WKWatchShowDelegate <NSObject>

@optional
- (void)operateWith:(ClickLiveType)type;
- (void)operateWith:(ClickLiveType)type md:(id)md;

- (void)selectAddress:(WKPayView *)auctionModel;

- (void)videoStatus:(WKVideoStatus)status;

@end


@interface WKLiveView : UIView

@property (nonatomic,weak) id <WKWatchShowDelegate> delegate;
@property (nonatomic,assign) WKInputType inputType;   // 文本,gif,弹幕
@property (copy, nonatomic)void(^liveCallBack)(NSInteger type);//1.私信 2.充值 3.红包
//- (instancetype)initWithFrame:(CGRect)frame model:(WKHomePlayModel*)model auctionModel:(WKAuctionShopModel*)auctionModel;
- (instancetype)initWithFrame:(CGRect)frame model:(WKHomePlayModel *)model;
@property (assign, nonatomic) NSInteger onLineCount;

@end
