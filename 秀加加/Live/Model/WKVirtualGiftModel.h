//
//  WKVirtualGiftModel.h
//  秀加加
//
//  Created by sks on 2016/10/14.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    WKVirtualTypeNormal,
    WKVirtualTypeAuction
} WKVirtualType;

@interface WKVirtualGiftModel : NSObject

@property (nonatomic,copy) NSNumber *rewardCode;
@property (nonatomic,copy) NSString *virtualName;
@property (nonatomic,copy) NSString *virtualPrice;
@property (nonatomic,copy) NSString *virtualImage;
@property (nonatomic,copy) NSString *virtualGif;

@property (nonatomic,copy) NSString *memberIcon;
@property (nonatomic,copy) NSString *memberName;

@property (nonatomic,assign) NSInteger gifCount;

@property (nonatomic,copy) NSString *bpoid;

@property (nonatomic,assign) WKVirtualType virtualType;  // 打赏种类

@property (nonatomic,assign) BOOL showGif;      // 是否显示GIF图

@end
