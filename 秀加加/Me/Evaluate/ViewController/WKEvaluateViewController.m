//
//  WKEvaluateViewController.m
//  秀加加
//
//  Created by lin on 16/8/30.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKEvaluateViewController.h"
#import "WKEvaluateTableView.h"
#import "WKEvaluateDetailViewController.h"
#import "WKEvaluateTableModel.h"
#import "NSObject+XWAdd.h"

@interface WKEvaluateViewController()

@property (nonatomic,strong) WKEvaluateTableView *evaluateTableView;

@property (assign, nonatomic) NSInteger pageNum;

@property (strong, nonatomic) NSMutableArray * dataArr;

@end

@implementation WKEvaluateViewController

- (WKEvaluateTableView *)evaluateTableView
{
    if (!_evaluateTableView) {
        WeakSelf(WKEvaluateViewController);
        _evaluateTableView = [[WKEvaluateTableView alloc] initWithFrame:CGRectMake(0, 0, WKScreenW, WKScreenH)];
        _evaluateTableView.requestBlock = ^(){
            [weakSelf loadingEvaluateData];
        };
    }
    return _evaluateTableView;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHex:0xF2F6FF];
    
    [self.view addSubview:self.evaluateTableView];
    
    [self initUi];
    
    [self event];
    
    [self loadingEvaluateData];
    
    [self xw_addNotificationForName:@"commitSuccess" block:^(NSNotification * _Nonnull notification) {
        [self loadingEvaluateData];
        self.evaluateTableView.pageNO = 1;
    }];
}

-(void)initUi
{
    self.title = @"评价晒单";
    self.dataArr = [NSMutableArray new];
}

-(void)event
{
    WeakSelf(WKEvaluateViewController);
    self.evaluateTableView.clickEvaluateCall = ^(WKEvaluateTableModel *detailsModel)
    {
        WKEvaluateDetailViewController *evaluateDeVc = [[WKEvaluateDetailViewController alloc] init];
        evaluateDeVc.model = detailsModel;
        [weakSelf.navigationController pushViewController:evaluateDeVc animated:YES];
    };
}

-(void)loadingEvaluateData
{
    NSDictionary *param = @{@"PageIndex":@(self.evaluateTableView.pageNO),
                            @"PageSize":@(self.evaluateTableView.pageSize)};
    
    [WKHttpRequest loadingEvaluate:HttpRequestMethodPost url:WKEvaluateTable param:param success:^(WKBaseResponse *response) {
        [self.dataArr removeAllObjects];
        for (NSDictionary *item in response.Data[@"InnerList"]) {
            [self.dataArr addObject:[WKEvaluateTableModel yy_modelWithDictionary:item]];
        }
        [self.evaluateTableView reloadDataWithArray:self.dataArr];
        
        if(self.dataArr.count <= 0)
        {
            [self.evaluateTableView setRemindreImageName:@"zanwushaidan" text:@"暂无相关内容\n去其他地方看看吧" completion:^{
                
            }];
        }
        [self.evaluateTableView reloadData];
    } failure:^(WKBaseResponse *response) {
        NSLog(@"%@",response);
    }];
}

@end
