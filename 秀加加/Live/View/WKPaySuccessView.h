//
//  WKPaySuccessView.h
//  秀加加
//
//  Created by lin on 2016/10/31.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKPayTool.h"

@interface WKOrederItem : NSObject

@property (nonatomic,copy) NSString *orderTime;
@property (nonatomic,copy) NSString *orderNo;
@property (nonatomic,copy) NSNumber *orderAmount;
@property (nonatomic,assign) WKOrderType orderType;
@property (nonatomic,assign) BOOL payResult;

@end

@interface WKPaySuccessView : UIView

//1.竖屏  横屏
- (instancetype)initWithFrame:(CGRect)frame orderItem:(WKOrederItem *)item;

////下单时间
//@property (nonatomic,strong) UILabel *orderTime;
//
////订单号
//@property (nonatomic,strong) UILabel *orderNum;
//
////支付金额
//@property (nonatomic,strong) UILabel *payValue;

- (void)show;

@end
