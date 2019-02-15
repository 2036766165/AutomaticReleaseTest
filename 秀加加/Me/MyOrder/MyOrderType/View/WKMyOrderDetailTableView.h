//
//  WKMyOrderDetailTableView.h
//  秀加加
//
//  Created by lin on 2016/9/28.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKBaseTableView.h"
#import "WKOrderDetailModel.h"

@interface WKMyOrderDetailTableView : WKBaseTableView

typedef enum
{
    allOrderType        = 1,    //所有订单
    notPayOrderType,            //待付款
    notSendOrderType,           //待发货
    notConfirmOrderType,        //待收货
    haveConfirmOrderType,       //已完成
    notEvaluateOrderType        //待评价
}OrderType;

@property (nonatomic,assign) NSInteger OrderListType;

@property (nonatomic,assign) NSInteger type;

@property (nonatomic,strong) WKOrderDetailModel *model;


//1.关注店主并且联系店主 2.删除订单 3.评价晒单 4.立即支付 5.取消订单 6.提醒发货 7.联系店主 8.物流 9.弹出提示信息
//10.播放语音
typedef void (^AttentionBack) (NSInteger type);

@property (nonatomic,copy) AttentionBack attentionBack;


typedef void (^PlayAudio) ();

@property (nonatomic,copy) PlayAudio playAudio;

@end
