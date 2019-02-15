//
//  StartAuctionAnimation.h
//  Animation
//
//  Created by Chang_Mac on 17/2/21.
//  Copyright © 2017年 Chang_Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StartAuctionModel.h"

@interface StartAuctionAnimation : UIView

/**
 开始拍卖/筹卖动画

 @param saleType 动画类型
 @param auctionModel 商品模型
 */
+(void)startAcutionAnimation:(saleType)saleType andData:(StartAuctionModel *)auctionModel superView:(UIView *)superView;

@end
