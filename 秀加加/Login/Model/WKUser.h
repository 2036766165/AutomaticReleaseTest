//
//  WKUser.h
//  wdbo
//
//  Created by sks on 16/6/19.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    WKShowStatusNormal,      // 普通状态
    WKShowStatusShowing,     // 推流
    WKShowStatusPlaying      // 观看
} WKShowStatus;

typedef enum : NSUInteger {
    WKRecordingTypeStart,    // 录音开始
    WKRecordingTypeStop,     // 录音结束
    WKRecordingTypeNO        // 未录音
} WKRecordingType;

@interface WKUser : NSObject <NSMutableCopying,NSCopying>

@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *password;
@property (nonatomic,copy) NSString *Token;

@property (nonatomic,assign) BOOL loginStatus; // 登录状态

@property (nonatomic,assign) BOOL isAutoLogin; // 是否自动登录

@property (nonatomic,copy) NSString *AppShowUrl; // 
@property (nonatomic,copy) NSString *Birthday;
@property (nonatomic,copy) NSString *CellPhone;
@property (nonatomic,copy) NSString *MemberCode;
@property (nonatomic,copy) NSString *MemberID;
@property (nonatomic,copy) NSString *BPOID;       
@property (nonatomic,copy) NSString *MpOpenID;
@property (nonatomic,copy) NSString *RongCloudToken;
@property (nonatomic,copy) NSString *MemberName;
@property (nonatomic,copy) NSString *MemberNo;
@property (nonatomic,copy) NSString *MemberLevel;
@property (nonatomic,copy) NSString *MemberPhotoMinUrl;//小头像
@property (nonatomic,copy) NSString *MemberPhotoUrl;//大头像
@property (nonatomic,assign) NSInteger ShopAuthenticationStatus;//认证
@property (nonatomic,copy) NSString *WithdrawOpenID;
@property (nonatomic,copy) NSString *OpenID;
@property (nonatomic,copy) NSString *PopTips;
@property (nonatomic,copy) NSString *PushUrl;
@property (nonatomic,copy) NSString *RegisterTime;
@property (nonatomic,copy) NSNumber *Sex;
@property (nonatomic,copy) NSString *TrueName;
@property (nonatomic,copy) NSString *LiveKey;
@property (nonatomic,copy) NSString *UseWX;
@property (nonatomic,copy) NSString *ShopQRCode;
@property (nonatomic,copy) NSString *ShopAddress;
@property (nonatomic,copy) NSString *ShopTranFee;
@property (nonatomic,copy) NSString *ShopTag;
@property (nonatomic,copy) NSString *ShopName;
@property (nonatomic,copy) NSString *ShopLong;
@property (nonatomic,copy) NSString *ShopLat;
@property (nonatomic,copy) NSString *WXShowUrl;

@property (nonatomic,copy) NSString *storeName;  // 店铺名
@property (nonatomic,copy) NSString *ShopPicture;

@property (nonatomic,strong) UIImageView *usericon;

@property (nonatomic,assign) WKShowStatus showStatus;
@property (nonatomic,assign) BOOL isReviewID;//
@property (nonatomic,assign) WKRecordingType recordType;   // 是否正在录音
@property (nonatomic,assign) BOOL netStatus;               // 网络连接状态 YES


+ (instancetype)sharedInstance;

@end
