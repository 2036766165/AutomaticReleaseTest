//
//  WKLiveTableViewCell.h
//  wdbo
//
//  Created by lin on 16/6/30.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WKGoodsListItem;

@protocol WKRecomandDelegate <NSObject>
//1.推荐  2.拍卖
- (void)recomendWith:(WKGoodsListItem *)md cell:(id)obj;

@end


@interface WKLiveTableViewCell : UITableViewCell

@property (nonatomic,weak) id <WKRecomandDelegate> delegate;

//第一种情况
@property (nonatomic,strong) UIImageView *recommand;

@property (nonatomic,strong) UILabel *name;

@property (nonatomic,strong) UILabel *value;

- (void)setModel:(WKGoodsListItem *)model;

@end
