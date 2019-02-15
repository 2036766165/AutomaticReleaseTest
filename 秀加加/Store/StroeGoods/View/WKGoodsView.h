//
//  WKGoodsView.h
//  wdbo
//
//  Created by sks on 16/7/7.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WKGoodsListItem;

@interface WKGoodsView : UIView

- (void)showWith:(WKGoodsListItem *)goods;

@property (assign, nonatomic) NSInteger type;

@end
