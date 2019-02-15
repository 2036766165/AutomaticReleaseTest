//
//  WKAddressTableView.h
//  秀加加
//
//  Created by lin on 16/9/5.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKBaseTableView.h"
#import "WKGoodsItemProtocol.h"

@interface WKAddressTableView : WKBaseTableView

@property (nonatomic,weak) id <WKGoodsItemProtocol> delegate;

@property (nonatomic,assign) BOOL isEidt;

- (NSArray *)getSelectedArr;

@end
