//
//  WKGetShopAuthenticationModel.h
//  秀加加
//
//  Created by lin on 2016/10/31.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKGetShopAuthenticationModel : NSObject

@property (nonatomic,strong) NSString *ShopName;

@property (nonatomic,strong) NSString *ShopLeader;

@property (nonatomic,strong) NSString *LeaderPhone;

@property (nonatomic,strong) NSString *ProvinceName;

@property (nonatomic,strong) NSString *CityName;

@property (nonatomic,strong) NSString *CountyName;

@property (nonatomic,strong) NSString *ShopAddress;

@property (nonatomic,strong) NSString *ShopLong;

@property (nonatomic,strong) NSString *ShopLat;

@property (nonatomic,strong) NSString *ShopLicenses;

@property (nonatomic,strong) NSString *IDCardFrontPhoto;

@property (nonatomic,strong) NSString *IDCardBackPhoto;

@property (nonatomic,assign) NSInteger ApproveStatus;

@end
