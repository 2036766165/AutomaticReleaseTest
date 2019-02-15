//
//  WKDaShangViewController.m
//  wdbo
//
//  Created by lin on 16/6/26.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import "WKDaShangViewController.h"
#import "WKIncomePayView.h"
#import "WKPaymentDetailsModel.h"
@interface WKDaShangViewController()

@property (nonatomic,strong) WKIncomePayView *daShangTableView;

@property (nonatomic,strong) NSMutableArray *modelArr;

@property (nonatomic,assign) NSInteger page;

@property (strong, nonatomic) UIImageView * imageView;

@property (strong, nonatomic) UILabel * label;

@end

@implementation WKDaShangViewController

- (WKIncomePayView *)daShangTableView
{
    if (!_daShangTableView) {
        _daShangTableView = [[WKIncomePayView alloc] initWithFrame:CGRectMake(0, 0, WKScreenW, WKScreenH - 64 - 5 - 65)];
    }
    return _daShangTableView;
}

/**
 支付
 */
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.modelArr = [NSMutableArray new];
    [self.view addSubview:self.daShangTableView];
    self.page = 1;
    [self downLoadWithData];
    WeakSelf(WKDaShangViewController);
    self.daShangTableView.refreshBlock=^(NSInteger type){
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
    [WKHttpRequest incomeDetails:HttpRequestMethodPost url:WKIncomeDetailsUrl param:@{@"PageSize":@20,@"PageIndex":[NSString stringWithFormat:@"%lu",(long)self.page],@"LogType":@1} success:^(WKBaseResponse *response) {
        for (NSDictionary *item in response.Data[@"InnerList"]) {
            [self.modelArr addObject:[WKPaymentDetailsModel yy_modelWithDictionary:item]];
        }
        self.daShangTableView.dataArray = self.modelArr;
        if (self.modelArr.count<1) {
            [self.daShangTableView setRemindreImageName:@"none_reward" text:@"您还没有相关记录" offsetY:-50 completion:^{
                
            }];
        }
        [self.daShangTableView reloadData];
        [self.daShangTableView endRefreshing];
    } failure:^(WKBaseResponse *response) {
        [self.daShangTableView setRemindreImageName:@"none_reward" text:@"您还没有相关记录" offsetY:-50 completion:^{
            
        }];
    }];
}
@end
