//
//  WKCustomDetailsView.h
//  秀加加
//
//  Created by Chang_Mac on 16/10/10.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKBaseTableView.h"
#import "WKCustomerOrderModel.h"
#import "WKCustomTableModel.h"

@interface WKCustomDetailsView : WKBaseTableView

    //用户的订单集合
    @property (nonatomic , strong) WKCustomerOrderModel *CustomerOrderModel;

    //订单表数据
    @property (nonatomic , strong) WKCustomerListOrder *orderModel;

    //商品表数据
    @property (nonatomic , strong) WKCustomerListProduct *productModel;

    //客户信息
    @property (nonatomic, strong) CustomInnerList *customModel;

    //页面刷新Block
    @property (copy, nonatomic) void(^headBlock) ();

    @property (copy, nonatomic) void(^footBlock) ();

@end

