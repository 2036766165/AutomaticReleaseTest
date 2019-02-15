//
//  WKContactTableView.h
//  秀加加
//
//  Created by lin on 16/9/8.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKBaseTableView.h"

@interface WKContactTableView : WKBaseTableView

typedef void (^SelectClickType) (NSIndexPath *index);

@property (nonatomic,strong) SelectClickType selectClickType;

@end
