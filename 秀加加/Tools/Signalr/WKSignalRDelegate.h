//
//  WKSignalRDelegate.h
//  wdbo
//
//  Created by sks on 16/7/1.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WKMessage;

typedef enum : NSUInteger {
    WKMessageInfoTypeUnknown,    // 未知消息
    WKMessageInfoTypeReceiveMsg, // 普通消息
    WKMessageInfoTypeGetList,    // 获取列表
    WKMessageInfoTypeOnline,     // 上线
    WKMessageInfoTypeOffline,    // 下线
    WKMessageInfoTypeImg,        // 图片
    WKMessageInfoTypeSystemMsg,  // 系统消息
    WKMessageInfoTypeReward,      // 打赏
    WKMessageInfoTypeAuction,     // 拍卖
    WKMessageInfoTypeAuctionBid,     // 拍卖加价
    WKMessageInfoTypeAuctionCount,    // 拍卖参数人数
    WKMessageInfoTypeVideoPlay,       // 直播开始
    WKMessageInfoTypeVideoPause,      // 直播暂定
    WKMessageInfoTypeVideoClose,       // 直播关闭
    WKMessageInfoTypeSystemLoginOut,   // 违规强制退出
    WKMessageInfoTypeNetStatus,        
    WKMessageInfoTypeRoomTalk,          // 禁言/解禁
    WKMessageInfoTypeAuctionDelay,      // 拍卖延迟结束
    WKMessageInfoTypeSystemMsgPush,         // 推多条消息
    WKMessageInfoTypeHeadList,            // 获取列表(前20条)
    WKMessageInfoTypeJoin,               // join auction
    WKMessageInfoTypeRedGroupEvenlop,        // red group evenlope
    WKMessageInfoTypeRedSingleEvenlop        // red single evenlope
} WKMessageInfoType;

//typedef void(^MessageBlock)(WKMessageInfoType type,id obj);
@protocol WKSingalRDelegate <NSObject>
- (void)receiveMsgType:(WKMessageInfoType)type msgBody:(id)msgBody;
@end

@interface WKSignalRDelegate : NSObject

@property (nonatomic,weak) id<WKSingalRDelegate> delegate;

- (instancetype)initWithMemberNo:(NSString *)memberNo andBPOId:(NSString *)bpoId;

// 发送消息
- (void)sendMsg:(WKMessage *)msg completionBlock:(void(^)(BOOL isSended))block;

/**
 *  连接服务器
 */
-(void)connect;
/**
 *  断开连接服务器
 */
-(void)disconnect;

@end
