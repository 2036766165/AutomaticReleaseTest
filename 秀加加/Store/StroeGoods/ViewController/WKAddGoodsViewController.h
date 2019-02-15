//
//  WKAddGoodsViewController.h
//  秀加加
//
//  Created by sks on 2016/9/13.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "ViewController.h"
#import "WKGoodsBottomView.h"


@interface WKAddGoodsViewController : ViewController

@property (nonatomic,copy) void(^finshedBlock)();
/*
 * goodsCode 为 0 时添加商品
 */
- (instancetype)initWithGoodsCode:(NSNumber *)goodsCode type:(WKGoodsType)type;

@end
