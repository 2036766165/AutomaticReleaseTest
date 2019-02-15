//
//  WKMessage.h
//  wdbo
//
//  Created by sks on 16/7/1.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKGoodsHorCollectionViewCell.h"
#import "WKInputView.h"

typedef enum : NSUInteger {
    WKMessageTypeSystem,
    WKMessageTypeUser,
    WKMessageTypeAuction,
    WKMessageTypeSystemRedBag,
    WKMessageTypeUserRedBag
} WKMessageType;
@interface WKMessage : NSObject

@property (nonatomic,assign) WKMessageType type;

@property (nonatomic,copy) NSString *eventName;

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *usericon;
@property (nonatomic,copy) NSString *content;   // 消息内容
@property (nonatomic,copy) NSString *gif;

@property (nonatomic,copy) NSString *bpoid;

@property (nonatomic,assign) CGFloat labelHeight;
@property (nonatomic,assign) CGFloat labelWidth;

@property (nonatomic,assign) CGFloat cellHeight;
@property (nonatomic,assign) CGFloat conetentWidth;
@property (nonatomic,assign) BOOL isGif;

@property (nonatomic,copy) NSString *ml;              // rate
@property (nonatomic,copy) NSString *desc;
@property (nonatomic,assign) BOOL official;
@property (nonatomic,strong) NSNumber *tp;

@property (nonatomic,copy) NSString *ID;

@property (nonatomic,copy) NSString *fromname;
@property (nonatomic,copy) NSString *fromphoto;
@property (nonatomic,copy) NSString *money;
@property (nonatomic,copy) NSString *toname;
@property (nonatomic,copy) NSString *tophoto;


@property (nonatomic,assign) WKInputType sendType;

@property (nonatomic,assign) WKGoodsLayoutType screenType;

@end
