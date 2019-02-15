//
//  XCUserMessage.h
//  XCUserMessage
//
//  Created by Chang_Mac on 16/9/7.
//  Copyright © 2016年 Chang_Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKUserMessageModel.h"

typedef enum {
    mySelfMessage,
    rewardMessage,//有打赏字段
    otherMessage
}userMessageType;

typedef enum {
    privateChatType,//私信
    gagType,//禁言
    emptyType,
    hostType,// 看主播信息
    
}styleType;

typedef void(^chatBlock)(NSInteger);//1.禁言 2.私信 3.红包
//@interface WKUserParameterModel : NSObject
//@property (nonatomic,assign) NSInteger muteType;
//@property (nonatomic,copy)   NSString *muteBPOID;
//
//@end

//typedef void(^chatBlock)(WKUserParameterModel *md);

@interface WKUserMessage : UIView

@property (nonatomic,assign) BOOL hasShowed;

+(void)showUserMessageWithModel:(WKUserMessageModel *)model andType:(userMessageType)type chatType:(styleType)chatType :(chatBlock)block;

@end
