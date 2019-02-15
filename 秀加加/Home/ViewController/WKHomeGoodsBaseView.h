//
//  WKHomeGoodsView.h
//  秀加加
//
//  Created by Chang_Mac on 16/9/2.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKBaseTableView.h"
#import "WKHomePlayBaseView.h"

@class WKHomeGoodsModel;

@protocol WKSelectGoodsDelegate <NSObject>
- (void)selectGoodsWith:(WKHomeGoodsModel *)goodsModel;
@end

@interface WKHomeGoodsBaseView : WKBaseTableView

typedef void(^scrollDelegate
)(CGFloat);

typedef void(^homeGoodsBlock)(NSInteger,NSString *);

-(instancetype)initWithFrame:(CGRect)frame block:(homeGoodsBlock)block;

-(void)setTabeViewFrame:(CGRect)frame;

@property (nonatomic,assign) id<WKSelectGoodsDelegate> delegate;

@property (copy, nonatomic) homeGoodsBlock block;

@property (copy, nonatomic) scrollDelegate scrollBlock;

@property (copy, nonatomic) scrollEnd endBlock;

@end
