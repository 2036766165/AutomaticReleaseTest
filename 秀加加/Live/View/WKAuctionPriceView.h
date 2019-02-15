//
//  WKAuctionPriceView.h
//  秀加加
//
//  Created by sks on 2016/10/21.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKGoodsHorCollectionViewCell.h"

@interface WKAuctionPriceView : UIView

@property (nonatomic,copy) NSString *price;

- (instancetype)initWithFrame:(CGRect)frame screenType:(WKGoodsLayoutType)layoutType;

@end
