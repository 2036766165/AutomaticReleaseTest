//
//  WKMessageBookTableView.h
//  秀加加
//
//  Created by lin on 2016/9/20.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKBaseTableView.h"

@interface WKMessageBookTableView : WKBaseTableView

typedef void (^SelectClickType) (NSInteger MessageBookRow);

@property (nonatomic,copy) SelectClickType selectClickType;

@end
