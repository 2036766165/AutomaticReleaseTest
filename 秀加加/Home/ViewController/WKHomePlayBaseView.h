//
//  WKHomePlayBaseView.h
//  秀加加
//
//  Created by Chang_Mac on 16/9/2.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKBaseTableView.h"

@interface WKHomePlayBaseView : WKBaseTableView

typedef void(^scrollDelegate)(CGFloat);
typedef void(^scrollEnd)();
typedef void(^homePlayBlock)(NSInteger,NSString *);

-(instancetype)initWithFrame:(CGRect)frame andDataArr:(NSArray *)dataArr cycle:(BOOL)cycleViewHidden block:(homePlayBlock)block;

@property (copy, nonatomic) homePlayBlock block;

@property (copy, nonatomic) scrollDelegate scrollBlock;

@property (copy, nonatomic) scrollEnd endBlock;

@property (assign, nonatomic) BOOL isSearch;

@property (nonatomic , strong) NSArray * imageScrollList;

-(void)setTabeViewFrame:(CGRect)frame;

typedef void(^jumpWebPage)(NSString *);
@property (copy ,nonatomic) jumpWebPage JumpBlock;

@end
