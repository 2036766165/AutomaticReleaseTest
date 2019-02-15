//
//  WKMyOrderDetailAllViewController.m
//  秀加加
//
//  Created by lin on 2016/9/28.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKMyOrderDetailAllViewController.h"
#import "WKMyOrderDetailTableView.h"
#import "WKOrderDetailModel.h"
#import "WKEvaluateDetailViewController.h"
#import "WKMessageTalkViewController.h"
#import "WKPayView.h"
#import "NSObject+XWAdd.h"
#import "WKShowInputView.h"
#import "WKSendShopDetailViewController.h"
#import "WKPayTool.h"
#import "UIViewController+WKTrack.h"
#import "WKPlayTool.h"
#import "PlayerManager.h"
#import "WKAddressViewController.h"
#import "WKAddressModel.h"
#import "WKNavigationController.h"
#import "WKStoreRechargeViewController.h"

@interface WKMyOrderDetailAllViewController ()<PlayingDelegate,WKSelectAddressDelegate>

@property (nonatomic,strong) WKMyOrderDetailTableView  *myOrderDetailTableView;

@property (nonatomic,strong) WKOrderDetailModel *dataModel;

@property (nonatomic,assign) NSInteger type;

@property (nonatomic,assign) NSInteger OrderListType;

@property (nonatomic,strong) WKPayView *payView;

@property (nonatomic,strong) WKAddressListItem *itemAddress;

@property (nonatomic,strong) NSString *addressID;

@property (nonatomic,strong) UIButton *maskBtn;

@property (nonatomic,strong) UIViewController *currentVC;


@end

@implementation WKMyOrderDetailAllViewController

-(instancetype)initWithType:(NSInteger)type OrderListType:(NSInteger)OrderListType
{
    if (self = [super init]) {
        _type = type;
        _OrderListType = OrderListType;
    }
    return self;
}

- (WKMyOrderDetailTableView *)myOrderDetailTableView
{
    if (!_myOrderDetailTableView) {
        _myOrderDetailTableView = [[WKMyOrderDetailTableView alloc] initWithFrame:CGRectMake(0, 32, WKScreenW, WKScreenH-32)];
        _myOrderDetailTableView.type = _type;
        _myOrderDetailTableView.OrderListType = _OrderListType;
    }
    return _myOrderDetailTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initUi];
    
    [self event];
    
    [self loadData:_model.OrderCode];
    
    [self loadAddress];
    
    [self xw_addNotificationForName:@"commitSuccess" block:^(NSNotification * _Nonnull notification) {
        [self loadData:_model.OrderCode];
        
    }];
    
    [self xw_addNotificationForName:@"payViewHidden" block:^(NSNotification * _Nonnull notification) {
        _payView.hidden = YES;
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)initUi
{
    self.title = @"订单详情";
}

-(void)event
{
    WeakSelf(WKMyOrderDetailAllViewController);
    self.myOrderDetailTableView.attentionBack = ^(NSInteger type){
        ////1.关注店主 2.删除订单 3.评价晒单 4.立即支付 5.取消订单 6.提醒发货 7.联系店主
        if(type == 1)//关注店主并且联系店主
        {
            //ShopOwnerBPOID
            NSString *name = weakSelf.dataModel.ShopOwnerBPOID;
            [weakSelf attentionShoper:name];
        }
        else if(type == 2) //删除订单
        {
            [WKShowInputView showInputWithPlaceString:@"是否确认删除订单?" type:LABELTYPE andBlock:^(NSString * Count) {
                [weakSelf removeOrder:weakSelf.model.OrderCode];
                
            }];
         }
        else if(type == 3)//评价晒单(跳转页面)
        {
            WKOrderProduct *model2 = weakSelf.dataModel.Products[0];
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
            evaluateModel.type = weakSelf.OrderListType;
            evaluateModel.IsVirtual = model2.IsVirtual;
            
            WKEvaluateDetailViewController *EvaluateDetailVc = [[WKEvaluateDetailViewController alloc] init];
            EvaluateDetailVc.model = evaluateModel;
            [weakSelf.navigationController pushViewController:EvaluateDetailVc animated:YES];
        }
        else if(type == 4)//立即支付(弹出页面)
        {
            [weakSelf payView:weakSelf.type];
        }
        else if(type == 5)//取消订单
        {
            [WKShowInputView showInputWithPlaceString:@"是否确认取消订单?" type:LABELTYPE andBlock:^(NSString * Count) {
                
                [weakSelf cancelOrder:weakSelf.model.OrderCode];
                
            }];
        }
        else if(type == 6)//提醒发货(?)
        {
            
        }
        else if(type == 7)//联系店主(跳转到相应的聊天界面)
        {
            [weakSelf judgeContact];
        }
        else if(type == 8)//物流
        {
            WKSendShopDetailViewController *sendShopDetailVC = [[WKSendShopDetailViewController alloc] init];
            sendShopDetailVC.orderCode = weakSelf.dataModel.OrderCode;
            sendShopDetailVC.companyName = weakSelf.dataModel.ExpressCompanyName;
            sendShopDetailVC.orderNum = weakSelf.dataModel.ExpressCode;
            //传入物流状态值，统一在物流页面进行判断状态显示
            sendShopDetailVC.orderType = [NSString stringWithFormat:@"%lu",(long)weakSelf.dataModel.ShipStatus];
//            if([weakSelf.dataModel.CurrentOrderStatus isEqualToString:@"待收货"])
//            {
//                sendShopDetailVC.orderType = @"已发货";
//            }
//            else if([weakSelf.dataModel.CurrentOrderStatus isEqualToString:@"交易成功"])
//            {
//                sendShopDetailVC.orderType = @"已签收";
//            }
            
            [weakSelf.navigationController pushViewController:sendShopDetailVC animated:YES];
        }
        else if(type == 9)//提示信息
        {
            [WKPromptView showPromptView:@"暂无物流信息"];
        }
    };
    
    self.myOrderDetailTableView.playAudio = ^()
    {
        NSString *audioStr = ((WKOrderProducts*)weakSelf.dataModel.Products[0]).GoodsPicUrl;
        if([audioStr isEqualToString:@""])
        {
            
        }
        else
        {
            
        }
    };
}

-(void)judgeContact{
    NSString *url = [NSString configUrl:WKMemberCheckStar With:@[@"BPOID"] values:@[self.dataModel.ShopOwnerBPOID]];
    [WKHttpRequest checkStarStatus:HttpRequestMethodPost url:url param:nil success:^(WKBaseResponse *response) {
        if ([response.Data boolValue]) {
            [self sendMessage];
        }else{
            [self focusOwner];
        }
    } failure:^(WKBaseResponse *response) {
        
    }];
}
-(void)focusOwner{
    NSString *url = [NSString configUrl:WKFollow With:@[@"SetType",@"FollowBPOID"] values:@[@"1",self.dataModel.ShopOwnerBPOID]];
    
    [WKHttpRequest getFollowAndNot:HttpRequestMethodPost url:url model:nil param:nil success:^(WKBaseResponse *response) {
        [self sendMessage];
    } failure:^(WKBaseResponse *response) {
        [WKProgressHUD showTopMessage:response.ResultMessage];
    }];
}
-(void)sendMessage{
    WKMessageTalkViewController *messageTalkVc = [[WKMessageTalkViewController alloc] init];
    messageTalkVc.conversationType = ConversationType_PRIVATE;
    messageTalkVc.title = self.dataModel.ShopOwnerName;
    messageTalkVc.targetId = self.dataModel.ShopOwnerBPOID;
    [self.navigationController pushViewController:messageTalkVc animated:YES];
}
- (void)playingStoped
{
//    [[PlayerManager sharedManager] stopPlaying];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[PlayerManager sharedManager] stopPlaying];
}

-(void)loadData:(NSString *)orderCode
{
    NSString *url = [NSString configUrl:WKMyOrderDetail With:@[@"orderCode"] values:@[[NSString stringWithFormat:@"%@",_model.OrderCode]]];
    
    [WKProgressHUD showLoadingText:@""];
    
    [WKHttpRequest myOrderDetail:HttpRequestMethodGet url:url model:@"WKOrderDetailModel" param:nil success:^(WKBaseResponse *response) {
        
        NSLog(@"%@",response.json);
        
        self.dataModel = response.Data;
        
        NSLog(@"------%ld",(long)self.dataModel.RemainTime);
        
        [self.view addSubview:self.myOrderDetailTableView];
        
        self.myOrderDetailTableView.model = self.dataModel;
        
        [self.myOrderDetailTableView reloadDataWithArray:self.dataModel.Products];
        
    } failure:^(WKBaseResponse *response) {
        [WKProgressHUD showTopMessage:response.ResultMessage];
    }];
}

//个人订单删除
-(void)removeOrder:(NSString *)orderCode
{
    NSString *url = [NSString configUrl:WKPersonOrderRemove With:@[@"orderCode"] values:@[[NSString stringWithFormat:@"%@",orderCode]]];
    
    NSLog(@"%@",url);
    
    [WKHttpRequest personOrderRemove:HttpRequestMethodGet url:url model:nil param:@{} success:^(WKBaseResponse *response) {
        
         [self xw_postNotificationWithName:@"删除订单" userInfo:nil];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(WKBaseResponse *response) {
        [WKProgressHUD showTopMessage:response.ResultMessage];
    }];
}

//个人取消订单
-(void)cancelOrder:(NSString *)orderCode
{
    NSString *url = [NSString configUrl:WKPersonOrderCancel With:@[@"orderCode"] values:@[[NSString stringWithFormat:@"%@",orderCode]]];
    
    NSLog(@"%@",url);
    
    [WKHttpRequest personOrderCancel:HttpRequestMethodGet url:url model:nil param:@{} success:^(WKBaseResponse *response) {
        
        [self xw_postNotificationWithName:@"取消订单" userInfo:nil];
        
        [self.navigationController popViewControllerAnimated:YES];
        
        
    } failure:^(WKBaseResponse *response) {
        [WKProgressHUD showTopMessage:response.ResultMessage];
    }];
}

//关注店主
-(void)attentionShoper:(NSString *)followName
{
    NSString *url = [NSString configUrl:WKFollow With:@[@"SetType",@"FollowBPOID"] values:@[@"1",followName]];
    
    NSLog(@"%@",url);
    
    [WKHttpRequest getFollowAndNot:HttpRequestMethodPost url:url model:nil param:nil success:^(WKBaseResponse *response) {
        
        WKMessageTalkViewController *messageTalkVc = [[WKMessageTalkViewController alloc] init];
        messageTalkVc.title = self.dataModel.ShopOwnerName;
        messageTalkVc.targetId = self.dataModel.ShopOwnerBPOID;
        [self.navigationController pushViewController:messageTalkVc animated:YES];
        
    } failure:^(WKBaseResponse *response) {
        
        [WKProgressHUD showTopMessage:response.ResultMessage];

    }];
}

-(void)payView:(NSInteger)orderType
{
    NSString *orderCode = self.dataModel.OrderCode;
    
    //落槌价
    NSString *dropMoney = ((WKOrderProduct*)self.dataModel.Products[0]).GoodsPrice;
    //起拍价==保证金
    NSString *marginMoney = ((WKOrderProduct*)self.dataModel.Products[0]).GoodsStartPrice;
    //还需支付
    NSString *money = self.dataModel.PayAmount;
    
    if(orderType == 1)
    {
        WKPayView *payView = [[WKPayView alloc] initWithFrame:CGRectMake(0, 0, WKScreenW, WKScreenH) type:1 direction:0];
        payView.money.text = [NSString stringWithFormat:@"商品价格:  ￥%.2f",[self.dataModel.PayAmount floatValue]];//self.dataModel.PayAmount;
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
        self.payView = payView;
    }
    else if(orderType == 2)
    {
        WKPayView *payView = [[WKPayView alloc] initWithFrame:CGRectMake(0, 0, WKScreenW, WKScreenH) type:2 direction:1];
        
        payView.dropValue.text = [NSString stringWithFormat:@"￥%.2f",[dropMoney floatValue]];//落槌价
        payView.marginValue.text = [NSString stringWithFormat:@"￥%.2f",[marginMoney floatValue]];//保证金
        payView.payValue.text = [NSString stringWithFormat:@"￥%.2f",[money floatValue]];//还需要交的钱;
        self.payView = payView;
        if(!self.itemAddress)//缺少地址跳转
        {
//            payView.payValue.hidden = YES;
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
            
            payView.address.text = [NSString stringWithFormat:@"%@%@%@%@",self.itemAddress.ProvinceName,self.itemAddress.CityName,self.itemAddress.CountyName,self.itemAddress.Address];
        }


        payView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [[UIApplication sharedApplication].keyWindow addSubview:payView];
        
        self.payView = payView;
        payView.payTypeCallBlock = ^(NSInteger type){
            if(type == 1)
            {
                if(!self.itemAddress)
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
            else if(type == 4)
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
    NSDictionary *param = @{@"OrderCode":orderCode,
                            @"PayType":@(PayType),
                            @"OrderType":@(orderType),
                            @"AddressID":addressId};

    
    [[WKPayTool shareInstance] payWith:param type:PayType completionBlock:^(id obj) {
        WKPayResult *payResult = obj;
        if(payResult.resultType == WKPayResultTypeSuccess)
        {
            [self.payView removeFromSuperview];
            [[UIApplication sharedApplication].keyWindow removeFromSuperview];
            [self xw_postNotificationWithName:@"detailsPay" userInfo:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
//        int a = 0;
//        a = a+1;
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
