//
//  WKAuthShopModel.h
//  秀加加
//
//  Created by sks on 2016/9/26.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKAuthShopModel : NSObject

@property (nonatomic,copy) NSString *ShopName;
@property (nonatomic,copy) NSString *ShopLeader;
@property (nonatomic,copy) NSString *LeaderPhone;
@property (nonatomic,copy) NSString *CheckCode;
@property (nonatomic,copy) NSString *ProvinceName;
@property (nonatomic,copy) NSString *CityName;
@property (nonatomic,copy) NSString *CountyName;
@property (nonatomic,copy) NSString *ShopAddress;
@property (nonatomic,copy) NSString *ShopLong;
@property (nonatomic,copy) NSString *ShopLat;
@property (nonatomic,copy) NSString *ShopLicenses;
@property (nonatomic,copy) NSString *IDCardFrontPhoto;
@property (nonatomic,copy) NSString *IDCardBackPhoto;

// 认证状态
@property (nonatomic,copy) NSNumber *ApproveStatus;

@end
