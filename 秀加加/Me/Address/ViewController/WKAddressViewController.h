//
//  WKAddressViewController.h
//  秀加加
//
//  Created by lin on 16/8/30.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "ViewController.h"

@class WKAddressListItem;

@protocol WKSelectAddressDelegate <NSObject>
- (void)selectedAddress:(WKAddressListItem *)address;

@optional
- (void)leaveAddressList;

@end

typedef enum : NSUInteger {
    WKAddressFromLive,
    WKAddressFromCenter,
    WKAddressFromOrder
} WKAddressFrom;

@interface WKAddressViewController : ViewController

@property (nonatomic,weak) id<WKSelectAddressDelegate> delegate;

- (instancetype)initWithFrom:(WKAddressFrom)from;

@end
