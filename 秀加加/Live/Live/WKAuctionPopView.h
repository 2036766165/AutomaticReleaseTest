//
//  WKAuctionPopView.h
//  秀加加
//
//  Created by sks on 2016/10/11.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "WKGoodsCollectionView.h"
#import "WKGoodsBottomView.h"

@interface WKAuctionPopView : UIView

+ (void)showAuctionViewWithPrice:(NSNumber *)price goodsType:(WKGoodsType)type Completion:(void (^)(NSString *, NSString *))block;

@end
