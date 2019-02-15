//
//  WKOrderIncomeViewController.m
//  wdbo
//
//  Created by lin on 16/6/26.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import "WKOrderIncomeViewController.h"
#import "WKIncomePayView.h"
#import "WKPaymentDetailsModel.h"
@interface WKOrderIncomeViewController()

@property (nonatomic,strong) WKIncomePayView *orderInComeTableView;

@property (nonatomic, strong) NSMutableArray *modelArr;

@property (nonatomic, assign) NSInteger page;

@property (strong, nonatomic) UILabel * label;

@property (strong, nonatomic) UIImageView * imageView;

@end

@implementation WKOrderIncomeViewController

- (WKIncomePayView *)orderInComeTableView
{
    if (!_orderInComeTableView) {
        _orderInComeTableView = [[WKIncomePayView alloc] initWithFrame:CGRectMake(0, 0, WKScreenW, WKScreenH - 64-5 - 65)];
    }
    return _orderInComeTableView;
}


/**
 收入
 */
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.modelArr = [NSMutableArray new];
    [self.view addSubview:self.orderInComeTableView];
    [self downLoadWithData];
    self.page = 1;
    WeakSelf(WKOrderIncomeViewController);
    self.orderInComeTableView.refreshBlock=^(NSInteger type){
        if (type == 1) {
            weakSelf.page = 1;
            [weakSelf.modelArr removeAllObjects];
        }else{
            weakSelf.page ++;
        }
        [weakSelf downLoadWithData];
    };
}
-(void)downLoadWithData{
    [WKHttpRequest incomeDetails:HttpRequestMethodPost url:WKIncomeDetailsUrl param:@{@"PageSize":@20,@"PageIndex":[NSString stringWithFormat:@"%lu",(long)self.page],@"LogType":@2} success:^(WKBaseResponse *response) {
        for (NSDictionary *item in response.Data[@"InnerList"]) {
            [self.modelArr addObject:[WKPaymentDetailsModel yy_modelWithDictionary:item]];
        }
        self.orderInComeTableView.dataArray = self.modelArr;
        if (self.modelArr.count<1) {
            [self.orderInComeTableView setRemindreImageName:@"none_order" text:@"您还没有相关记录" offsetY:-50 completion:^{
                
            }];
        }
        [self.orderInComeTableView reloadData];
        [self.orderInComeTableView endRefreshing];
    } failure:^(WKBaseResponse *response) {
        [self.orderInComeTableView setRemindreImageName:@"none_order" text:@"您还没有相关记录" offsetY:-50 completion:^{
            
        }];
    }];
}

@end
