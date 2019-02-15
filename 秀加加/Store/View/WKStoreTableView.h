//
//  WKStoreTableView.h
//  秀加加
//
//  Created by lin on 16/9/2.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKBaseTableView.h"

@interface WKStoreTableView : WKBaseTableView

typedef void (^SelectViewConotroller)(NSIndexPath *indexPath);

@property (nonatomic,copy) SelectViewConotroller selectViewConotroller;

@end
