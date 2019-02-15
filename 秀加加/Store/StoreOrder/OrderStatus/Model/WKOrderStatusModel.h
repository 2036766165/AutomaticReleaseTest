//
//  WKOrderStatusModel.h
//  wdbo
//
//  Created by lin on 16/6/29.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKOrderStatusModel : NSObject

@property (nonatomic,assign) NSInteger  TotalPageCount;

@property (nonatomic,strong) NSArray *InnerList;

@end

@interface WKOrderStatusItemModel : WKOrderStatusModel

@property (nonatomic,strong) NSString *ShopOwnerBPOID;
@property (nonatomic,strong) NSString *ShopOwnerNo;
@property (nonatomic,strong) NSString *ShopOwnerName;
@property (nonatomic,strong) NSString *ShopOwnerPicUrl;
@property (nonatomic,assign) NSInteger IsShow;
@property (nonatomic,strong) NSString *CustomerBPOID;
@property (nonatomic,strong) NSString *CustomerNo;
@property (nonatomic,strong) NSString *CustomerName;
@property (nonatomic,strong) NSString *CustomerPicUrl;
@property (nonatomic,strong) NSString *CreateTime;
@property (nonatomic,assign) NSInteger RemainTime;
@property (nonatomic,strong) NSString *CreateTimeStr;

@property (nonatomic,copy) NSString *OrderCode;

@property (nonatomic,assign) NSInteger OrderFrom;

@property (nonatomic,assign) NSInteger OrderType;

@property (nonatomic,assign) NSInteger OrderStatus;

@property (nonatomic,strong) NSString *CurrentOrderStatus;

@property (nonatomic,assign) NSInteger PayStatus;

@property (nonatomic,assign) NSInteger PayType;

@property (nonatomic,strong) NSString *PayTypeStr;

@property (nonatomic,strong) NSArray *PayDate;

@property (nonatomic,strong) NSString *PayDateStr;

@property (nonatomic,strong) NSString *PayCode;

@property (nonatomic,assign) NSInteger GoodsCount;//商品总数量

@property (nonatomic,strong) NSString *GoodsAmount;

@property (nonatomic,strong) NSString *GoodsAmountStr;//商品金额 （总金额= 商品金额+运费）

@property (nonatomic,strong) NSString *TranFeeAmount;//运费

@property (nonatomic,strong) NSString *PayAmount;//总金额

@property (nonatomic,assign) NSInteger ShipStatus;

@property (nonatomic,strong) NSString *ShipName;

@property (nonatomic,strong) NSString *ShipProvince;

@property (nonatomic,strong) NSString *ShipCity;

@property (nonatomic,strong) NSString *ShipCounty;

@property (nonatomic,strong) NSString *ShipAddress;

@property (nonatomic,strong) NSString *ShipZip;

@property (nonatomic,strong) NSString *ShipPhone;

@property (nonatomic,strong) NSString *ShipDate;

@property (nonatomic,strong) NSString *ShipDateStr;

@property (nonatomic,strong) NSString *HasBeenDate;

@property (nonatomic,strong) NSString *HasBeenDateStr;

@property (nonatomic,strong) NSString *ExpressCompanyName;

@property (nonatomic,strong) NSString *ExpressCompanyCode;

@property (nonatomic,strong) NSString *ExpressCode;

@property (nonatomic,copy) NSString *ExpressDetail;

@property (nonatomic,assign) NSInteger CommentStatus;

@property (nonatomic,strong) NSArray *Products;

@end

@interface WKOrderProduct : NSObject

@property (nonatomic,strong) NSString *OrderID;
@property (nonatomic,strong) NSString *ShopOwnerNo;
@property (nonatomic,strong) NSString *CustomerNo;
@property (nonatomic,strong) NSString *CustomerName;//客户名字
@property (nonatomic,strong) NSString *OrderCode;
@property (nonatomic,assign) NSInteger GoodsCode;
@property (nonatomic,strong) NSString *GoodsName;
@property (nonatomic,assign) NSInteger GoodsModelCode;
@property (nonatomic,strong) NSString *GoodsModelName;
@property (nonatomic,strong) NSString *GoodsPrice;
@property (nonatomic,strong) NSString *GoodsStartPrice;//起拍价
@property (nonatomic,strong) NSString *GoodsPicUrl;
@property (nonatomic,assign) NSInteger GoodsNumber;
@property (nonatomic,assign) NSInteger TotailPrice;
@property (nonatomic,assign) NSInteger CommentStatus;//1=代表以评论
@property (nonatomic,strong) NSString *CreateTime;
@property (assign, nonatomic) NSInteger IsVirtual;
@end
