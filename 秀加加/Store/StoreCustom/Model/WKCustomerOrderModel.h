//
//  WKCustomerOrderModel.h
//  秀加加
//
//  Created by 吴文豪 on 2016/10/13.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKCustomerOrderModel : NSObject
    //订单集合
    @property (strong, nonatomic) NSArray * InnerList;

@end

@interface WKCustomerListOrder : NSObject

    //订单编号
    @property (strong , nonatomic) NSString *OrderCode ;

    //订单类型 1.普通 2.拍卖 3.打赏 4.保证金
    @property (strong , nonatomic) NSString *OrderType ;

    //订单状态
    @property (strong , nonatomic) NSString *OrderStatus ;

    //当前订单状态描述
    @property (strong , nonatomic) NSString *CurrentOrderStatus ;

    //支付状态
    @property (strong , nonatomic) NSString *PayStatus ;

    //发货状态
    @property (strong , nonatomic) NSString *ShipStatus ;

    //商品数量
    @property (strong , nonatomic) NSString *GoodsCount ;

    //商品总金额（拍卖商品的总计）
    @property (strong , nonatomic) NSString *GoodsAmount ;

    //运费
    @property (strong , nonatomic) NSString *TranFeeAmount ;

    //支付总金额（普通商品的总计）
    @property (strong , nonatomic) NSString *PayAmount ;

    //收货人地址
    @property (strong , nonatomic) NSString *ShipAddress ;

    //收货人电话
    @property (strong , nonatomic) NSString *ShipPhone ;

    //创建时间
    @property (strong , nonatomic) NSString *CreateTime ;

    //付款时间
    @property (strong , nonatomic) NSString *PayDate ;

    //发货时间
    @property (strong , nonatomic) NSString *ShipDate ;

    //签收时间
    @property (strong , nonatomic) NSString *HasBeenDate ;

    //订单下的商品集合
    @property (strong , nonatomic) NSArray *Products ;

@end


@interface WKCustomerListProduct : NSObject

    //订单ID
    @property (strong , nonatomic) NSString *OrderID ;

    //客户昵称
    @property (strong , nonatomic) NSString *CustomerName ;

    //订单编号
    @property (strong , nonatomic) NSString *OrderCode ;

    //商品编号
    @property (strong , nonatomic) NSString *GoodsCode ;

    //商品名称
    @property (strong , nonatomic) NSString *GoodsName ;

    //商品图片
    @property (strong , nonatomic) NSString *GoodsPicUrl ;

    //商品规模名称
    @property (strong , nonatomic) NSString *GoodsModelName ;

    //商品规模编号
    @property (strong , nonatomic) NSString *GoodsModelCode ;

    //商品单价
    @property (strong , nonatomic) NSString *GoodsPrice ;

    //商品起拍价格
    @property (strong , nonatomic) NSString *GoodsStartPrice ;

    //商品数量
    @property (strong , nonatomic) NSString *GoodsNumber ;

    //商品总价格
    @property (strong , nonatomic) NSString *TotailPrice ;

    //评价状态
    @property (strong , nonatomic) NSString *CommentStatus ;

    //提交时间
    @property (strong , nonatomic) NSString *CreateTime ;

@end



