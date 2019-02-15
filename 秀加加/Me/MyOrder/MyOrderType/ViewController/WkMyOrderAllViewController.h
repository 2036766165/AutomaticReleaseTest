//
//  WkMyOrderAllViewController.h
//  秀加加
//
//  Created by lin on 2016/9/22.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "ViewController.h"

@interface WkMyOrderAllViewController : ViewController

/*  1.initWithType（普通商品或者拍卖商品）
 *  2.OrderListType（接口需要的参数类型）
 *  3.OrderListType（应用本身区分是店铺还是个人）
 *
 *  type:(1:普通商品  2:拍卖商品)
 *  OrderListType：(1.全部订单   2.未付款   3.未发货   4.未收货   6.待评价)
 *  CustomType:(1.店铺    2.个人)
 */
-(instancetype)initWithType:(NSInteger)type
              OrderListType:(NSInteger)OrderListType
                 CustomType:(NSInteger)CustomType;

@end
