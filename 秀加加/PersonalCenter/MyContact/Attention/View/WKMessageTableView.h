//
//  WKMessageTableView.h
//  秀加加
//
//  Created by lin on 2016/9/20.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKBaseTableView.h"

@interface WKMessageTableView : WKBaseTableView

typedef void (^SelectClickType) (NSInteger row);

@property (nonatomic,copy) SelectClickType selectClickType;

@end
