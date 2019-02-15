//
//  WKOrderDetailModel.h
//  wdbo
//
//  Created by lin on 16/09/26
//  Copyright (c) Walkingtec. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WKOrderProducts;

@interface WKOrderDetailModel : NSObject

@property (nonatomic,strong) NSString *CustomerName;
@property (nonatomic,strong) NSString *CustomerPicUrl;
@property (nonatomic,assign) NSInteger IsShow;
@property (nonatomic, copy) NSString *ExpressCode;
@property (nonatomic,strong) NSString *ServiceAmount;

@property (nonatomic, copy) NSString *ExpressCompanyCode;

@property (nonatomic, assign) NSInteger GoodsCount;

@property (nonatomic, copy) NSString *ShipZip;

@property (nonatomic, strong) NSString *PayAmount;

//@property (nonatomic, strong) NSArray<WKOrderProducts *> *Products;
@property (nonatomic, strong) NSArray *Products;

@property (nonatomic, assign) NSInteger OrderFrom;

@property (nonatomic, copy) NSString *PayDateStr;

@property (nonatomic, assign) NSInteger ShipStatus;

@property (nonatomic, copy) NSString *HasBeenDate; //签收时间

@property (nonatomic, assign) NSInteger PayType;

@property (nonatomic, copy) NSString *OrderCode;

@property (nonatomic, copy) NSString *ShipCity;

@property (nonatomic, assign) NSInteger CommentStatus;

@property (nonatomic, copy) NSString *ShopOwnerNo;

@property (nonatomic,strong) NSString *ShopOwnerName;

@property (nonatomic,strong) NSString *ShopOwnerPicUrl;

@property (nonatomic, copy) NSString *CurrentOrderStatus;

@property (nonatomic, assign) NSInteger PayStatus;

@property (nonatomic, copy) NSString *ShipPhone;

@property (nonatomic, copy) NSString *ShipDateStr;

@property (nonatomic, copy) NSString *TranFeeAmount;

@property (nonatomic, copy) NSString *CreateTimeStr;

@property (nonatomic, copy) NSString *PayDate;//付款时间

@property (nonatomic, copy) NSString *ExpressCompanyName;

@property (nonatomic, assign) NSInteger OrderStatus;

@property (nonatomic, strong) NSString *GoodsAmount;

@property (nonatomic, copy) NSString *ShipCounty;

@property (nonatomic, copy) NSString *ShipName;//联系人

@property (nonatomic, copy) NSString *CreateTime;//创建时间

@property (nonatomic, copy) NSString *ShipDate;//发货时间

@property (nonatomic,assign) NSInteger GoodsModelCode;

@property (nonatomic,strong) NSString *GoodsModelName;

@property (nonatomic,strong) NSString *GoodsPrice;

@property (nonatomic,strong) NSString *GoodsStartPrice;

@property (nonatomic,strong) NSString *GoodsPicUrl;

@property (nonatomic,assign) NSInteger GoodsNumber;

@property (nonatomic,strong) NSString *TotailPrice;

@property (nonatomic,assign) NSInteger RemainTime;

@property (nonatomic,strong) NSString *OrderID;

@property (nonatomic, assign) NSInteger OrderType;

@property (nonatomic, copy) NSString *CustomerBPOID;

@property (nonatomic, copy) NSString *ShopOwnerBPOID;

@property (nonatomic, copy) NSString *TranFeeAmountStr;

@property (nonatomic, copy) NSString *ShipProvince;

@property (nonatomic, copy) NSString *GoodsAmountStr;

@property (nonatomic, copy) NSString *PayTypeStr;

@property (nonatomic, copy) NSString *PayCode;

@property (nonatomic, copy) NSString *ShipAddress;//地址

@property (nonatomic, copy) NSString *ExpressDetail;

@property (nonatomic, copy) NSString *HasBeenDateStr;

@property (nonatomic, copy) NSString *CustomerNo;

@end

@interface WKOrderProducts : NSObject

@property (nonatomic, copy) NSString *GoodsPicUrl;

@property (nonatomic, copy) NSString *GoodsPrice;

@property (nonatomic, copy) NSString *CreateTimeStr;

@property (nonatomic, copy) NSString *CreateTime;

@property (nonatomic, assign) NSInteger GoodsModelCode;

@property (nonatomic, copy) NSString *OrderCode;

@property (nonatomic, copy) NSString *GoodsModelName;

@property (nonatomic, assign) NSInteger GoodsNumber;

@property (nonatomic, copy) NSString *TotailPriceStr;

@property (nonatomic, strong) NSString *GoodsStartPrice;

@property (nonatomic, copy) NSString *ShopOwnerNo;

@property (nonatomic, copy) NSString *CustomerName;

@property (nonatomic, copy) NSString *CustomerNo;

@property (nonatomic, copy) NSString *OrderID;

@property (nonatomic, assign) NSInteger CommentStatus;

@property (nonatomic, assign) NSInteger GoodsCode;

@property (nonatomic, copy) NSString *GoodsStartPriceStr;

@property (nonatomic, copy) NSString *GoodsName;

@property (nonatomic, assign) NSInteger TotailPrice;

@property (nonatomic, assign) NSInteger IsVirtual;
@end
