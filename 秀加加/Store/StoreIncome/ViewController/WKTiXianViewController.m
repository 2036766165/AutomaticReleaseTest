//
//  WKTiXianViewController.m
//  wdbo
//
//  Created by lin on 16/6/26.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import "WKTiXianViewController.h"
#import "WKInComeTableView.h"
#import "WKPaymentDetailsModel.h"
#import "WKIncomeDetailsViewController.h"
#import "UIViewController+WKTrack.h"

@interface WKTiXianViewController()

@property (nonatomic,strong) WKInComeTableView *tiXianTableView;

@property (nonatomic, strong) NSMutableArray *modelArr;

@property (nonatomic, assign) NSInteger page;

@property (strong, nonatomic) UILabel * label;

@property (strong, nonatomic) UIImageView * imageView;

@end

@implementation WKTiXianViewController

- (WKInComeTableView *)tiXianTableView
{
    if (!_tiXianTableView) {
        _tiXianTableView = [[WKInComeTableView alloc] initWithFrame:CGRectMake(0, 0, WKScreenW, WKScreenH - 64 - 5 - 65)];
    }
    return _tiXianTableView;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.modelArr = [NSMutableArray new];
    [self.view addSubview:self.tiXianTableView];
    [self downLoadWithData];
    WeakSelf(WKTiXianViewController);
    self.tiXianTableView.refreshBlock=^(NSInteger type){
        if (type == 1) {
            weakSelf.page = 1;
            [weakSelf.modelArr removeAllObjects];
        }else{
            weakSelf.page ++;
        }
        [weakSelf downLoadWithData];
    };
    self.tiXianTableView.block = ^(NSInteger index){
        WKPaymentDetailsModel *model = weakSelf.modelArr[index];
        WKIncomeDetailsViewController *detailsVC = [[WKIncomeDetailsViewController alloc]init];
        detailsVC.type = @"4";
        detailsVC.orderID = model.LogParm;
        UIViewController *controller = [weakSelf viewControllerWith:weakSelf.view];
        [controller.navigationController pushViewController:detailsVC animated:YES];
    };
}
-(void)downLoadWithData{
    [WKHttpRequest incomeDetails:HttpRequestMethodPost url:WKIncomeDetailsUrl param:@{@"PageSize":@20,@"PageIndex":[NSString stringWithFormat:@"%lu",(long)self.page],@"LogType":@4} success:^(WKBaseResponse *response) {
        for (NSDictionary *item in response.Data[@"InnerList"]) {
            [self.modelArr addObject:[WKPaymentDetailsModel yy_modelWithDictionary:item]];
        }
        self.tiXianTableView.dataArray = self.modelArr;
        if (self.modelArr.count<1) {
            [self.tiXianTableView setRemindreImageName:@"none_takecash" text:@"您还没有相关记录" offsetY:-50 completion:^{
                
            }];
        }
        [self.tiXianTableView reloadData];
        [self.tiXianTableView endRefreshing];
    } failure:^(WKBaseResponse *response) {
        [self.tiXianTableView setRemindreImageName:@"none_takecash" text:@"您还没有相关记录" offsetY:-50 completion:^{
            
        }];
    }];
}

@end
