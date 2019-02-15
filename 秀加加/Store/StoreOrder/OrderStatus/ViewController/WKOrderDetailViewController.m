//
//  WKOrderDetailViewController.m
//  秀加加
//
//  Created by lin on 16/9/12.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKOrderDetailViewController.h"
#import "WKOrderDetailTableView.h"
#import "WKProgressHUD.h"
#import "WKOrderDetailModel.h"
#import "WKOrderStatusModel.h"
#import "WKAddaddressViewController.h"
#import "WKAddressModel.h"
#import "WKShowInputView.h"
#import "WKQrScanningViewController.h"
#import "WKOrderFixExpressModel.h"
#import "WKSelectLogisticsViewController.h"
#import "NSObject+XWAdd.h"
#import "WKNavigationController.h"
#import "PlayerManager.h"
#import "WKAddaddressViewController.h"

@interface WKOrderDetailViewController()<WKSelectAddressDelegate>

@property (nonatomic,strong) WKOrderDetailTableView  *orderDetailTableView;

@property (nonatomic,assign) NSInteger type;

@property (nonatomic,assign) NSInteger OrderListType;

@property (nonatomic,strong) WKOrderDetailModel *dataModel;

@property (nonatomic,strong) WKOrderFixExpressModel *fixExpressmodel;

@property (nonatomic,strong) NSArray *array;

@property (nonatomic,strong) NSString *expressNo;

@property (nonatomic,strong) NSMutableArray *nameArr;

@property (nonatomic,assign) NSInteger CustomType;

@end

@implementation WKOrderDetailViewController


-(instancetype)initWithType:(NSInteger)type
              OrderListType:(NSInteger)OrderListType
                 CustomType:(NSInteger)CustomType
{
    if (self = [super init]) {
        _type = type;
        _OrderListType = OrderListType;
        _CustomType = CustomType;
    }
    return self;
}

- (WKOrderDetailTableView *)orderDetailTableView
{
    if (!_orderDetailTableView) {
        _orderDetailTableView = [[WKOrderDetailTableView alloc] initWithFrame:CGRectMake(0, 32, WKScreenW, WKScreenH-32)];
        _orderDetailTableView.type = _type;
        _orderDetailTableView.OrderListType = _OrderListType;
        _orderDetailTableView.CustomType = _CustomType;
        
    }
    return _orderDetailTableView;
}

- (void)viewDidLoad {
    
    self.nameArr = [NSMutableArray array];
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self initUi];
    
    [self event];
    
    [self loadData:_model.OrderCode];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[PlayerManager sharedManager] stopPlaying];
}

-(void)initUi
{
    self.title = @"订单详情";
}

-(void)event
{
    //发货操作
    WeakSelf(WKOrderDetailViewController);
    self.orderDetailTableView.sendCallBack = ^(NSInteger type,NSInteger section){
        if(type == 1)//发货
        {
            if([weakSelf.orderDetailTableView.address.text isEqual:@""] == true){
                [WKPromptView showPromptView:@"收货地址为空，请填写收货地址！"];
                return;
            }
            [weakSelf sendShop:weakSelf.model.OrderCode ExpressCompanyName:weakSelf.orderDetailTableView.expressName ExpressCompanyNo:weakSelf.expressNo];
        }
        else if(type == 2)
        {
            WKAddressModel* add = [[WKAddressModel alloc] init];
            add.Address = weakSelf.dataModel.ShipAddress;
            add.CityName = weakSelf.dataModel.ShipCity;
            add.ProvinceName = weakSelf.dataModel.ShipProvince;
            add.CountyName = weakSelf.dataModel.ShipCounty;
            add.Phone = weakSelf.dataModel.ShipPhone;
            add.Contact = weakSelf.dataModel.ShipName;
            add.PostCode = weakSelf.dataModel.ShipZip;
            
            WKAddaddressViewController *address = [[WKAddaddressViewController alloc] initWithID:@"0" type:WKAddressEditTypeEditDistrict from:WKAddressFromOrder];
            address.dataModel = add;
            address.AddSuccess = ^(NSDictionary* a){
                NSMutableDictionary* para = [[NSMutableDictionary alloc] init];
                [para addEntriesFromDictionary:@{@"OrderCode":weakSelf.dataModel.OrderCode}];
                [para addEntriesFromDictionary:@{@"ShipProvince":a[@"ProvinceName"]}];
                [para addEntriesFromDictionary:@{@"ShipCity":a[@"CityName"]}];
                [para addEntriesFromDictionary:@{@"ShipCounty":a[@"CountyName"]}];
                [para addEntriesFromDictionary:@{@"ShipAddress":a[@"Address"]}];
                [para addEntriesFromDictionary:@{@"ShipName":a[@"Contact"]}];
                [para addEntriesFromDictionary:@{@"ShipZip":a[@"PostCode"]}];
                [para addEntriesFromDictionary:@{@"ShipPhone":a[@"Phone"]}];
                
                [WKHttpRequest addressAdd:HttpRequestMethodPost url:@"Order/OrderAddressUpdate" para:para success:^(WKBaseResponse *response) {
                    [WKProgressHUD showTopMessage:@"地址修改成功"];
                    weakSelf.orderDetailTableView.name.text = [NSString stringWithFormat:@"%@ %@",a[@"Contact"],a[@"Phone"]];
                    weakSelf.orderDetailTableView.address.text = [NSString stringWithFormat:@"%@%@%@%@",a[@"ProvinceName"],a[@"CityName"],a[@"CountyName"],a[@"Address"]];
                    weakSelf.dataModel.ShipAddress=a[@"Address"];
                    weakSelf.dataModel.ShipCity=a[@"CityName"];
                    weakSelf.dataModel.ShipProvince=a[@"ProvinceName"];
                    weakSelf.dataModel.ShipCounty=a[@"CountyName"];
                    weakSelf.dataModel.ShipPhone=a[@"Phone"];
                    weakSelf.dataModel.ShipName=a[@"Contact"];
                    weakSelf.dataModel.ShipZip=a[@"PostCode"];

                } failure:^(WKBaseResponse *response) {
                    [WKProgressHUD showTopMessage:response.ResultMessage];
                }];

            };
            //address.delegate = weakSelf;
//            WKNavigationController *nav = [[WKNavigationController alloc] initWithRootViewController:address];
            
//            nav.view.frame = CGRectMake(0, WKScreenH - (44 * 9), WKScreenW, 44 * 9);
            
//            [weakSelf addChildViewController:nav];
//            [weakSelf.view addSubview:nav.view];
            [weakSelf.navigationController pushViewController:address animated:YES];
        }
        else if(type == 3)//单价(cell)
        {
            //编辑的功能，用来修改价钱
            [WKShowInputView showInputWithPlaceString:@"请填写商品运费" type:TEXTFIELDTYPE andBlock:^(NSString *money) {
                
                [weakSelf fixShopTranFee:money orderCode:weakSelf.orderDetailTableView.model.OrderCode];
        
            }];
            
            [WKShowInputView setKeyBoard:UIKeyboardTypeNumberPad and:TEXTFIELDTYPE];
            
        }
        else if(type == 4)//总价
        {
            //编辑的功能，用来修改价钱（footer）
            [WKShowInputView showInputWithPlaceString:@"请填写商品总额" type:TEXTFIELDTYPE andBlock:^(NSString *money) {
                
                [weakSelf fixShopAllMoney:money orderCode:weakSelf.orderDetailTableView.model.OrderCode];
                
            }];
            
            [WKShowInputView setKeyBoard:UIKeyboardTypeNumberPad and:TEXTFIELDTYPE];
        }
        else if(type == 5) //选择物流公司
        {
            if(weakSelf.nameArr != nil && weakSelf.nameArr.count > 0){
                WKSelectLogisticsViewController *logisticsVc = [[WKSelectLogisticsViewController alloc] init];
                logisticsVc.array = weakSelf.nameArr;
                logisticsVc.modalPresentationStyle = UIModalPresentationCustom;
                logisticsVc.block = ^(NSString *str,NSString *ExpressId){
                    if([str isEqualToString:@""] || [ExpressId isEqualToString:@""])
                    {
                        [WKProgressHUD showTopMessage:@"请先获取物流单号"];
                    }
                    weakSelf.orderDetailTableView.expressName = str;
                    //weakSelf.orderDetailTableView.expressNum = ExpressId;
                    [weakSelf.orderDetailTableView reloadData];
                };
                [weakSelf presentViewController:logisticsVc animated:YES completion:nil];
            }
        }
        else if(type == 6) //扫码
        {
            //1.通过手动输入的方式获取物流单号
            [WKShowInputView showInputWithPlaceString:@"请输入物流单号" type:TEXTFIELDTYPE andBlock:^(NSString *content) {
                if(content.length > 0)
                {
                    weakSelf.orderDetailTableView.expressNum = content;
                    
                    //快递单号接口
                    [weakSelf fixExpress:weakSelf.model.OrderCode expressCode:weakSelf.orderDetailTableView.expressNum];
                    
                    [weakSelf.orderDetailTableView reloadData];
                }
                
            }];
            
            [WKShowInputView textField:weakSelf.orderDetailTableView.expressNum];
            
            //2.通过扫描的方式获取物流单号
            [WKShowInputView addImage:[UIImage imageNamed:@"saoma"] and:^{
                WKQrScanningViewController *scanning = [[WKQrScanningViewController alloc]init];
                scanning.scnningBlock = ^(NSString *string){
                    
                    weakSelf.orderDetailTableView.expressNum = string;
                    
                    //快递单号接口
                    [weakSelf fixExpress:weakSelf.model.OrderCode expressCode:weakSelf.orderDetailTableView.expressNum];
                };
                [weakSelf.navigationController pushViewController:scanning animated:YES];
            }];
            [WKShowInputView textField:weakSelf.orderDetailTableView.orderNumber];
        }
        else if(type == 7)//线下支付
        {
            [weakSelf orderPayOffline];
        }
        else if(type == 8)//删除订单
        {
            [WKShowInputView showInputWithPlaceString:@"是否确认删除订单?" type:LABELTYPE andBlock:^(NSString * Count) {
                
                [weakSelf removeOrder:weakSelf.dataModel.OrderCode];
                
            }];
        }
    };
}

-(void)removeOrder:(NSString*)orderCode
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

- (void)selectedAddress:(WKAddressListItem *)address
{
    self.orderDetailTableView.name.text = [NSString stringWithFormat:@"%@ %@",address.Contact,address.Phone];
    self.orderDetailTableView.address.text = [NSString stringWithFormat:@"%@%@%@%@",address.ProvinceName,address.CityName,address.CountyName,address.Address];
}

-(void)loadData:(NSString *)orderCode
{
    NSString *url = [NSString configUrl:WKOrderDetail With:@[@"orderCode"] values:@[[NSString stringWithFormat:@"%@",_model.OrderCode]]];
    
    [WKProgressHUD showLoadingText:@""];
    
    [WKHttpRequest storeOrderDetail:HttpRequestMethodGet url:url model:@"WKOrderDetailModel" param:nil success:^(WKBaseResponse *response) {
        
        NSLog(@"%@",response.json);
        
        self.dataModel = response.Data;
        
        [self.view addSubview:self.orderDetailTableView];
        
        self.orderDetailTableView.model = self.dataModel;
        
        [self.orderDetailTableView reloadDataWithArray:self.dataModel.Products];
        
    } failure:^(WKBaseResponse *response) {
        [WKProgressHUD showTopMessage:response.ResultMessage];
    }];
}

//通过物流单号获取物流公司
-(void)fixExpress:(NSString *)orderCode expressCode:(NSString *)expressCode
{
    NSString *url = [NSString configUrl:WKOrderFixExpress With:@[@"orderCode",@"expressCode"] values:@[[NSString stringWithFormat:@"%@",_model.OrderCode],[NSString stringWithFormat:@"%@",expressCode]]];
    
    
    NSLog(@"%@",_model.OrderCode);
    NSLog(@"%@",expressCode);
    
    [WKHttpRequest storeOrderFixExpress:HttpRequestMethodPost url:url model:@"WKOrderFixExpressModel" param:nil success:^(WKBaseResponse *response) {
        
        NSLog(@"%@",response.json);
        
        //此方法用来解析数组的方式
        self.array = [NSArray yy_modelArrayWithClass:[WKOrderFixExpressItemModel class] json:response.json[@"Data"]];
        
        self.nameArr = [NSMutableArray new];
        for(int i = 0 ; i < self.array.count;i++)
        {
            WKOrderFixExpressItemModel *model = self.array[i];
            [self.nameArr addObject:model.ExpressCompanyName];
            
        }
        
        if(self.array.count <= 0)
        {
        
        }
        else
        {
            self.orderDetailTableView.expressName = ((WKOrderFixExpressItemModel*)self.array[0]).ExpressCompanyName;
            self.expressNo = ((WKOrderFixExpressItemModel*)self.array[0]).ExpressCompanyNo;
            [self.orderDetailTableView reloadData];
        }
        
    } failure:^(WKBaseResponse *response) {
        [WKProgressHUD showTopMessage:response.ResultMessage];
    }];
}

//发货接口
-(void)sendShop:(NSString *)OrderCode ExpressCompanyName:(NSString *)ExpressCompanyName ExpressCompanyNo:(NSString *)ExpressCompanyNo
{
    NSString *CompanyName = (ExpressCompanyName == nil || [ExpressCompanyName isEqualToString:@""])?@"":ExpressCompanyName;
    
    NSString *CompanyNo   = (ExpressCompanyNo == nil || [ExpressCompanyNo isEqualToString:@""])?@"":ExpressCompanyNo;
    WeakSelf(WKOrderDetailViewController);
    
    NSString *reminderStr;
    if (CompanyNo.length == 0 || CompanyName.length == 0) {
        reminderStr = @"没有填写快递信息，是否发货？";
    }else{
        reminderStr = @"确认要发货吗?";
    }
    
    [WKShowInputView showInputWithPlaceString:reminderStr type:LABELTYPE andBlock:^(NSString *name) {
        
        NSDictionary *param = @{@"OrderCode":OrderCode,
                                @"ExpressCompanyName":CompanyName,
                                @"ExpressCompanyNo":CompanyNo};
        NSLog(@"%@",param);
        
        [WKHttpRequest storeOrderSendShop:HttpRequestMethodPost url:WKStoreSendShop model:nil param:param success:^(WKBaseResponse *response) {
            
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
            [self xw_postNotificationWithName:@"发货" userInfo:nil];
            
        } failure:^(WKBaseResponse *response) {
            
            [WKProgressHUD showTopMessage:response.ResultMessage];
        }];
    }];
    
//    if(CompanyName == nil || CompanyNo == nil || [CompanyNo isEqualToString:@""] || [CompanyName isEqualToString:@""])
//    {
//        [WKPromptView showPromptView:@"请填写物流信息"];
//        //[[UIApplication sharedApplication].keyWindow addSubview:promptView];
//    }
//    else
//    {
//        
//    }
}

//线下支付
-(void)orderPayOffline
{
    [WKShowInputView showInputWithPlaceString:@"确认要线下支付吗？" type:LABELTYPE andBlock:^(NSString *name) {
        
        NSString *url = [NSString configUrl:WKOrderPayOffline With:@[@"orderCode"] values:@[[NSString stringWithFormat:@"%@",self.model.OrderCode]]];
        
        
        [WKHttpRequest storeOrderPayOffline:HttpRequestMethodGet url:url model:nil param:@{} success:^(WKBaseResponse *response) {
            [WKProgressHUD showTopMessage:response.ResultMessage];
            
            [self.navigationController popViewControllerAnimated:YES];
            
             [self xw_postNotificationWithName:@"线下支付" userInfo:nil];
            
        } failure:^(WKBaseResponse *response) {
            [WKProgressHUD showTopMessage:response.ResultMessage];
            
        }];
    }];
}

//修改商品总额
-(void)fixShopAllMoney:(NSString*)Allmoney orderCode:(NSString *)orderCode
{
    NSString *url = [NSString configUrl:WKFixTranFee With:@[@"orderCode",@"FieldName",@"FieldValue"] values:@[[NSString stringWithFormat:@"%@",orderCode],@"GoodsAmount",[NSString stringWithFormat:@"%@",Allmoney]]];
    [WKHttpRequest FixTranFee:HttpRequestMethodPost url:url param:nil model:nil success:^(WKBaseResponse *response) {
        
        if([response.Data integerValue] == 0)
        {
            self.orderDetailTableView.model.GoodsAmount = Allmoney;
            
            NSInteger intMoney = Allmoney.doubleValue;
            
            self.orderDetailTableView.model.GoodsAmount = [NSString stringWithFormat:@"%ld",(long)intMoney];
            
            [self.orderDetailTableView reloadData];
        }
        else
        {
            
        }
        
    } failure:^(WKBaseResponse *response) {
        
        [WKProgressHUD showTopMessage:response.ResultMessage];
    }];
}

//修改运费
-(void)fixShopTranFee:(NSString *)FeeMoney orderCode:(NSString *)orderCode
{
    NSString *url = [NSString configUrl:WKFixTranFee With:@[@"orderCode",@"FieldName",@"FieldValue"] values:@[[NSString stringWithFormat:@"%@",orderCode],@"TranFeeAmount",[NSString stringWithFormat:@"%@",FeeMoney]]];
    [WKHttpRequest FixTranFee:HttpRequestMethodPost url:url param:nil model:nil success:^(WKBaseResponse *response) {
        
        if([response.Data integerValue] == 0)
        {
            self.orderDetailTableView.model.TranFeeAmount = FeeMoney;
            
        
            [self.orderDetailTableView reloadData];
        }
        else
        {
        
        }
        
    } failure:^(WKBaseResponse *response) {
        
        [WKProgressHUD showTopMessage:response.ResultMessage];
    }];
}

@end
