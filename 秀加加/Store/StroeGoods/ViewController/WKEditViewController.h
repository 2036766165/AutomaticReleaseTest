//
//  WKEditViewController.h
//  秀加加
//
//  Created by sks on 2017/2/9.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import "ViewController.h"
#import "WKGoodsBottomView.h"

@protocol WKAddFinshDelegate <NSObject>
- (void)finshEdit;
@end

@interface WKEditViewController : ViewController

@property (nonatomic,weak) id <WKAddFinshDelegate> delegate;

- (instancetype)initWithGoodsCode:(NSNumber *)goodsCode type:(WKGoodsType)type;

@end
