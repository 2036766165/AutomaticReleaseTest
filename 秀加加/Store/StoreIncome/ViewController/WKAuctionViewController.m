//
//  WKAuctionViewController.m
//  秀加加
//
//  Created by Chang_Mac on 16/9/12.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKAuctionViewController.h"
#import "WKIncomeRechargeView.h"
#import "WKPaymentDetailsModel.h"
#import "WKIncomeDetailsViewController.h"
#import "UIViewController+WKTrack.h"
@interface WKAuctionViewController ()
@property (nonatomic,strong) WKIncomeRechargeView *auctionTableView;

@property (nonatomic, strong) NSMutableArray *modelArr;

@property (nonatomic, assign) NSInteger page;

@property (strong, nonatomic) UILabel * label;

@property (strong, nonatomic) UIImageView * imageView;
@end

@implementation WKAuctionViewController

- (WKIncomeRechargeView *)auctionTableView
{
    if (!_auctionTableView) {
        _auctionTableView = [[WKIncomeRechargeView alloc] initWithFrame:CGRectMake(0, 0, WKScreenW, WKScreenH - 64-5 - 65)];
    }
    return _auctionTableView;
}

/**
 充值
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    self.modelArr = [NSMutableArray new];
    [self.view addSubview:self.auctionTableView];
    [self downLoadWithData];
    self.page = 1;
    WeakSelf(WKAuctionViewController);
    self.auctionTableView.refreshBlock=^(NSInteger type){
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
    [WKHttpRequest incomeDetails:HttpRequestMethodPost url:WKIncomeDetailsUrl param:@{@"PageSize":@20,@"PageIndex":[NSString stringWithFormat:@"%lu",(long)self.page],@"LogType":@3} success:^(WKBaseResponse *response) {
        for (NSDictionary *item in response.Data[@"InnerList"]) {
            [self.modelArr addObject:[WKPaymentDetailsModel yy_modelWithDictionary:item]];
        }
        self.auctionTableView.dataArray = self.modelArr;
        if (self.modelArr.count<1) {
            [self.auctionTableView setRemindreImageName:@"none_paimai" text:@"您还没有相关记录" offsetY:-50 completion:^{
                
            }];
        }
        [self.auctionTableView reloadData];
        [self.auctionTableView endRefreshing];
    } failure:^(WKBaseResponse *response) {
        [self.auctionTableView setRemindreImageName:@"none_paimai" text:@"您还没有相关记录" offsetY:-50 completion:^{
            
        }];
    }];
}

@end
