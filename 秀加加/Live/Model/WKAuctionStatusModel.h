//
//  WKAuctionStatusModel.h
//  秀加加
//
//  Created by sks on 2016/10/11.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WKAddressListItem;

@interface WKAuctionStatusModel : NSObject

@property (nonatomic,assign) BOOL IsJoin;
@property (nonatomic,assign) BOOL IsConfirm;
@property (nonatomic,assign) BOOL IsStart;

@property (nonatomic,copy) NSNumber *Status; //状态（0：无拍卖，1：拍卖中，2：流拍，3：拍卖成功））

@property (nonatomic,copy) NSString *SpecialSaleID;

@property (nonatomic,copy) NSNumber *GoodsCode;

@property (nonatomic,copy) NSString *GoodsName;

@property (nonatomic,copy) NSString *GoodsPic;

@property (nonatomic,copy) NSNumber *GoodsStartPrice;

@property (nonatomic,copy) NSString *Price;
@property (nonatomic,copy) NSNumber *CurrentPrice;

@property (nonatomic,copy) NSString *CurrentMemberName;
@property (nonatomic,copy) NSString *CurrentMemberBPOID;

@property (nonatomic,copy) NSNumber *Count;

@property (nonatomic,copy) NSNumber *RemainTime;

@property (nonatomic,copy) NSString *EndTime;

@property (nonatomic,copy) NSNumber *PayRemainTime;
@property (nonatomic,copy) NSString *OrderCode;
@property (nonatomic,copy) NSString *ShopOwnerNo;
@property (nonatomic,copy) NSNumber *PayStatus;

@property (nonatomic,copy) NSString *CreateTime;

@property (nonatomic,copy) NSNumber *AddPrice;
@property (nonatomic,copy) NSString *MemberPhotoUrl;

@property (nonatomic,assign) BOOL isMostHighPrice;

@property (nonatomic,strong) WKAddressListItem *addressModel;

@property (nonatomic,copy) NSNumber *VoiceDuration;

@property (nonatomic,assign) BOOL IsVirtual;

@property (nonatomic,strong) NSNumber *SaleType;  // 1 拍卖 2 幸运购

@end

@interface WKAuctionJoinModel : NSObject

@property (nonatomic,assign) BOOL isFirst;
@property (nonatomic,strong) NSNumber *CurrentPrice;
@property (nonatomic,copy) NSString *CustomerBPOID;
@property (nonatomic,copy) NSString *CustomerName;
@property (nonatomic,copy) NSString *CustomerNo;
@property (nonatomic,strong) NSNumber *Count;
@property (nonatomic,strong) NSString *CustomerPicUrl;
@property (nonatomic,strong) NSString *Price;

@end

