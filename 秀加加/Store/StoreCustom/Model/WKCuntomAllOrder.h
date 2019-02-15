//
//  WKCuntomAllOrder.h
//  wdbo
//
//  Created by Chang_Mac on 16/7/3.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKCuntomAllOrder : NSObject

@property (strong, nonatomic) NSString * CreateTimeStr;

@property (strong, nonatomic) NSString * CurrentOrderStatus;

@property (strong, nonatomic) NSString * OrderCode;

@property (strong, nonatomic) NSString * OrderStatus;

@property (strong, nonatomic) NSString * PayAmount;

@property (strong, nonatomic) NSString * ProductAmount;

@property (strong, nonatomic) NSString * TotailAmount;

@property (strong, nonatomic) NSString * TranFeeAmount;

@property (strong, nonatomic) NSArray * Products;

@end

@interface WKProducts : NSObject

@property (strong, nonatomic) NSString * CommentStatus;

@property (strong, nonatomic) NSString * CreateTime;

@property (strong, nonatomic) NSString * GoodsCode;

@property (strong, nonatomic) NSString * GoodsModelCode;

@property (strong, nonatomic) NSString * GoodsModelName;

@property (strong, nonatomic) NSString * GoodsName;

@property (assign, nonatomic) NSInteger GoodsNumber;

@property (strong, nonatomic) NSString * GoodsPicUrl;

@property (strong, nonatomic) NSString * GoodsPrice;

@property (strong, nonatomic) NSString * Memo;

@property (strong, nonatomic) NSString * OrderCode;

@property (strong, nonatomic) NSString * OrderID;

@property (strong, nonatomic) NSString * TotailPrice;


@end
