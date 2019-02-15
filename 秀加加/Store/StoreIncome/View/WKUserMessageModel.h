//
//  WKUserMessageModel.h
//  秀加加
//
//  Created by Chang_Mac on 16/10/9.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKUserMessageModel : NSObject

@property (strong, nonatomic) NSString * BPOID;

@property (strong, nonatomic) NSString * FollowCount;

@property (strong, nonatomic) NSString * FunsCount;

@property (strong, nonatomic) NSString * IsFollow;

@property (strong, nonatomic) NSString * Location;

@property (strong, nonatomic) NSString * MemberLevel;

@property (strong, nonatomic) NSString * MemberMinPhoto;

@property (strong, nonatomic) NSString * MemberName;

@property (strong, nonatomic) NSString * MemberNo;

@property (strong, nonatomic) NSString * MemberPhoto;

@property (strong, nonatomic) NSString * Sex;

@property (strong, nonatomic) NSString * ShopAuthenticationStatus;

@property (strong, nonatomic) NSString * ShopTag;

@property (strong, nonatomic) NSString * TodayOrderReward;

@property (strong, nonatomic) NSString * TodayReward;

@property (strong, nonatomic) NSString * TotalReward;

/*
 *禁言状态
 @parm 禁言类型：0未禁言  1直播间禁言 2系统禁言
 */
@property (nonatomic,copy)    NSNumber *DisableStatus; //  0
@end
