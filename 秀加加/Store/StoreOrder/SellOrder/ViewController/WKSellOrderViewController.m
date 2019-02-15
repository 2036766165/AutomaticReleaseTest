//
//  WKSellOrderViewController.m
//  秀加加
//
//  Created by lin on 16/9/5.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKSellOrderViewController.h"
#import "WKPagesView.h"
#import "WKAllOrderViewController.h"
#import "WKOrderTableViewCell.h"


@interface WKSellOrderViewController ()

@property (nonatomic,strong) NSMutableArray *array;

@end

@implementation WKSellOrderViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUi];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)initUi
{
    self.array = [NSMutableArray array];
    
    for(int i = 1;i < 6;i++)
    {
        WKAllOrderViewController *myOrderAllVc = [[WKAllOrderViewController alloc] initWithType:AuctionType OrderListType:i CustomType:1];
        [self.array addObject:myOrderAllVc];
    }
    
    WKPagesView *pageView = [[WKPagesView alloc] initWithFrame:CGRectZero toolBarType:WKPageTypeOrder BtnTitles:@[@"全部订单",@"未支付",@"待发货",@"已发货",@"已完成"] images:@[@"allOrder_normal",@"notPay_normal",@"notSend_normal",@"notReceive_normal",@"haveConfirm_normal"] selectedImages:@[@"allOrder_select",@"notPay_select",@"notSend_select",@"notReceive_select",@"haveConfirm_select"] viewController:self.array];
    
    [self.view addSubview:pageView];
    
    [pageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(0);
        make.left.mas_offset(0);
        make.right.mas_offset(0);
    }];
}

@end
