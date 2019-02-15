//
//  WKVirtualTableViewCell.h
//  秀加加
//
//  Created by sks on 2017/2/9.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WKGoodsModel;
@protocol WKCellOperationProtocol;

@interface WKVirtualTableViewCell : UITableViewCell

@property (nonatomic,weak) id<WKCellOperationProtocol> delegate;
@property (nonatomic,weak) WKGoodsModel *dataModel;

@end
