//
//  WKAuctionShopModel.h
//  秀加加
//
//  Created by lin on 2016/10/9.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKAuctionShopModel : NSObject

@property (nonatomic,assign) NSInteger Status; //状态（0：无拍卖，1：拍卖中，2：流拍，3：拍卖成功））

@property (nonatomic,strong) NSString *AuctionID;

@property (nonatomic,assign) NSInteger GoodsCode;

@property (nonatomic,strong) NSString *GoodsName;

@property (nonatomic,strong) NSString *GoodsPic;

@property (nonatomic,assign) NSInteger GoodsStartPrice;

@property (nonatomic,assign) NSInteger CurrentPrice;

@property (nonatomic,strong) NSString *CurrentMemberName;

@property (nonatomic,assign) NSInteger Count;

@property (nonatomic,assign) NSInteger RemainMinute;

@property (nonatomic,strong) NSString *EndTime;


@end
