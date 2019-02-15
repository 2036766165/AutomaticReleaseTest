//
//  WKGoodsDetailViewController.h
//  秀加加
//
//  Created by sks on 2016/10/13.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "ViewController.h"
#import "WKGoodsHorCollectionViewCell.h"
#import "WKLiveViewController.h"

@class WKAuctionStatusModel,WKHomePlayModel;

typedef enum : NSUInteger {
    WKBackShowTypePay,
    WKBackShowTypeNormal,
    WKBackShowTypeDismiss,
    WKBackShowTypeHotGoods
} WKBackShowType;

@protocol WKGoodsDetailDelegate <NSObject>
- (void)backToShowWith:(WKBackShowType)backType orderInfo:(id)orderInfo;
@end

@interface WKGoodsDetailViewController : ViewController

@property (nonatomic,weak) id<WKGoodsDetailDelegate> delegate;

//@property (nonatomic,strong) WKAuctionStatusModel *auctionStatusModel;

//- (instancetype)initWithGoodsItem:(WKGoodsListItem *)goodsItem playModel:(WKHomePlayModel *)homeModel auctionInfo:(WKAuctionStatusModel *)auctionInfo from:(WKLiveFrom)from;
- (instancetype)initWithGoodsItem:(WKGoodsListItem *)goodsItem playModel:(WKHomePlayModel *)homeModel from:(WKLiveFrom)from showGoods:(BOOL)showGoods;


//- (void)setLiveView:(UIView *)liveView;

@end
