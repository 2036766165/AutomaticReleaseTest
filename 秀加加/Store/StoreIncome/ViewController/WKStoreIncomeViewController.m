//
//  WKIncomeViewController.m
//  wdbo
//
//  Created by lin on 16/6/20.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import "WKStoreIncomeViewController.h"
#import "WKSmallMoneyViewController.h"
#import "WKInComeDetailViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "AppDelegate.h"
#import "WKShowInputView.h"
#import "WKIncomeModel.h"
#import "WKStoreIncomView.h"
#import "WKIncomeTestView.h"
#import "WKStoreRechargeViewController.h"
#import "NSObject+XWAdd.h"

@interface WKStoreIncomeViewController ()

@property (strong, nonatomic) WKStoreIncomView *storeIncome;

@property (strong, nonatomic) WKIncomeModel * model;

@property (strong ,nonatomic) NSString * strCode;

@end

@implementation WKStoreIncomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的钱包";
//    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(15, 0, 60, 44)];
//    [rightButton setTitle:@"收支明细" forState:UIControlStateNormal];
//    rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
//    [rightButton setTitleColor:[UIColor colorWithHexString:@"7e879d"] forState:UIControlStateNormal];
//    [rightButton addTarget:self action:@selector(messageEvent:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
//    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    self.storeIncome = [[WKStoreIncomView alloc]initWithFrame:CGRectMake(0, 0, WKScreenW, WKScreenH)];
    WeakSelf(WKStoreIncomeViewController);
    self.storeIncome.block = ^(incomeType count){
        if (count == rechargeType) {//充值
            WKStoreRechargeViewController *rechargeVC = [[WKStoreRechargeViewController alloc]init];
            [weakSelf.navigationController pushViewController:rechargeVC animated:YES];
            
        }else if (count == copyType) {//复制
            
            [weakSelf getSellerBindCode];
            
        }else if (count == withDrawType){//提现
            
            WKSmallMoneyViewController *smallMoneyVC = [[WKSmallMoneyViewController alloc] init];
                smallMoneyVC.maxMoney = weakSelf.model.MoneyCanTake;
            [weakSelf.navigationController pushViewController:smallMoneyVC animated:YES];
            
        }else if (count == incomeDetailsType){//收入详情
            WKInComeDetailViewController *inComeDetailVC = [[WKInComeDetailViewController alloc] init];
            [weakSelf.navigationController pushViewController:inComeDetailVC animated:YES];
        }
    };
    [self.view addSubview:self.storeIncome];
    
    [self xw_addNotificationForName:@"rechargeNumber" block:^(NSNotification * _Nonnull notification) {
        [weakSelf loadingStoreIncomeData];
    }];
    
    [self loadingStoreIncomeData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)loadingStoreIncomeData{
    [WKHttpRequest storeIncome:HttpRequestMethodGet url:WKStoreIncome param:nil success:^(WKBaseResponse *response) {
        self.model = [WKIncomeModel yy_modelWithDictionary:response.Data];
        [self.storeIncome refreshDataWithData:self.model];
    } failure:^(WKBaseResponse *response) {
        
    }];
}

-(void)getSellerBindCode{
    [WKHttpRequest getSellerBindCode:HttpRequestMethodGet url:WKSellerBind param:nil success:^(WKBaseResponse *response) {
        [WKIncomeTestView incomeTest:response.Data];
        UIPasteboard *pab = [UIPasteboard generalPasteboard];
        [pab setString:response.Data];
    } failure:^(WKBaseResponse *response) {}];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
    if (self.storeIncome) {
        [self loadingStoreIncomeData];
    }
}
@end
