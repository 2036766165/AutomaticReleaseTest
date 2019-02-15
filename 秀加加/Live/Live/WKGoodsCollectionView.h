//
//  WKGoodsCollectionView.h
//  秀加加
//
//  Created by sks on 2016/10/13.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKGoodsHorCollectionViewCell.h"
#import "WKGoodsBottomView.h"

@class WKAuctionStatusModel;

//@protocol WKGoodsDelegate <NSObject>
//
//- (void)goodsOperate:(WKAuctionStatusModel *)md;
//
//@end

@interface WKGoodsCollectionView : UIView

+ (void)showGoodsListOn:(UIView *)view WithScreenType:(WKGoodsLayoutType)type goodsType:(WKGoodsType)goodsType requestParameters:(NSDictionary *)dict clientType:(WKClientType)clientType selectedBlock:(void(^)(id obj))block;

+ (void)dismiss;

@end
