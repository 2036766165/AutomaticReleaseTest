//
//  WKGoodsPatchViewController.m
//  秀加加
//
//  Created by sks on 2016/9/13.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKGoodsPatchViewController.h"
#import "WKGoodsBottomView.h"
#import "WKBatchListView.h"
#import "WKGoodsModel.h"
#import "WKShowInputView.h"

@interface WKGoodsPatchViewController () <WKGoodsBottomDelegate>{
    WKGoodsType _type;
}

@property (nonatomic,strong) WKBatchListView *batchListView;

@end

@implementation WKGoodsPatchViewController

- (instancetype)initWith:(WKGoodsType)type{
    if (self = [super init]) {
        _type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 批量管理
    self.title = @"批量管理";
    // 列表
    self.batchListView = [[WKBatchListView alloc] initWithFrame:CGRectMake(0, 32, WKScreenW, WKScreenH - 50) with:WKGoodsTypeNormal];
    [self.view addSubview:self.batchListView];
    
    // 底部
    NSArray *titles = @[@"上架",@"下架"];
    
    WKGoodsBottomView *bottomView = [[WKGoodsBottomView alloc] initWithFrame:CGRectZero titles:titles type:WKGoodsTypeSale];
    bottomView.delegate = self;
    [self.view addSubview:bottomView];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.and.bottom.mas_equalTo(self.view);
        make.height.mas_offset(50);
    }];
    
    WeakSelf(WKGoodsPatchViewController);
    self.batchListView.requestBlock = ^(){
        [weakSelf loadGoodsList];
    };
    
    [self.batchListView.tableView.mj_header beginRefreshing];
}

- (void)loadGoodsList{
    
    NSDictionary *parameters = @{
                                 @"IsAuction":_type==WKGoodsTypeSale?@"false":@"true",
                                 @"PageIndex":@(self.batchListView.pageNO),
                                 @"PageSize":@(self.batchListView.pageSize)
                                 };
    
    [WKHttpRequest getGoodsList:HttpRequestMethodPost url:WKGoodsList model:NSStringFromClass([WKGoodsListModel class]) param:parameters success:^(WKBaseResponse *response) {
        
        WKGoodsListModel *goodsModel = response.Data;
        
        [self.batchListView reloadDataWithArray:goodsModel.InnerList];
        
        if (self.batchListView.isEmpty) {
            [self.batchListView setRemindreImageName:@"" text:@"没有商品" completion:^{
                _LOGD(@"没有商品");
            }];
        }
        
    } failure:^(WKBaseResponse *response) {
        WeakSelf(WKGoodsPatchViewController);
        [self.batchListView setRemindreImageName:@"pro_add" text:@"加载失败" completion:^{
            [weakSelf loadGoodsList];
        }];
    }];
}

#pragma mark - Delegate
- (void)goodsBottomType:(WKGoodsManage)type{
    NSString *url;
    NSString *Msg = @"";

    if (type == WKGoodsManagePatch) {
        url = WKGoodsBatchUp;
        Msg = @"是否确认上架商品？";
        // 上架
    }else{
        // 下架
        url = WKGoodsBatchDown;
         Msg = @"是否确认下架商品？";
    }
    
    NSArray *arr = [self.batchListView getSelectedArr];
    
    if (arr.count == 0) {
        [WKPromptView showPromptView:@"至少选择一个商品"];
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"GoodsCodes":[arr yy_modelToJSONString]
                                 };
    [WKShowInputView showInputWithPlaceString:Msg type:LABELTYPE andBlock:^(NSString * Count) {
   
    [WKHttpRequest goodsBatch:HttpRequestMethodPost url:url param:parameters success:^(WKBaseResponse *response) {
        [WKPromptView showPromptView:response.ResultMessage];
        [self.batchListView resetSelectedArr];
        [self.batchListView reloadData];
    } failure:^(WKBaseResponse *response) {
        WeakSelf(WKGoodsPatchViewController);
        [self.batchListView setRemindreImageName:@"" text:@"加载失败" completion:^{
            [weakSelf loadGoodsList];
        }];
        [self.batchListView endRefreshing];
    }];
         }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
