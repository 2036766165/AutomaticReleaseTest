//
//  WKInComeTableView.h
//  wdbo
//
//  Created by lin on 16/6/26.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import "WKBaseTableView.h"
typedef void(^incomeBlock)(NSInteger );
@interface WKInComeTableView : WKBaseTableView

/**
 *  block
 */
@property (copy, nonatomic) incomeBlock block;

@property (copy, nonatomic) void(^refreshBlock)(NSInteger type);

@property (strong, nonatomic) NSMutableArray *modelArr;

@end
