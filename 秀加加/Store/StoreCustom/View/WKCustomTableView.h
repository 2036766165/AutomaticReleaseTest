//
//  WKCustomTableView.h
//  秀加加
//
//  Created by Chang_Mac on 16/10/9.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKBaseTableView.h"
#import "WKCustomTableModel.h"

@interface WKCustomTableView : WKBaseTableView

@property (copy, nonatomic) void(^customTableBlock) (NSString *memberID);


@end
