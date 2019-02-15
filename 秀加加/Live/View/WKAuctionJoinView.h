//
//  WKAuctionJoinView.h
//  秀加加
//
//  Created by sks on 2016/10/17.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKGoodsHorCollectionViewCell.h"

// idx = -1  跳转到充值页
typedef void(^block)(NSInteger);

@interface WKAuctionJoinView : UIView

+ (void)auctionJoinWith:(id)md screenType:(WKGoodsLayoutType)screenType On:(UIView *)superView completionBlock:(block)block;

+ (void)dismissView;

@end
