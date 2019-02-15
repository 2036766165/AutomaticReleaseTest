//
//  WKFansTableView.h
//  秀加加
//
//  Created by lin on 16/9/6.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKBaseTableView.h"
#import "WKFocusAndFansTableViewCell.h"
#import "WKAttentionModel.h"

@interface WKFansTableView : WKBaseTableView

typedef void (^SelectClickType) (NSInteger row,ClickType type);

@property (nonatomic,copy) SelectClickType selectClickType;

@property (nonatomic,strong) WKAttentionModel *model;

@property (nonatomic,assign) NSInteger type;

@end
