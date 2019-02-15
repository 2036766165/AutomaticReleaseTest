//
//  WKCustomDetailViewController.m
//  wdbo
//  客户详情的控制器
//  Created by Chang_Mac on 16/6/23.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import "WKCustomDetailViewController.h"
#import "WKCustomDetailsView.h"
#import "WKCustomerOrderModel.h"
#import "WKOrderDetailViewController.h"

@interface WKCustomDetailViewController ()

@property (strong, nonatomic) WKCustomDetailsView * detailsTableView;

@end

@implementation WKCustomDetailViewController

-(WKCustomDetailsView *)detailsTableView{
    if (!_detailsTableView) {
        _detailsTableView = [[WKCustomDetailsView alloc]initWithFrame:CGRectMake(0, 70, WKScreenW, WKScreenH-70)];
    }
    
    return _detailsTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createMainView];
    [self loadCustomOrderList];
    
    self.detailsTableView.customModel = self.customModel;
}

-(void)createMainView{
    self.title = @"客户详情";
    self.view.backgroundColor = [UIColor colorWithHexString:@"f3f6ff"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.detailsTableView];
    
    WeakSelf(WKCustomDetailViewController);
    self.detailsTableView.headBlock = ^(){
        weakSelf.detailsTableView.pageNO = 1;
        [weakSelf.InnerList removeAllObjects];
        [weakSelf loadCustomOrderList];
    };
    self.detailsTableView.footBlock = ^(){
        [weakSelf loadCustomOrderList];
    };

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//获取客户的订单列表
-(void)loadCustomOrderList{
    [WKProgressHUD showLoadingText:@""];
    [WKHttpRequest incomeDetails:HttpRequestMethodPost url:WKStoreOrder param:@{@"CustomerNo":self.customCode,@"PageSize":@(self.detailsTableView.pageSize),@"PageIndex":@(self.detailsTableView.pageNO),@"OrderListType":@1,@"OrderType":@""} success:^(WKBaseResponse *response){
        WKCustomerOrderModel *model = [WKCustomerOrderModel yy_modelWithDictionary:response.Data];
        if(self.InnerList == nil)
        {
            self.InnerList = [[NSMutableArray alloc]initWithArray:model.InnerList];
        }
        else
        {
            [self.InnerList addObjectsFromArray:model.InnerList];
        }
        model.InnerList = [[NSArray alloc]initWithArray:self.InnerList];
        self.detailsTableView.CustomerOrderModel = model;
        
        if(self.InnerList.count <= 0)
        {
            [self.detailsTableView setRemindreImageName:@"notHaveBig" text:@"您还没有相关订单" offsetY:50 completion:^{
                
            }];
        }
        [self.detailsTableView reloadData];
        [self.detailsTableView endRefreshing];
    } failure:^(WKBaseResponse *response){
        [self.detailsTableView setRemindreImageName:@"notHaveBig" text:@"您还没有相关订单" offsetY:50 completion:^{
            
        }];
    }];
}

@end
