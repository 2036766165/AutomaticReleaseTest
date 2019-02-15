//
//  AuctionDetailsModel.h
//  秀加加
//
//  Created by 吴文豪 on 2016/10/8.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKAuctionDetailsModel : NSObject

//订单编号
@property (strong, nonatomic) NSString * OrderCode;

//交易总金额
@property (strong, nonatomic) NSString * PayAmount;

//成交价格
@property (strong, nonatomic) NSString * GoodsAmount;

//拍得用户
@property (strong, nonatomic) NSString * CustomerName;

//成交时间
@property (strong, nonatomic) NSString * PayDate;

//支付状态
@property (strong, nonatomic) NSString * PayStatus;

//起拍价格，保证金
@property (strong, nonatomic) NSString * GoodsStartPrice;

//拍卖服务费
@property (strong,nonatomic) NSString * ServiceAmount;



//商品信息
@property (strong, nonatomic) NSArray * Products;

@end

@interface ActionOrderProducts : NSObject

//商品名称
@property (strong, nonatomic) NSString * GoodsName;



@end
