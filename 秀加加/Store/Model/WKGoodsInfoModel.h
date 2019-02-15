//
//  WKGoodsInfoModel.h
//  秀加加
//
//  Created by lin on 2016/10/17.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKGoodsInfoModel : NSObject

@property (nonatomic,strong) NSString *ID;

@property (nonatomic,strong) NSString *BPOID;

@property (nonatomic,strong) NSString *MemberNo;

@property (nonatomic,strong) NSString *GoodsName;

@property (nonatomic,assign) NSInteger GoodsCode;

@property (nonatomic,strong) NSString *Description;

@property (nonatomic,strong) NSString *Tag;

@property (nonatomic,assign) NSInteger SaleCount;

@property (nonatomic,assign) NSInteger Stock;

@property (nonatomic,strong) NSString *PicUrl;

@property (nonatomic,strong) NSString *Price;

@property (nonatomic,assign) BOOL IsAuction;

@property (nonatomic,assign) BOOL IsRecommend;

@property (nonatomic,assign) BOOL IsMarketable;

@property (nonatomic,strong) NSString *CreateTime;

@property (nonatomic,strong) NSString *UpdateTime;

@end
