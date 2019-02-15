//
//  WKEvaluateTableView.h
//  秀加加
//
//  Created by lin on 16/9/7.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKBaseTableView.h"
#import "WKEvaluateTableModel.h"
@interface WKEvaluateTableView : WKBaseTableView

typedef void (^ClickEvaluateCall) (WKEvaluateTableModel * detailsModel);

@property (nonatomic,copy) ClickEvaluateCall clickEvaluateCall;

@end
