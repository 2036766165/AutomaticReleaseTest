//
//  WKGoodsListTableViewCell.h
//  秀加加
//
//  Created by sks on 2016/9/13.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WKGoodsListItem;
@protocol WKGoodsItemProtocol;

@interface WKGoodsListTableViewCell : UITableViewCell

@property (nonatomic,weak) id<WKGoodsItemProtocol> delegate;

- (void)setModel:(WKGoodsListItem *)md;

@end
