//
//  WKAddGoodsView.h
//  秀加加
//
//  Created by sks on 2016/9/13.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKGoodsBottomView.h"

@class WKGoodsModel;

typedef void (^goodsBottomBlock)(NSString *);

@interface WKAddGoodsView : UIView

@property (nonatomic,strong) UIViewController *oberveVC;

@property (nonatomic,strong) WKGoodsModel *dataModel;

//- (instancetype)initWithFrame:(CGRect)frame with:(WKGoodsModel *)goodsModel type:(WKGoodsType)type;

- (instancetype)initWithFrame:(CGRect)frame type:(WKGoodsType)type;

@property(nonatomic, copy) goodsBottomBlock delegateBlock;

- (NSDictionary *)getGoodsInfo;

@property (strong, nonatomic) WKPromptView* promptView;

-(void)promptViewShow:(NSString *)message;

@end
