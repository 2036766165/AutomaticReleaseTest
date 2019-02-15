//
//  GiftModel.h
//  presentAnimation
//
//  Created by 许博 on 16/7/15.
//  Copyright © 2016年 许博. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "WKVirtualGiftModel.h"

@interface GiftModel : NSObject
@property (nonatomic,strong) UIImage *headImage; // 头像
@property (nonatomic,strong) UIImage *giftImage; // 礼物
@property (nonatomic,copy) NSString *name; // 送礼物者
@property (nonatomic,copy) NSString *giftName; // 礼物名称
@property (nonatomic,assign) NSInteger giftCount; // 礼物个数
@property (nonatomic,assign) WKVirtualType virtualType; // 礼物类型(打赏/拍卖)

@property (nonatomic,copy)  NSString *BPOID;  // 打赏或加价人的bpoid

@end
