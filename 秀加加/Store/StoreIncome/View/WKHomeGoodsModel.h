//
//  WKHomeGoodsModel.h
//  秀加加
//
//  Created by Chang_Mac on 16/9/30.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKHomeGoodsModel : NSObject

@property (strong, nonatomic) NSString * Duration;
@property (copy,nonatomic)    NSString * GoodsCode;
@property (strong, nonatomic) NSString * EndTime;

@property (strong, nonatomic) NSString * GoodsName;

@property (strong, nonatomic) NSString * GoodsPicUrl;

@property (strong, nonatomic) NSString * IsAuction;

@property (strong, nonatomic) NSString * Location;

@property (strong, nonatomic) NSString * Price;

@property (strong, nonatomic) NSString * ShopAuthenticationStatus;

@property (strong, nonatomic) NSString * ShopOwnerBPOID;

@property (strong, nonatomic) NSString * ShopOwnerLevel;

@property (strong, nonatomic) NSString * ShopOwnerName;

@property (strong, nonatomic) NSString * ShopOwnerNo;

@property (strong, nonatomic) NSString * ShopOwnerPhoto;

@property (copy,nonatomic)    NSString * RemainTime;

@property (strong, nonatomic) NSString * SaleType;

@property (strong, nonatomic) NSString * CurrentPrice;

@end
