//
//  WKOrderDetailTableView.h
//  秀加加
//
//  Created by lin on 16/9/12.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKBaseTableView.h"
#import "WKOrderDetailModel.h"

@interface WKOrderDetailTableView : WKBaseTableView

//1.发货 2.跳转地址 3.编辑 4.修改价格 5.快递公司 6.物流单号 7.线下支付 8.删除订单
typedef void (^SendCallBack) (NSInteger type,NSInteger section);

@property (nonatomic,copy) SendCallBack sendCallBack;

@property (nonatomic,assign) NSInteger type;

@property (nonatomic,assign) NSInteger OrderListType;

@property (nonatomic,assign) NSInteger CustomType;

@property (nonatomic,strong) WKOrderDetailModel *model;

@property (strong, nonatomic) NSString * orderNumber; //订单号

@property (nonatomic,strong) NSString *expressName;//物流公司

@property (nonatomic,strong) NSString *expressNum;  //物流单号

@property (nonatomic,strong) NSString *allPrice;//footer总价

@property (nonatomic,strong) NSString *tranFeePrice;//运费

@property (nonatomic,strong) UILabel *address;

@property (nonatomic,strong) UILabel *name;

@end
