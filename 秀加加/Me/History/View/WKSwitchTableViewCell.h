//
//  WKSwitchTableViewCell.h
//  秀加加
//
//  Created by sks on 2016/11/30.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WKShowItemModel;

@protocol WKSwitchDelegate <NSObject>
- (void)switchDelegateWithItem:(WKShowItemModel *)item;
@end

@interface WKSwitchTableViewCell : UITableViewCell

@property (nonatomic,assign) id<WKSwitchDelegate> delegate;

- (void)setItem:(WKShowItemModel *)item;

@end
