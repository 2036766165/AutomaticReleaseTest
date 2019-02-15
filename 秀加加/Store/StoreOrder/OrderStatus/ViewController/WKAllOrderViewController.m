//
//  WKAllOrderViewController.m
//  秀加加
//
//  Created by lin on 16/9/6.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKAllOrderViewController.h"
#import "WKOrderTableView.h"
#import "WKOrderDetailViewController.h"
#import "UIViewController+WKTrack.h"
#import "NSObject+XWAdd.h"
#import "WKShowInputView.h"

@interface WKAllOrderViewController() {
    bool showloading;
}

@property (nonatomic,strong) WKOrderTableView *orderTableView;

@property (nonatomic,assign) NSInteger type;

@property (nonatomic,assign) NSInteger ordertype;


@property (nonatomic,assign) NSInteger OrderListType;

@property (nonatomic,assign) NSInteger CustomType;

@end

@implementation WKAllOrderViewController



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
        _orderTableView.CustomType = _CustomType;
        _orderTableView.Type = _type;
        _orderTableView.OrderListType = _OrderListType;
    }
    return _orderTableView;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self xw_addNotificationForName:@"线下支付" block:^(NSNotification * _Nonnull notification) {
        
        [self loadData];

    }];
    
    [self xw_addNotificationForName:@"发货" block:^(NSNotification * _Nonnull notification) {
        
        [self loadData];
    }];
    
    [self xw_addNotificationForName:@"删除订单" block:^(NSNotification * _Nonnull notification) {
        
        [self loadData];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.orderTableView];
   
    [self initUi];
    
    [self loadData];
    
    [self event];
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
    // Dispose of any resources that can be recreated.
}

-(void)initUi
{

}

-(void)event
{
    WeakSelf(WKAllOrderViewController);
    self.orderTableView.requestBlock = ^(){
        
        [weakSelf loadData];
    };
    
    //删除订单
    self.orderTableView.clickCallBack = ^(ClickType type,NSInteger section){

        if(type == ClickRemove)//删除订单
        {
            [WKShowInputView showInputWithPlaceString:@"是否确认删除订单?" type:LABELTYPE andBlock:^(NSString * Count) {
                
                [weakSelf removeOrder:section];
                
                [weakSelf.orderTableView reloadData];
            }];
        }
        else if(type == ClickCell)
        {
            WKOrderStatusItemModel *model = weakSelf.orderTableView.dataArray[section];

            NSDictionary *dict = @{
                                   @"未支付":@(notPayOrderType),
                                   @"待发货":@(notSendOrderType),
                                   @"已发货":@(notConfirmOrderType),
                                   @"已完成":@(haveConfirmOrderType)
                                   };
            
            NSNumber *type = dict[model.CurrentOrderStatus];

            
            WKOrderDetailViewController *orderDetailVc = [[WKOrderDetailViewController alloc] initWithType:model.OrderType OrderListType:type.integerValue CustomType:weakSelf.CustomType];
            
            orderDetailVc.model = model;
            UIViewController *vc = [weakSelf viewControllerWith:weakSelf.view];
            [vc.navigationController pushViewController:orderDetailVc animated:YES];
            
//            orderDetailVc.sendShopBack = ^(){
//                [weakSelf.orderTableView reloadData];
//            };
        }
    };
}

-(void)loadData
{
    showloading = true;
    NSDictionary *param = @{@"PageIndex":@(self.orderTableView.pageNO),
                            @"PageSize":@(self.orderTableView.pageSize),
                            @"OrderListType":@(self.OrderListType),
                            @"OrderType":@(_ordertype)};
    
    NSLog(@"%@",param);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if(showloading == true){
            [WKProgressHUD showLoadingText:@"Loading..."];
        }
    });
    [WKHttpRequest storeOrder:HttpRequestMethodPost url:WKStoreOrder model:NSStringFromClass([WKOrderStatusModel class]) param:param success:^(WKBaseResponse *response) {
        showloading = false;
        WKOrderStatusModel *model = response.Data;
        
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
            else if(self.OrderListType == 5)
            {
                [self.orderTableView setRemindreImageName:@"person06" text:@"您还没有相关订单" completion:^{
                    
                }];
            }
        }
        [self.orderTableView reloadDataWithArray:model.InnerList];
        
    } failure:^(WKBaseResponse *response) {
        showloading = false;
        [WKProgressHUD showTopMessage:response.ResultMessage];
        [self.orderTableView setRemindreImageName:@"allOrderBig" text:@"您还没有相关订单" completion:^{
            
        }];
    }];
}


//店铺订单删除(该功能不确定)
-(void)removeOrder:(NSInteger)section
{
    WKOrderStatusItemModel *model = self.orderTableView.dataArray[section];
    NSString *url = [NSString configUrl:WKPersonOrderRemove With:@[@"orderCode"] values:@[[NSString stringWithFormat:@"%@",model.OrderCode]]];
    
    NSLog(@"%@",url);
    
    [WKHttpRequest personOrderRemove:HttpRequestMethodGet url:url model:nil param:@{} success:^(WKBaseResponse *response) {
        
        [self loadData];
        
//        [self.orderTableView reloadData];
        
    } failure:^(WKBaseResponse *response) {
        [WKProgressHUD showTopMessage:response.ResultMessage];
    }];
}

@end
