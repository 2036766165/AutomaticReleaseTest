//
//  WKItemTableViewCell.h
//  wdbo
//
//  Created by sks on 16/6/22.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WKMarkModel;

@protocol WKItemDelegete <NSObject>
- (void)deleteWith:(id)obj;
@end

@interface WKItemTableViewCell : UITableViewCell

@property (nonatomic,weak) id<WKItemDelegete> delegate;

- (void)setItemModel:(WKMarkModel *)model;

@end
