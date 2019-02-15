//
//  WKMessageListView.h
//  秀加加
//
//  Created by sks on 2016/10/20.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WKMessageDelegate <NSObject>
- (void)selectedMessage:(id)message type:(WKMessageClickType)type;
@end

@interface WKMessageListView : UIView

@property (nonatomic,assign) id<WKMessageDelegate> delegate;
// 插入消息
- (void)insertMessageWith:(id)message;

@end
