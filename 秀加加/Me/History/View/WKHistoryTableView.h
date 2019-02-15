//
//  WKHistoryTableView.h
//  秀加加
//
//  Created by lin on 16/9/8.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKBaseTableView.h"
#import "WKHistoryModel.h"

@interface WKHistoryTableView : WKBaseTableView

typedef void (^SelectClickType) (NSIndexPath *index,NSInteger type);

@property (nonatomic,copy) SelectClickType selectClickType;

@end
