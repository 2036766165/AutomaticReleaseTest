//
//  WKOnLineMd.h
//  wdbo
//
//  Created by sks on 16/7/2.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKOnLineMd : NSObject

@property (nonatomic,copy) NSString *AppShowUrl;
@property (nonatomic,copy) NSString *Birthday;
@property (nonatomic,copy) NSString *CellPhone;
@property (nonatomic,copy) NSString *MemberCode;
@property (nonatomic,copy) NSString *MemberID;
@property (nonatomic,copy) NSString *MemberName;
@property (nonatomic,copy) NSString *MemberPhotoMinUrl;
@property (nonatomic,copy) NSString *MemberPhotoUrl;
@property (nonatomic,copy) NSString *OpenID;
@property (nonatomic,copy) NSString *PopTips;
@property (nonatomic,copy) NSString *PushUrl;
@property (nonatomic,copy) NSString *RegisterTime;
@property (nonatomic,copy) NSString *Sex;
@property (nonatomic,copy) NSString *TrueName;
@property (nonatomic,copy) NSString *LiveKey;
@property (nonatomic,copy) NSString *UseWX;
@property (copy, nonatomic) NSString * ml;

@property (nonatomic,copy) NSString *WXShowUrl;
@property (nonatomic,copy) NSString *BPOID;

@property (nonatomic,assign) NSInteger idx;   // 观众的下标

/*
 0 未禁言
 1 主播禁言
 2 系统禁言
 */
@property (nonatomic,copy) NSNumber *BanType;

@property (nonatomic,assign) BOOL isAddItem;
@property (nonatomic,assign) NSUInteger totalPerson;

@end
