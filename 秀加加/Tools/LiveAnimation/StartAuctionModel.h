//
//  StartAuctionModel.h
//  Animation
//
//  Created by Chang_Mac on 17/2/21.
//  Copyright © 2017年 Chang_Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+Size.h"
typedef enum {
    auctionType,
    luckBuyType,
}saleType;
#define WKScreenW [UIScreen mainScreen].bounds.size.width
#define WKScreenH [UIScreen mainScreen].bounds.size.height
@interface StartAuctionModel : NSObject

@property (strong, nonatomic) NSString * goodsPic;
@property (strong, nonatomic) NSString * goodsName;
@property (strong, nonatomic) NSString * goodsPrice;
@property (strong, nonatomic) NSString * auctionTime;//拍卖时长
@property (strong, nonatomic) NSString * memberName;//拍卖成功客户信息
@property (strong, nonatomic) NSString * memberPic;//拍卖成功客户头像
@property (strong, nonatomic) NSArray * memberArr;//幸运购用户数组
@property (assign, nonatomic) BOOL voice;

@end
