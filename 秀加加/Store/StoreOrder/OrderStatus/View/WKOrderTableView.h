//
//  WKOrderTableView.h
//  wdbo
//
//  Created by lin on 16/6/23.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKBaseTableView.h"
#import "WKOrderStatusModel.h"

typedef enum
{
    ClickRemove = 1,    //删除订单
    ClickCancelOrder,   //取消订单
    ClickPayOrder,      //立即支付
    ClickLookDetail,     //查看详情
    ClickLookGoods,      //查看物流
    CLickLookOrder,     //评价晒单
    ClickOffinePay,     //线下支付
    ClickFinish,
    ClickCell           //点击cell
}ClickType;

typedef enum
{
    allOrderType        = 1,    //所有订单
    notPayOrderType,            //待付款，待支付
    notSendOrderType,           //待发货
    notConfirmOrderType,        //待确认/待收货
    haveConfirmOrderType,       //已完成
    notEvaluateOrderType,       //待评价
    cancelOrderType,            //取消订单
}OrderType;

@interface WKOrderTableView : WKBaseTableView

typedef void (^ClickCallBack)(ClickType type,NSInteger section);

@property (nonatomic,copy) ClickCallBack clickCallBack;

typedef void (^ClickCellType) (ClickType type,NSIndexPath *index);

@property (nonatomic,copy) ClickCellType ClickCellType;

@property (nonatomic,assign) OrderType orderType;

@property (nonatomic,assign) NSInteger CustomType;

@property (nonatomic,assign) NSInteger OrderListType;

@property (nonatomic,assign) NSInteger Type;

@property (nonatomic,strong) UIButton *rightBtn;

@end
