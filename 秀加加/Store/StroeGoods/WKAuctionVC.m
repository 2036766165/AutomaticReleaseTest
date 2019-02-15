//
//  WKAuctionVC.m
//  秀加加
//
//  Created by sks on 2016/9/6.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKAuctionVC.h"
#import "WKGoodsListView.h"
#import "WKGoodsBottomView.h"
#import "WKGoodsModel.h"
#import "WKAddGoodsViewController.h"
#import "WKGoodsPatchViewController.h"

@interface WKAuctionVC () <WKGoodsBottomDelegate>

@property (nonatomic,strong) WKGoodsListView *listView;
@property (nonatomic,strong) WKGoodsBottomView *bottomView;
@end

@implementation WKAuctionVC

- (WKGoodsListView *)listView
{
    if (!_listView) {
        _listView = [[WKGoodsListView alloc] initWithFrame:CGRectMake(0, 0, WKScreenW, self.view.frame.size.height-50-64) with:WKGoodsTypeAuction];
        
        WeakSelf(WKAuctionVC);
        _listView.selectedIndex = ^(NSInteger index){
            WKGoodsListItem *item = weakSelf.listView.dataArray[index];
            WKAddGoodsViewController *addGoods = [[WKAddGoodsViewController alloc] initWithGoodsCode:item.GoodsCode type:WKGoodsTypeAuction];
            addGoods.finshedBlock = ^(){
                [weakSelf.listView.tableView.mj_header beginRefreshing];
            };
            [weakSelf.navigationController pushViewController:addGoods animated:YES];
        };
    }
    return _listView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.listView];
    
    NSArray *titles = @[@"添加拍卖品"];
    self.bottomView = [[WKGoodsBottomView alloc] initWithFrame:CGRectZero titles:titles type:WKGoodsTypeSale];
    self.bottomView.delegate = self;
    self.bottomView.hidden = YES;
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.and.bottom.mas_equalTo(self.view);
        make.height.mas_offset(50);
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    WeakSelf(WKAuctionVC);
    self.listView.requestBlock = ^(){
        [weakSelf loadGoodsList];
    };
    
    [self.listView.tableView.mj_header beginRefreshing];
}

// 加载商品
- (void)loadGoodsList{
    
    NSDictionary *parameters = @{
                                 @"IsAuction":@"true",
                                 @"PageIndex":@(self.listView.pageNO),
                                 @"PageSize":@(self.listView.pageSize)
                                 };
    
    [WKHttpRequest getGoodsList:HttpRequestMethodPost url:WKGoodsList model:NSStringFromClass([WKGoodsListModel class]) param:parameters success:^(WKBaseResponse *response) {
        
        WKGoodsListModel *goodsModel = response.Data;
        [self.listView reloadDataWithArray:goodsModel.InnerList];
        
        if (self.listView.dataArray.count == 0)
        {
            self.bottomView.hidden = YES;
            
            WeakSelf(WKAuctionVC);
            [self.listView setRemindreImageName:@"pro_add" text:@"添加新拍卖品" completion:^{
                WKAddGoodsViewController *addGoods = [[WKAddGoodsViewController alloc] initWithGoodsCode:@0 type:WKGoodsTypeAuction];
                addGoods.finshedBlock = ^(){
                    [weakSelf.listView.tableView.mj_header beginRefreshing];
                };
                [weakSelf.navigationController pushViewController:addGoods animated:YES];
            }];
        }
        else
        {
            self.bottomView.hidden = NO;
        }

    } failure:^(WKBaseResponse *response) {
        WeakSelf(WKAuctionVC);
        [self.listView setRemindreImageName:@"" text:@"加载失败" completion:^{
            [weakSelf loadGoodsList];
        }];
        [self.listView endRefreshing];
    }];
}

// 底部点击
- (void)goodsBottomType:(WKGoodsManage)type{
    if (type == WKGoodsManagePatch) {
        WKGoodsPatchViewController *goodsPatch = [[WKGoodsPatchViewController alloc] initWith:WKGoodsTypeAuction];
        [self.navigationController pushViewController:goodsPatch animated:YES];
    }else{
        WKAddGoodsViewController *addGoods = [[WKAddGoodsViewController alloc] initWithGoodsCode:@0 type:WKGoodsTypeAuction];
        addGoods.finshedBlock = ^(){
            [self.listView.tableView.mj_header beginRefreshing];
        };
        [self.navigationController pushViewController:addGoods animated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
