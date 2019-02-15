//
//  WKMessageCenterModel.h
//  wdbo
//
//  Created by Chang_Mac on 16/7/1.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKMessageCenterModel : NSObject

@property (nonatomic,strong) NSString *  ExpressCompanyName;

@property (nonatomic,strong) NSString *  OrderCode;

@property (nonatomic,strong) NSString *  CurrentOrderStatus;

@property (nonatomic,strong) NSString *  CreateTimeStr;

@property (nonatomic,strong) NSString *  ExpressCompanyCode;

@property (nonatomic,strong) NSString *  ExpressDetail;

@property (strong, nonatomic) NSString * PayAmount;

@property (strong, nonatomic) NSString * ShipName;

@property (nonatomic,strong) NSArray *  Products;

@end

@interface products : NSObject

@property (strong , nonatomic) NSString *GoodsName;

@property (strong , nonatomic) NSString *GoodsModelCode;

@property (strong , nonatomic) NSString *GoodsModelName;

@property (strong , nonatomic) NSString *GoodsNumber;

@property (strong, nonatomic) NSString * GoodsPrice;

@end

@interface ExpressDetail : NSObject

@property (strong, nonatomic) NSString *context;

@property (strong, nonatomic) NSString *ftime;

@end
