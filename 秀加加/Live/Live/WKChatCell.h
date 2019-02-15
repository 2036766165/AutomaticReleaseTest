//
//  WKChatCell.h
//  wdbo
//
//  Created by sks on 16/7/1.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>


@class WKMessage;

@protocol WKChatDelegate <NSObject>
- (void)chatClick:(id)cell type:(WKMessageClickType)type;
@end

@interface WKChatCell : UITableViewCell

@property (nonatomic,weak) id <WKChatDelegate> delegate;

- (void)setMessage:(WKMessage *)message;

@end
