//
//  WKGoodsVC.m
//  秀加加
//  商品列表页
//  Created by sks on 2016/9/6.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKGoodsVC.h"
#import "WKAddGoodsViewController.h"
#import "WKGoodsModel.h"
#import "WKGoodsPatchViewController.h"
#import "WKGoodsListView.h"
#import "WKGoodsBottomView.h"
#import "WKEditViewController.h"
#import "WKStoreCarriageView.h"

@interface WKGoodsVC () <WKGoodsBottomDelegate,WKAddFinshDelegate>
@property (nonatomic,strong) WKGoodsListView *listView;
@property (nonatomic,strong) WKGoodsBottomView *bottomView;
@end

@implementation WKGoodsVC

- (WKGoodsListView *)listView
{
    if (!_listView) {
        _listView = [[WKGoodsListView alloc] initWithFrame:CGRectMake(0, 32, WKScreenW, self.view.frame.size.height-50-64) with:WKGoodsTypeSale];
        WeakSelf(WKGoodsVC);
        
        _listView.selectedIndex = ^(NSInteger index){
            WKGoodsListItem *item = weakSelf.listView.dataArray[index];
            //WKAddGoodsViewController *addGoods = [[WKAddGoodsViewController alloc] initWithGoodsCode:item.GoodsCode type:WKGoodsTypeSale];
//            addGoods.finshedBlock = ^(){
//                [weakSelf.listView.tableView.mj_header beginRefreshing];
//            };
            WKEditViewController *editVC = [[WKEditViewController alloc] initWithGoodsCode:item.GoodsCode type:WKGoodsTypeSale];
            editVC.delegate = weakSelf;
            [weakSelf.navigationController pushViewController:editVC animated:YES];

        };
    }

    return _listView;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.listView.tableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品";
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"运费" style:UIBarButtonItemStylePlain target:self action:@selector(addFreeAction)];
    //加载列表
    [self.view addSubview:self.listView];
    
    WeakSelf(WKGoodsVC);
    self.listView.requestBlock = ^(){
        [weakSelf loadGoodsList];
    };
    //[self.listView.tableView.mj_header beginRefreshing];
    
    //加载按钮
    NSArray *titles = @[@"批量管理",@"添加新商品"];
    self.bottomView = [[WKGoodsBottomView alloc] initWithFrame:CGRectZero titles:titles type:WKGoodsTypeSale];
    self.bottomView.delegate = self;
    self.bottomView.hidden = YES;
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.and.bottom.mas_equalTo(self.view);
        make.height.mas_offset(50);
    }];
    
}

-(void)addFreeAction{
    WKStoreCarriageView* storeCarView = [[WKStoreCarriageView alloc] initWithFrame:CGRectMake(0, 0, WKScreenW, WKScreenH)];
    
    storeCarView.tranFeeBlock =^(NSString *string){
        
        [[NSUserDefaults standardUserDefaults] setObject:string forKey:@"feeNum"];
    };
    if([storeCarView.money.text isEqualToString:@""])
    {
        storeCarView.money.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"feeNum"];
    }
    [[UIApplication sharedApplication].keyWindow addSubview:storeCarView];
}

//-(void)viewWillAppear:(BOOL)animated
//{
//
//}

- (void)loadGoodsList{
    NSDictionary *parameters = @{
                                 @"PageIndex":@(self.listView.pageNO),
                                 @"PageSize":@(self.listView.pageSize)
                                 };
    
    [WKHttpRequest getGoodsList:HttpRequestMethodPost url:WKGoodsList model:NSStringFromClass([WKGoodsListModel class]) param:parameters success:^(WKBaseResponse *response) {
        
        WKGoodsListModel *goodsModel = response.Data;
        [self.listView reloadDataWithArray:goodsModel.InnerList];
        
        //如果为空，加载添加商品按钮
        if (self.listView.dataArray.count == 0)
        {
            self.bottomView.hidden = YES;
            
            WeakSelf(WKGoodsVC);
            [self.listView setRemindreImageName:@"pro_add" text:@"添加新商品" completion:^{
                
                WKEditViewController *editVC = [[WKEditViewController alloc] initWithGoodsCode:@0 type:WKGoodsTypeSale];
                editVC.delegate = weakSelf;
                [weakSelf.navigationController pushViewController:editVC animated:YES];
//                WKAddGoodsViewController *addGoods = [[WKAddGoodsViewController alloc] init];
//                addGoods.finshedBlock = ^(){
//                    [weakSelf.listView.tableView.mj_header beginRefreshing];
//                };
//                [weakSelf.navigationController pushViewController:addGoods animated:YES];
            }];
        }
        else
        {
            self.bottomView.hidden = NO;
        }
    } failure:^(WKBaseResponse *response) {
        WeakSelf(WKGoodsVC);
        [self.listView setRemindreImageName:@"" text:@"加载失败" completion:^{
            [weakSelf loadGoodsList];
        }];
        [self.listView endRefreshing];
    }];
}

- (void)finshEdit{
    [self.listView.tableView.mj_header beginRefreshing];
}

// 底部点击
- (void)goodsBottomType:(WKGoodsManage)type{
    if (type == WKGoodsManagePatch) {
        WKGoodsPatchViewController *goodsPatch = [[WKGoodsPatchViewController alloc] initWith:WKGoodsTypeSale];
        [self.navigationController pushViewController:goodsPatch animated:YES];
    }else{
        WKEditViewController *addGoods = [[WKEditViewController alloc] initWithGoodsCode:@0 type:WKGoodsTypeSale];
        addGoods.delegate = self;
//        addGoods.finshedBlock = ^(){
//            [self.listView.tableView.mj_header beginRefreshing];
//        };
        [self.navigationController pushViewController:addGoods animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
