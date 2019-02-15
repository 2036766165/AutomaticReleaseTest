//
//  WKIncomeRechargeView.h
//  秀加加
//
//  Created by Chang_Mac on 17/2/17.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import "WKBaseTableView.h"

@interface WKIncomeRechargeView : WKBaseTableView

@property (copy, nonatomic) void(^refreshBlock)(NSInteger type);

@property (strong, nonatomic) NSMutableArray *modelArr;

@end
