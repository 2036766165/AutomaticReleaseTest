//
//  WKBankTableView.h
//  wdbo
//
//  Created by Chang_Mac on 16/6/27.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import "WKBaseTableView.h"
#import "WKOrderFixExpressModel.h"

typedef void(^bankBlock)(NSString *,NSInteger);

@interface  WKSelectLogisticsTableView: WKBaseTableView

-(instancetype)initWithFrame:(CGRect)frame andDataArr:(NSArray *)titleArr Block:(bankBlock)block;

/**
 *  block
 */
@property (copy, nonatomic) bankBlock block;

@property (nonatomic,strong) NSArray *arrayLog;

@end
