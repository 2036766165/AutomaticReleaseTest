//
//  WKCustomTabViewController.m
//  wdbo
//
//  Created by Chang_Mac on 16/6/22.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import "WKCustomTabViewController.h"
#import "WKCustomTableViewCell.h"
#import "WKCustomDetailViewController.h"
#import "UIViewController+WKTrack.h"
#import "WKBaseTableView.h"
#import "WKCustomInformationModel.h"
#import "WKCustomTableView.h"
#import "WKCustomTableModel.h"

@interface WKCustomTabViewController ()

@property (strong, nonatomic) WKCustomTableModel *model;

@property (strong, nonatomic) WKCustomTableView * customTableView;

@property (strong, nonatomic) UIView *DefaultView;

@end

@implementation WKCustomTabViewController

-(WKCustomTableView *)customTableView{
    if (!_customTableView) {
        _customTableView = [[WKCustomTableView alloc]initWithFrame:CGRectMake(0, 6, WKScreenW, WKScreenH-70)];
    }
    return _customTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createMainUI];
    [self downLoadCustomTable];
}
-(void)createMainUI{
    self.view.backgroundColor = [UIColor colorWithHexString:@"f3f6ff"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.customTableView];
    WeakSelf(WKCustomTabViewController);
    self.customTableView.customTableBlock = ^(NSString *memberId){
        WKCustomDetailViewController *customDetails = [[WKCustomDetailViewController alloc]init];
        customDetails.customCode = memberId;
        for (CustomInnerList *item in weakSelf.model.InnerList) {
            if ([item.MemberNo isEqualToString:memberId]) {
                customDetails.customModel = item;
            }
        }
        [weakSelf.navigationController pushViewController:customDetails animated:YES];
    };
    self.customTableView.requestBlock = ^(){
        [weakSelf downLoadCustomTable];
    };
}
-(void)downLoadCustomTable{
    NSString *urlStr = [NSString configUrl:WKCustomTableMessage With:@[@"PageIndex",@"PageSize"] values:@[[NSString stringWithFormat:@"%lu",(long)self.customTableView.pageNO],[NSString stringWithFormat:@"%lu",(long)self.customTableView.pageSize]]];
    [WKHttpRequest customTableMessage:HttpRequestMethodGet url:urlStr param:nil success:^(WKBaseResponse *response) {
        self.model = [WKCustomTableModel yy_modelWithJSON:response.Data];
        [self.customTableView reloadDataWithArray:self.model.InnerList];
        if (self.model.InnerList.count<1) {
            [self.customTableView setRemindreImageName:@"zanwukehu" text:@"暂无客户信息" offsetY:-50 completion:^{
                
            }];
        }
    } failure:^(WKBaseResponse *response) {
        [self.customTableView setRemindreImageName:@"zanwukehu" text:@"暂无客户信息" offsetY:-50 completion:^{
            
        }];
    }];
}

@end
