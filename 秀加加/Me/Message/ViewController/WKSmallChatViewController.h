//
//  WKSmallChatViewController.h
//  秀加加
//
//  Created by Chang_Mac on 16/11/29.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>
typedef void(^exitBlock)();
typedef enum {
    showBack,
    hiddenBack
}backType;

@interface WKSmallChatViewController : RCConversationViewController

@property (copy, nonatomic) exitBlock exit;

@property (copy, nonatomic) exitBlock refresh;

@property (assign,nonatomic) backType backType;

@property (assign, nonatomic) BOOL isLive;

@end
