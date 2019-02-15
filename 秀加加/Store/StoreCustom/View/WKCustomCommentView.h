//
//  WKCustomCommentView.h
//  秀加加
//
//  Created by Chang_Mac on 16/10/10.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKBaseTableView.h"

//回复评论回调 时长,路径
typedef void (^ClickType) (NSString *,NSString *,NSString *);

@interface WKCustomCommentView : WKBaseTableView

@property (nonatomic,copy) ClickType clickType;

@property (nonatomic,copy)void(^promptBlock)(NSString *);

@end
