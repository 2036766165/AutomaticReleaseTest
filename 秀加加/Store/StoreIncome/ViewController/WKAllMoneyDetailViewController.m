//
//  WKAllMoneyDetailViewController.m
//  wdbo
//
//  Created by lin on 16/6/26.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import "WKAllMoneyDetailViewController.h"
#import "WKInComeTableView.h"
#import "UIViewController+WKTrack.h"
#import "WKPaymentDetailsModel.h"
#import "WKIncomeDetailsViewController.h"

@interface WKAllMoneyDetailViewController()

@property (nonatomic,strong) WKInComeTableView *inComeTableView;
@property (nonatomic,strong) NSMutableArray *modelArr;

/**
 *  页码
 */
@property (assign, nonatomic) NSInteger page;

@property (strong, nonatomic) UILabel * label;

@property (strong, nonatomic) UIImageView * imageView;

@end

@implementation WKAllMoneyDetailViewController


- (WKInComeTableView *)inComeTableView
{
    if (!_inComeTableView) {
        _inComeTableView = [[WKInComeTableView alloc] initWithFrame:CGRectMake(0, 0, WKScreenW, WKScreenH - 64 - 5 - 65)];
    }
    return _inComeTableView;
}
-(void)downLoadWithData{
    [WKHttpRequest incomeDetails:HttpRequestMethodPost url:WKIncomeDetailsUrl param:@{@"PageSize":@20,@"PageIndex":[NSString stringWithFormat:@"%lu",(long)self.page],@"LogType":@0} success:^(WKBaseResponse *response) {
        for (NSDictionary *item in response.Data[@"InnerList"]) {
             [self.modelArr addObject:[WKPaymentDetailsModel yy_modelWithDictionary:item]];
        }
        self.inComeTableView.dataArray = self.modelArr;
        if (self.modelArr.count<1) {
            [self.inComeTableView setRemindreImageName:@"none_all" text:@"您还没有相关记录" offsetY:-50 completion:^{
                
            }];
        }
        [self.inComeTableView reloadData];
        [self.inComeTableView endRefreshing];
    } failure:^(WKBaseResponse *response) {
        [self.inComeTableView setRemindreImageName:@"none_all" text:@"您还没有相关记录" offsetY:-50 completion:^{
         }];
    }];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.page = 1;
    self.modelArr = [NSMutableArray new];
    [self.view addSubview:self.inComeTableView];
    [self downLoadWithData];
    WeakSelf(WKAllMoneyDetailViewController);
    self.inComeTableView.refreshBlock=^(NSInteger type){
        if (type == 1) {
            weakSelf.page = 1;
            [weakSelf.modelArr removeAllObjects];
        }else{
            weakSelf.page ++;
        }
        [weakSelf downLoadWithData];
    };
    self.inComeTableView.block = ^(NSInteger index){
        WKPaymentDetailsModel *model = weakSelf.modelArr[index];
        WKIncomeDetailsViewController *detailsVC = [[WKIncomeDetailsViewController alloc]init];
        detailsVC.orderID = model.LogParm;
        detailsVC.type = model.AccountLogType;
        detailsVC.createTime=model.CreateTime;
        UIViewController *controller = [weakSelf viewControllerWith:weakSelf.view];
        [controller.navigationController pushViewController:detailsVC animated:YES];
    };
}


@end
