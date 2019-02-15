//
//  WKGoodsModel.h
//  秀加加
//
//  Created by sks on 2016/9/18.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKGoodsListModel : NSObject

@property (nonatomic,copy) NSArray *InnerList;
@property (nonatomic,copy) NSNumber *TotalPageCount;
@end

//@property (strong, nonatomic) NSString * Duration;
//
//@property (strong, nonatomic) NSString * EndTime;
//
//@property (strong, nonatomic) NSString * GoodsName;
//
//@property (strong, nonatomic) NSString * GoodsPicUrl;
//
//@property (strong, nonatomic) NSString * IsAuction;
//
//@property (strong, nonatomic) NSString * Location;
//
//@property (strong, nonatomic) NSString * Price;
//
//@property (strong, nonatomic) NSString * ShopAuthenticationStatus;
//
//@property (strong, nonatomic) NSString * ShopOwnerBPOID;
//
//@property (strong, nonatomic) NSString * ShopOwnerLevel;
//
//@property (strong, nonatomic) NSString * ShopOwnerName;
//
//@property (strong, nonatomic) NSString * ShopOwnerNo;
//
//@property (strong, nonatomic) NSString * ShopOwnerPhoto;

@interface WKGoodsListItem : NSObject

@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *GoodsName;
@property (nonatomic,copy) NSNumber *GoodsCode;
@property (nonatomic,copy) NSString *Description;
@property (nonatomic,copy) NSNumber *SaleCount;
@property (nonatomic,copy) NSNumber *Stock;
@property (nonatomic,copy) NSString *PicUrl;
@property (nonatomic,copy) NSNumber *Price;
@property (nonatomic,copy) NSString *CreateTime;
@property (nonatomic,copy) NSString *UpdateTime;
@property (nonatomic,copy) NSString *CreateTimeStr;
@property (nonatomic,strong) NSNumber *Sort;
@property (nonatomic,assign) BOOL IsAuction;
@property (nonatomic,assign) BOOL IsRecommend;
@property (nonatomic,assign) BOOL IsMarketable;
//@property (nonatomic,copy) NSString *GoodsModelCode;
@property (nonatomic,assign) BOOL isSelected;
@property (nonatomic,assign) BOOL IsVirtual;

@property (nonatomic,assign) BOOL IsOfficial;
@end

@interface WKGoodsModel : NSObject

@property (nonatomic,copy) NSNumber *GoodsCode;
// 名称
@property (nonatomic,copy) NSString *GoodsName;

// 描述
@property (nonatomic,copy) NSString *Description;

// 图片
@property (nonatomic,copy) NSArray *GoodsPicList;

// 型号
@property (nonatomic,copy) NSArray *GoodsModelList;

// 是否免邮
@property (nonatomic,assign) BOOL IsFreeShipping;

// 是否拍卖品
@property (nonatomic,assign) BOOL IsAuction;
@property (nonatomic,assign) BOOL IsRecommend;
@property (nonatomic,assign) BOOL IsMarketable;


@property (nonatomic,assign) BOOL IsDelete;


@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *CreateTime;
@property (nonatomic,copy) NSString *CreateTimeStr;
@property (nonatomic,copy) NSString *MemberCode;
@property (nonatomic,copy) NSString *MainPic;

@property (nonatomic,copy) NSString *UpdateTime;

@property (nonatomic,copy) NSString *MemberNo;
@property (nonatomic,copy) NSString *PriceMax;
@property (nonatomic,copy) NSString *PriceMin;

@property (nonatomic,copy) NSString *BPOID;
@property (nonatomic,copy) NSString *Memo;

@property (nonatomic,strong) NSArray *GoodsVirtualInfoList;

@property (nonatomic,assign) BOOL IsHidden;
@property (nonatomic,assign) BOOL IsVirtual;

@end
