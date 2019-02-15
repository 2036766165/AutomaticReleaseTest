//
//  WKPopverCell.h
//  show++
//
//  Created by sks on 16/8/1.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>
//
//typedef void(^selec)(<#arguments#>);
@protocol WKItemClickDelegate <NSObject>
- (void)itemSelectedWith:(id)obj;
@end

@class WKPopverItem;

@interface WKPopverCell : UITableViewCell

@property (nonatomic,weak) id <WKItemClickDelegate> delegate;

@property (nonatomic,copy) void(^selectedInex)(id obj);

- (void)setItem:(WKPopverItem *)item;

@end
