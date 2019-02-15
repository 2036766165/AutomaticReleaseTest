//
//  WkMyOrderShopOrderViewController.m
//  秀加加
//
//  Created by lin on 2016/9/22.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WkMyOrderShopOrderViewController.h"
#import "WKMyOrderAllViewController.h"
#import "WKPagesView.h"
#import "WKOrderTableViewCell.h"

@interface WkMyOrderShopOrderViewController ()

@property (nonatomic,strong) NSMutableArray *array;

@end

@implementation WkMyOrderShopOrderViewController

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
        if(i == 5)
        {
            i += 1;
        }
        WkMyOrderAllViewController *myOrderAllVc = [[WkMyOrderAllViewController alloc] initWithType:StoreType OrderListType:i CustomType:2];
        [self.array addObject:myOrderAllVc];
    }
    
    WKPagesView *pageView = [[WKPagesView alloc] initWithFrame:CGRectZero toolBarType:WKPageTypeOrder BtnTitles:@[@"全部订单",@"待付款",@"待发货",@"待收货",@"待评价"] images:@[@"allOrder_normal",@"notPay_normal",@"notSend_normal",@"notReceive_normal",@"notEvaluate_normal"] selectedImages:@[@"allOrder_select",@"notPay_select",@"notSend_select",@"notReceive_select",@"notEvaluate_select"] viewController:self.array];
    
    [self.view addSubview:pageView];
    
    [pageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(0);
        make.left.mas_offset(0);
        make.right.mas_offset(0);
    }];
}

@end
