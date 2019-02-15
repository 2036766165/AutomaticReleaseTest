//
//  WKLiveShopListModel.h
//  秀加加
//
//  Created by lin on 2016/10/12.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKLiveShopListModel : NSObject

@property (nonatomic,strong) NSString *ID;

@property (nonatomic,strong) NSString *BPOID;

@property (nonatomic,strong) NSString *MemberNo;

@property (nonatomic,assign) NSInteger GoodsCode;

@property (nonatomic,strong) NSString *GoodsName;

@property (nonatomic,strong) NSString *Description;

@property (nonatomic,strong) NSString *MainPic;

@property (nonatomic,assign) NSInteger PriceMin;

@property (nonatomic,assign) NSInteger PriceMax;

@property (nonatomic,strong) NSString *Price;

@property (nonatomic,strong) NSString *TranFee;

@property (nonatomic,assign) BOOL IsDelete;

@property (nonatomic,assign) BOOL IsMarketable;

@property (nonatomic,assign) BOOL IsFreeShipping;

@property (nonatomic,assign) BOOL IsAuction;

@property (nonatomic,assign) BOOL IsVirtual;

@property (nonatomic,strong) NSArray *GoodsPicList;

@property (nonatomic,strong) NSArray *GoodsModelList;

@property (nonatomic,strong) NSString *CreateTime;//下单时间

@property (nonatomic,strong) NSString *UpdateTime;

@property (nonatomic,assign) NSInteger Stock;

@property (nonatomic,copy)   NSNumber *startCountTime;

@property (nonatomic,copy) NSNumber *GoodsStartPrice;

@property (nonatomic,copy) NSNumber *RemainTime;


@end

@interface WKLiveShopPicModelItem : NSObject

@property (nonatomic,strong) NSString *ID;

@property (nonatomic,strong) NSString *PicUrl;

@property (nonatomic,assign) NSInteger Sort;

@property (nonatomic,assign) CGFloat cellHeight;

@property (nonatomic,strong) UIImageView *imageView;
@end

@interface WKLiveShopListModelItem: NSObject

@property (nonatomic,strong) NSString *ID;

@property (nonatomic,assign) NSInteger ModelCode;

@property (nonatomic,strong) NSString *ModelName;

@property (nonatomic,assign) NSInteger Stock;

@property (nonatomic,strong) NSString *Price;

@property (nonatomic,strong) NSString *CreateTime;

@end
