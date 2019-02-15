//
//  WKAboutMeTableView.h
//  秀加加
//
//  Created by lin on 16/9/7.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKBaseTableView.h"

@interface WKAboutMeTableView : WKBaseTableView

typedef void (^SelectClickType) (NSIndexPath *index);

@property (nonatomic,strong) SelectClickType selectClickType;

@property (nonatomic,strong) NSArray *titles;

@end
