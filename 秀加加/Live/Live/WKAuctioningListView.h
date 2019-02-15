//
//  WKAuctioningListView.h
//  秀加加
//
//  Created by sks on 2017/2/17.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKAuctionStatusModel.h"
typedef void(^touchIcon)(WKAuctionJoinModel *model);
@class WKAuctionJoinModel,WKAuctionStatusModel;

@interface WKAuctioningListView : UIView

//- (instancetype)initWithFrame:(CGRect)frame;

- (void)setAuctionerInfo:(WKAuctionStatusModel *)model;

- (void)participatePersons:(NSArray *)persons showAnimation:(BOOL)show;

- (void)delayTime:(NSInteger)delaySeconds;

- (void)crowdEedWith:(WKAuctionStatusModel *)md superView:(UIView *)superView;

- (void)bidWith:(WKAuctionStatusModel *)md;

@property (copy, nonatomic) touchIcon block;

@end
