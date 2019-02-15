//
//  WkMyOrderAllViewController.m
//  秀加加
//
//  Created by lin on 2016/9/22.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WkMyOrderAllViewController.h"
#import "WKOrderTableView.h"
#import "WKOrderDetailViewController.h"
#import "UIViewController+WKTrack.h"
#import "WKMyOrderDetailAllViewController.h"
#import "WKPayView.h"
#import "WKEvaluateDetailViewController.h"
#import "NSObject+XWAdd.h"
#import "WKShowInputView.h"
#import "WKSendShopDetailViewController.h"
#import "WKPayTool.h"
#import "WKAddressModel.h"
#import "WKAddressViewController.h"
#import <objc/runtime.h>
#import "WKNavigationController.h"
#import "WKStoreRechargeViewController.h"

@interface WkMyOrderAllViewController ()<WKSelectAddressDelegate>{
    bool showloading;
}

@property (nonatomic,strong) WKOrderTableView *orderTableView;

@property (nonatomic,assign) NSInteger type;

@property (nonatomic,assign) NSInteger OrderListType;

@property (nonatomic,assign) NSInteger CustomType;

@property (nonatomic,strong) WKOrderStatusModel *model;

@property (nonatomic,strong) WKPayView *payView;

@property (nonatomic,strong) WKAddressListItem *itemAddress;

@property (nonatomic,strong) NSString *addressID;

@property (nonatomic,strong) UIViewController *addressVC;

@property (nonatomic,strong) UIButton *maskBtn;

@property (nonatomic,strong) UIViewController *currentVC;

@property (nonatomic,assign) NSInteger ordertype;

@end

@implementation WkMyOrderAllViewController



-(instancetype)initWithType:(NSInteger)type
              OrderListType:(NSInteger)OrderListType
                 CustomType:(NSInteger)CustomType
{
    if (self = [super init]) {
        _type = type;
        _OrderListType = OrderListType;
        _CustomType = CustomType;
        _ordertype = 0;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(triggerAction:) name:@"ordertypeselect" object:nil];
    }
    return self;
}

- (WKOrderTableView *)orderTableView
{
    if (!_orderTableView) {
        _orderTableView = [[WKOrderTableView alloc] initWithFrame:CGRectMake(0, 0, WKScreenW, WKScreenH-64*2)];
        _orderTableView.Type = _type;
        _orderTableView.CustomType = _CustomType;
        _orderTableView.OrderListType = _OrderListType;
    }
    return _orderTableView;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.orderTableView];
    [self initUi];
    
    [self event];
    
    [self loadAddress];
    
    [self xw_addNotificationForName:@"取消订单" block:^(NSNotification * _Nonnull notification) {
        
        [self loadData];
    }];
    
    [self xw_addNotificationForName:@"删除订单" block:^(NSNotification * _Nonnull notification) {

        [self loadData];

    }];
    
    [self xw_addNotificationForName:@"detailsPay" block:^(NSNotification * _Nonnull notification) {
        [self loadData];
        
    }];
    
    [self xw_addNotificationForName:@"BALANCE" block:^(NSNotification * _Nonnull notification) {
        
        [WKShowInputView showInputWithPlaceString:@"当前余额不足,是否去充值" type:LABELTYPE andBlock:^(NSString *str) {
            self.payView.hidden = YES;
            [self xw_postNotificationWithName:@"payViewHidden" userInfo:nil];
            WKStoreRechargeViewController *rechargeVC = [[WKStoreRechargeViewController alloc] init];
            UIViewController *vc = [self viewControllerWith:self.view];
            [vc.navigationController pushViewController:rechargeVC animated:YES];
        }];
        
    }];
}

-(void) triggerAction:(NSNotification *) notification
{
    NSDictionary *dict = notification.userInfo;
    NSIndexPath* index = (NSIndexPath*)dict[@"index"];
    _ordertype = index.row;
    if(_ordertype == 3){
        _ordertype = 6;
    }
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)initUi
{
    
}

-(void)loadData
{
    [self loadData:self.OrderListType];
}

-(void)loadData:(NSInteger)orderListType
{
    showloading = true;
    NSDictionary *param = @{@"PageIndex":@(self.orderTableView.pageNO),
                            @"PageSize":@(self.orderTableView.pageSize),
                            @"OrderListType":@(orderListType),
                            @"OrderType":@(_ordertype)};
    
    NSLog(@"%ld",(long)self.OrderListType);
    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if(showloading == true){
            [WKProgressHUD showLoadingText:@"Loading..."];
        }
    });
    [WKHttpRequest myOrder:HttpRequestMethodPost url:WKMyOrder model:NSStringFromClass([WKOrderStatusModel class]) param:param success:^(WKBaseResponse *response) {
        showloading = false;
        NSLog(@"%@",response.json);
        
        WKOrderStatusModel *model = response.Data;
        
        self.model = model;
        
        if(self.orderTableView.dataArray.count <= 0)
        {
            if(self.OrderListType == 1)
            {
                [self.orderTableView setRemindreImageName:@"person01" text:@"您还没有相关订单" completion:^{
                    
                }];
            }
            else if(self.OrderListType == 2)
            {
                [self.orderTableView setRemindreImageName:@"person02" text:@"您还没有相关订单" completion:^{
                    
                }];
            }
            else if(self.OrderListType == 3)
            {
                [self.orderTableView setRemindreImageName:@"person03" text:@"您还没有相关订单" completion:^{
                    
                }];
            }
            else if(self.OrderListType == 4)
            {
                [self.orderTableView setRemindreImageName:@"person04" text:@"您还没有相关订单" completion:^{
                    
                }];
            }
            else if(self.OrderListType == 6)
            {
                [self.orderTableView setRemindreImageName:@"person05" text:@"您还没有相关订单" completion:^{
                    
                }];
            }
        }
        [self.orderTableView reloadDataWithArray:model.InnerList];
        
    } failure:^(WKBaseResponse *response) {
       showloading = false;
//        [WKProgressHUD showText:response.ResultMessage];
        [self.orderTableView setRemindreImageName:@"notHaveBig" text:@"您还没有相关订单" completion:^{
            
        }];
    }];
}


-(void)event
{
    WeakSelf(WkMyOrderAllViewController);
    self.orderTableView.requestBlock = ^(){
        [weakSelf loadData];
    };
    
    self.orderTableView.clickCallBack = ^(ClickType type,NSInteger section){
        
        if(type == ClickRemove)//删除订单
        {
            [WKShowInputView showInputWithPlaceString:@"是否确认删除订单?" type:LABELTYPE andBlock:^(NSString * Count) {
                
                [weakSelf removeOrder:section];
                
            }];
        }
        else if(type == ClickCancelOrder)//取消订单
        {
            [WKShowInputView showInputWithPlaceString:@"是否确认取消订单?" type:LABELTYPE andBlock:^(NSString * Count) {
                
                [weakSelf cancelOrder:section];
                
            }];
        }
        else if(type == ClickFinish)//确认收货
        {
            [WKShowInputView showInputWithPlaceString:@"您是否确认已经收到了商品或服务?" type:LABELTYPE andBlock:^(NSString * Count) {
                
                [weakSelf finishOrder:section];
                
            }];
        }
        else if(type == ClickPayOrder) //立即支付
        {
            [weakSelf payView:section orderType:weakSelf.type];
            
            [weakSelf.orderTableView reloadData];
        }
        else if(type == ClickLookDetail)//查看详情
        {
            NSLog(@"查看详情");
            WKOrderStatusItemModel *model = weakSelf.orderTableView.dataArray[section];
            WKMyOrderDetailAllViewController *orderDetailVc = [[WKMyOrderDetailAllViewController alloc] initWithType:model.OrderType OrderListType:weakSelf.OrderListType];
            orderDetailVc.model = model;
            UIViewController *vc = [weakSelf viewControllerWith:weakSelf.view];
            [vc.navigationController pushViewController:orderDetailVc animated:YES];
        }
        else if(type == ClickLookGoods)//查看物流
        {
            NSString *contentStr = ((WKOrderStatusItemModel*)weakSelf.orderTableView.dataArray[section]).ExpressDetail;
            if([contentStr isEqualToString:@""])
            {
                [WKPromptView showPromptView:@"暂无物流信息"];
            }
            else
            {
                WKSendShopDetailViewController *sendShopDetailVC = [[WKSendShopDetailViewController alloc] init];
                sendShopDetailVC.orderType = [NSString stringWithFormat:@"%lu",(long)((WKOrderStatusItemModel*)(weakSelf.model.InnerList[section])).ShipStatus];;
                sendShopDetailVC.orderCode = ((WKOrderStatusItemModel*)(weakSelf.model.InnerList[section])).OrderCode;
                sendShopDetailVC.orderNum = ((WKOrderStatusItemModel*)(weakSelf.model.InnerList[section])).ExpressCode;
                sendShopDetailVC.companyName = ((WKOrderStatusItemModel*)(weakSelf.model.InnerList[section])).ExpressCompanyName;
                UIViewController *vc = [weakSelf viewControllerWith:weakSelf.view];
                [vc.navigationController pushViewController:sendShopDetailVC animated:YES];
            }
        }
        else if(type == CLickLookOrder)//评价晒单
        {
            //weakSelf.orderTableView.dataArray[section];
            WKOrderStatusItemModel *model1 = weakSelf.orderTableView.dataArray[section];//weakSelf.model.InnerList[section];
            
            
            WKOrderProduct *model2 = (WKOrderProduct*)model1.Products[0];
            
            NSLog(@"%ld",(long)model1.CommentStatus);
            NSLog(@"%ld",(long)model2.CommentStatus);
            
            WKEvaluateTableModel *evaluateModel =[WKEvaluateTableModel new];
            evaluateModel.GoodsCode = @(model2.GoodsCode).stringValue;
            evaluateModel.OrderCode = model2.OrderCode;
            evaluateModel.GoodsModelCode = model2.GoodsModelCode;
            evaluateModel.GoodsPicUrl = model2.GoodsPicUrl;
            evaluateModel.GoodsName = model2.GoodsName;
            evaluateModel.GoodsStartPrice = model2.GoodsStartPrice;
            evaluateModel.GoodsNumber = model2.GoodsNumber;
            evaluateModel.GoodsModelName = model2.GoodsModelName;
            evaluateModel.GoodsPrice = model2.GoodsPrice;
            evaluateModel.type = weakSelf.ordertype;
            evaluateModel.IsVirtual = model2.IsVirtual;
            
            WKEvaluateDetailViewController *evaVC = [[WKEvaluateDetailViewController alloc] init];
            evaVC.model = evaluateModel;
            UIViewController *vc = [weakSelf viewControllerWith:weakSelf.view];
            [vc.navigationController pushViewController:evaVC animated:YES];
            [weakSelf xw_addNotificationForName:@"commitSuccess" block:^(NSNotification * _Nonnull notification) {
                [weakSelf loadData];
            }];
//            if(model1.CommentStatus == 1)//以评论
//            {
//                weakSelf.orderTableView.rightBtn.hidden = YES;
//            }
//            else
//            {
//                WKEvaluateDetailViewController *evaVC = [[WKEvaluateDetailViewController alloc] init];
//                evaVC.model = (WKEvaluateTableModel*)model2;
//                UIViewController *vc = [weakSelf viewControllerWith:weakSelf.view];
//                [vc.navigationController pushViewController:evaVC animated:YES];
//            }
        }
        else if(type == ClickCell)
        {
            WKOrderStatusItemModel *model = weakSelf.orderTableView.dataArray[section];

            NSDictionary *dict = @{
                                   @"待付款":@(notPayOrderType),
                                   @"待发货":@(notSendOrderType),
                                   @"待收货":@(notConfirmOrderType),
                                   @"交易成功":@(notEvaluateOrderType)
                                   };
            
            NSNumber *type = dict[model.CurrentOrderStatus];

            WKMyOrderDetailAllViewController *orderDetailVc = [[WKMyOrderDetailAllViewController alloc] initWithType:model.OrderType OrderListType:type.integerValue];
            orderDetailVc.model = model;
            UIViewController *vc = [weakSelf viewControllerWith:weakSelf.view];
            [vc.navigationController pushViewController:orderDetailVc animated:YES];

        }
    };
}

//个人订单删除
-(void)removeOrder:(NSInteger)section
{
    WKOrderStatusItemModel *model = self.orderTableView.dataArray[section];
    NSString *url = [NSString configUrl:WKPersonOrderRemove With:@[@"orderCode"] values:@[[NSString stringWithFormat:@"%@",model.OrderCode]]];
    
    NSLog(@"%@",url);
    
    [WKHttpRequest personOrderRemove:HttpRequestMethodGet url:url model:nil param:@{} success:^(WKBaseResponse *response) {
        [WKPromptView showPromptView:@"删除订单成功！"];
        [self loadData];
        
    } failure:^(WKBaseResponse *response) {
//        [WKProgressHUD showText:response.ResultMessage];
    }];
}

-(void)finishOrder:(NSInteger)section
{
    WKOrderStatusItemModel *model = self.orderTableView.dataArray[section];
    NSString *url = [NSString configUrl:@"Order/ConfirmReceive" With:@[@"orderCode"] values:@[[NSString stringWithFormat:@"%@",model.OrderCode]]];
    
    NSLog(@"%@",url);
    
    [WKHttpRequest personOrderRemove:HttpRequestMethodPost url:url model:nil param:@{} success:^(WKBaseResponse *response) {
        [WKPromptView showPromptView:@"确认收货成功！"];
        [self loadData];
        
    } failure:^(WKBaseResponse *response) {
        [WKProgressHUD showTopMessage:response.ResultMessage];
    }];
}

//个人取消订单
-(void)cancelOrder:(NSInteger)section
{
    WKOrderStatusItemModel *model = self.orderTableView.dataArray[section];
    NSString *url = [NSString configUrl:WKPersonOrderCancel With:@[@"orderCode"] values:@[[NSString stringWithFormat:@"%@",model.OrderCode]]];
    
    [WKHttpRequest personOrderCancel:HttpRequestMethodGet url:url model:nil param:@{} success:^(WKBaseResponse *response) {
        [WKPromptView showPromptView:@"取消订单成功！"];
        [self loadData];
        
    } failure:^(WKBaseResponse *response) {
        
        [WKProgressHUD showTopMessage:response.ResultMessage];
        
    }];
}

-(void)payView:(NSInteger)section orderType:(NSInteger)orderType
{
    NSString *orderCode = ((WKOrderStatusItemModel*)self.model.InnerList[section]).OrderCode;
    NSString *money = ((WKOrderStatusItemModel*)self.model.InnerList[section]).PayAmount;
    
    //落槌价
    NSString *dropMoney = ((WKOrderProduct*)(((WKOrderStatusItemModel*)self.model.InnerList[section]).Products[0])).GoodsPrice;
    //起拍价==保证金
    NSString *marginMoney = ((WKOrderProduct*)(((WKOrderStatusItemModel*)self.model.InnerList[section]).Products[0])).GoodsStartPrice;
    
    if(orderType == 1)
    {
        WKPayView *payView = [[WKPayView alloc] initWithFrame:CGRectMake(0, 0, WKScreenW, WKScreenH) type:1 direction:0];
        self.payView = payView;
        payView.money.text = [NSString stringWithFormat:@"商品价格:  ￥%.2f",[money floatValue]];
        payView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [[UIApplication sharedApplication].keyWindow addSubview:payView];

        payView.payTypeCallBlock = ^(NSInteger type){
            if(type == 1)
            {
                NSLog(@"微信支付");
                [self payData:orderCode PayType:2 orderType:orderType addressId:@""];
            }
            else if(type == 2)
            {
                NSLog(@"支付宝支付");
                [self payData:orderCode PayType:4 orderType:orderType addressId:@""];
            }else if (type == 5){
                // 余额支付
                [self payData:orderCode PayType:WKPayOfTypeBalance orderType:orderType addressId:@""];

            }
        };
    }
    else if(orderType == 2)
    {
        WKPayView *payView = [[WKPayView alloc] initWithFrame:CGRectMake(0, 0, WKScreenW, WKScreenH) type:2 direction:1];
        payView.dropValue.text = [NSString stringWithFormat:@"￥%.2f",[dropMoney floatValue]];//落槌价
        payView.marginValue.text = [NSString stringWithFormat:@"￥%.2f",[marginMoney floatValue]];//保证金
//        payView.payValue.hidden = NO;
        payView.payValue.text = [NSString stringWithFormat:@"￥%.2f",[money floatValue]];//还需要交的钱;

        self.payView = payView;
        if(!self.itemAddress)//缺少地址跳转
        {
            payView.name.hidden = YES;
            payView.defaultBtn.hidden = YES;
            payView.address.text = @"您还没有添加地址,请添加地址";
        }
        else
        {
            if(self.itemAddress.IsDefault)
            {
                payView.defaultBtn.hidden = NO;
            }
            else
            {
                payView.defaultBtn.hidden = YES;
            }
            
            payView.name.text = [NSString stringWithFormat:@"%@  %@",self.itemAddress.Contact,self.itemAddress.Phone];
            
            CGSize nameSize = [payView.name.text sizeOfStringWithFont:[UIFont systemFontOfSize:14] withMaxSize:CGSizeMake(MAXFLOAT, 20)];
            
            payView.address.text = [NSString stringWithFormat:@"%@%@%@%@",self.itemAddress.ProvinceName,self.itemAddress.CityName,self.itemAddress.CountyName,self.itemAddress.Address];
            
            [payView.name mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(nameSize.width, 20));
            }];
        }
        payView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [[UIApplication sharedApplication].keyWindow addSubview:payView];
        
        
        payView.payTypeCallBlock = ^(NSInteger type){
            if(type == 1)
            {
                if(!self.itemAddress)//没有地址(给出提示信息)
                {
                    [WKPromptView showPromptView:@"请选择收货地址"];
                }
                else
                {
                    if(self.itemAddress.ID.length > 0)
                    {
                        [self payData:orderCode PayType:2 orderType:orderType addressId:self.itemAddress.ID];
                    }
                    else
                    {
                        [self payData:orderCode PayType:2 orderType:orderType addressId:self.addressID];
                    }
                }
            }
            else if(type == 2)
            {
                if(!self.itemAddress)//没有地址(给出提示信息)
                {
                    [WKPromptView showPromptView:@"请选择收货地址"];
                }
                else
                {
                    if(self.itemAddress.ID.length > 0)
                    {
                        [self payData:orderCode PayType:4 orderType:orderType addressId:self.itemAddress.ID];
                    }
                    else
                    {
                        [self payData:orderCode PayType:4 orderType:orderType addressId:self.addressID];
                    }
                }
            }else if (type == 5){
                if(!self.itemAddress)//没有地址(给出提示信息)
                {
                    [WKPromptView showPromptView:@"请选择收货地址"];
                }
                else
                {
                    if(self.itemAddress.ID.length > 0)
                    {
                        [self payData:orderCode PayType:WKPayOfTypeBalance orderType:orderType addressId:self.itemAddress.ID];
                    }
                    else
                    {
                        [self payData:orderCode PayType:WKPayOfTypeBalance orderType:orderType addressId:self.addressID];
                    }
                }
            }
            else if(type == 4)//地址跳转
            {
                UIButton *maskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [maskBtn addTarget:self action:@selector(dismissAddress:) forControlEvents:UIControlEventTouchUpInside];
                maskBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
                UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
                maskBtn.frame = keyWindow.bounds;
                [keyWindow addSubview:maskBtn];
                self.maskBtn = maskBtn;
                
                WKAddressViewController *address = [[WKAddressViewController alloc] initWithFrom:WKAddressFromLive];
                address.delegate = self;
                WKNavigationController *nav = [[WKNavigationController alloc] initWithRootViewController:address];
                
                nav.view.frame = CGRectMake(0, WKScreenH - (44 * 10), WKScreenW, 44 * 10);
                
                //[self addChildViewController:nav];
                [keyWindow addSubview:nav.view];
                
                self.currentVC = nav;
                
                self.payView.hidden = true;

                }
        };
    }
}


- (void)leaveAddressList{
    [self dismissAddress:self.maskBtn];
}



//选择地址
- (void)selectedAddress:(WKAddressListItem *)address
{
    self.itemAddress = address;
    self.addressID = address.ID;
    
    self.payView.name.text = [NSString stringWithFormat:@"%@  %@",address.Contact,address.Phone];
    self.payView.address.text = [NSString stringWithFormat:@"%@%@%@%@",address.ProvinceName,address.CityName,address.CountyName,address.Address];
    
    if(address.IsDefault)
    {
        self.payView.defaultBtn.hidden = NO;
    }
    else
    {
        self.payView.defaultBtn.hidden = YES;
    }
    self.payView.hidden = NO;
    [self dismissAddress:self.maskBtn];
}

- (void)dismissAddress:(UIButton *)btn{
    
    [self.currentVC willMoveToParentViewController:nil];
    [self.currentVC.view removeFromSuperview];
    
    [self.currentVC removeFromParentViewController];
    
    [btn removeFromSuperview];
    
    self.currentVC = self;
    self.payView.hidden = NO;
    
}

-(void)payData:(NSString *)orderCode
       PayType:(NSInteger)PayType
     orderType:(NSInteger)orderType
     addressId:(NSString *)addressId
{
    self.addressID = addressId;
    NSDictionary *param = @{@"OrderCode":orderCode,
                            @"PayType":@(PayType),
                            @"OrderType":@(orderType),
                            @"AddressID":self.addressID};
    
    NSLog(@"%@",param);
    
    [[WKPayTool shareInstance] payWith:param type:PayType completionBlock:^(id obj) {
        
        WKPayResult *payResult = obj;
        if(payResult.resultType == WKPayResultTypeSuccess)
        {
            [self.payView removeFromSuperview];
            [[UIApplication sharedApplication].keyWindow removeFromSuperview];
            
            [self loadData];

        }
    }];
}


-(void)loadAllData:(NSInteger)type
{
    NSDictionary *param = @{@"PageIndex":@(self.orderTableView.pageNO),
                            @"PageSize":@(self.orderTableView.pageSize),
                            @"OrderListType":@(type),
                            @"OrderType":@(self.type)};
    
    NSLog(@"-------------------%@",param);
    
    [WKProgressHUD showLoadingText:@""];
    
    [WKHttpRequest myOrder:HttpRequestMethodPost url:WKMyOrder model:NSStringFromClass([WKOrderStatusModel class]) param:param success:^(WKBaseResponse *response) {
        
        NSLog(@"%@",response.json);
        
        WKOrderStatusModel *model = response.Data;
        
        self.model = model;
        
        if(self.orderTableView.dataArray.count <= 0)
        {
            [self.orderTableView setRemindreImageName:@"notHaveBig" text:@"您还没有相关订单" completion:^{
                
            }];
        }
        [self.orderTableView reloadDataWithArray:model.InnerList];
        
    } failure:^(WKBaseResponse *response) {
        [WKProgressHUD showTopMessage:response.ResultMessage];
        
        [self.orderTableView setRemindreImageName:@"notHaveBig" text:@"您还没有相关订单" completion:^{
            
        }];
    }];
}

- (void)loadAddress{
    
    [WKHttpRequest  getAddress:HttpRequestMethodGet url:WKAddresssList model:NSStringFromClass([WKAddressListModel class]) param:@{} success:^(WKBaseResponse *response) {
        WKAddressListModel *md = response.Data;
        
        if(md.InnerList.count > 0)
        {
            self.itemAddress = (WKAddressListItem*)md.InnerList[0];
        }
        
    } failure:^(WKBaseResponse *response) {
        
    }];
}


@end
