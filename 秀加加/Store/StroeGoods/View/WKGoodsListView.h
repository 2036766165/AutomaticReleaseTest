//
//  WKGoodsListView.h
//  秀加加
//
//  Created by sks on 2016/9/13.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKBaseTableView.h"
#import "WKGoodsBottomView.h"

@interface WKGoodsListView : WKBaseTableView

@property (nonatomic,copy) void(^selectedIndex)(NSInteger);

@property (strong, nonatomic) NSMutableArray * titleArr;

@property (strong, nonatomic) NSMutableArray * colorArr;

@property (strong, nonatomic) UIView *promptView;

@property (strong, nonatomic) UILabel * promptLabel;

@property (assign, nonatomic) NSInteger time;

@property (strong, nonatomic) NSMutableArray * tagModelArr;


- (instancetype)initWithFrame:(CGRect)frame with:(WKGoodsType)type;

@end
