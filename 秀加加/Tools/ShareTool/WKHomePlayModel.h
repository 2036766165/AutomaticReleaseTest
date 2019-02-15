//
//  WKHomePlayModel.h
//  秀加加
//
//  Created by Chang_Mac on 16/9/23.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKHomePlayModel : NSObject

@property (strong, nonatomic) NSString * BPOID;

@property (copy,nonatomic)    NSString *AppShowUrl;

@property (strong, nonatomic) NSString * CurrentOnlineNumber;

@property (strong, nonatomic) NSString * EndTime;

@property (strong, nonatomic) NSString * FunsCount;

@property (strong, nonatomic) NSString * GoodsCode;

@property (strong, nonatomic) NSString * GoodsPhoto;

@property (strong, nonatomic) NSString * LastShowTime;

@property (strong, nonatomic) NSString * LiveStatus;

@property (strong, nonatomic) NSString * Location;

@property (strong, nonatomic) NSString * MemberLevel;

@property (strong, nonatomic) NSString * MemberMinPhoto;

@property (strong, nonatomic) NSString * MemberMood;

@property (strong, nonatomic) NSString * MemberName;

@property (strong, nonatomic) NSString * MemberNo;

@property (strong, nonatomic) NSString * MemberPhoto;

@property (strong, nonatomic) NSString * OrderAmount;

@property (strong, nonatomic) NSString * ShopAuthenticationStatus;

@property (strong, nonatomic) NSString * ShopTag;

@property (strong, nonatomic) NSString * SaleEndTime;

@property (strong, nonatomic) NSString * PlayMode;

@property (nonatomic,strong) UIImageView *iconImage;

@property (strong, nonatomic) NSString * RemainTime;

@property (copy, nonatomic) NSNumber *CurrentShowStatus;

@property (strong, nonatomic) NSString * TotalSaleSecond;

@property (nonatomic,copy) NSNumber *Sex;

@property (strong, nonatomic) NSString * SaleType;

@property (strong, nonatomic) NSString * CurrentPrice;

@property (strong, nonatomic) NSString * GoodsPrice;

@property (nonatomic,copy) NSNumber *LoginMemberLevel;

@end

// 首页轮播图类
@interface WKScrollImageModel : NSObject

@property (nonatomic , strong) NSString * ImageURL;

@property (nonatomic , strong) NSString * LinkURL;

@property (nonatomic , strong) NSString * Sort;
@end
