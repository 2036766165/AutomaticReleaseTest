//
//  WKAddGoodsViewController.m
//  秀加加
//  添加，编辑 商品/拍卖品
//  Created by sks on 2016/9/13.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKAddGoodsViewController.h"
#import "WKAddGoodsView.h"
#import "WKGoodsModel.h"
#import "WKShowInputView.h"

@interface WKAddGoodsViewController (){
    WKGoodsType _type;
    NSNumber *_goodsCode;
}

@property (nonatomic,strong) WKAddGoodsView *addGoodsView;

@end

@implementation WKAddGoodsViewController

- (instancetype)initWithGoodsCode:(NSNumber *)goodsCode type:(WKGoodsType)type{
    if (self = [super init]) {
        _goodsCode = goodsCode;
        _type = type;
    }
    return self;
}

- (WKAddGoodsView *)addGoodsView{
    if (!_addGoodsView) {
        _addGoodsView = [[WKAddGoodsView alloc] initWithFrame:self.view.bounds type:_type];
        _addGoodsView.oberveVC = self;
    }
    return _addGoodsView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_goodsCode.integerValue != 0) {
        self.title = _type == WKGoodsTypeAuction ? @"编辑拍卖品" : @"编辑商品";
        [self loadGoodsDetail];

    }else{
        self.title = _type == WKGoodsTypeAuction ? @"添加拍卖品" : @"添加商品";
    }
    
    [self.view addSubview:self.addGoodsView];
    
    WeakSelf(WKAddGoodsViewController);
    self.addGoodsView.delegateBlock = ^(NSString *goodsID){
        [weakSelf  goodsDelete:goodsID];
    };
    
    UIBarButtonItem *spaceBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    UIBarButtonItem *backBbi = [UIBarButtonItem itemWithImageName:@"back" highImageName:@"back" target:self action:@selector(back)];
    
    self.navigationItem.leftBarButtonItems = @[spaceBar,backBbi];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(saveGoods)];

}

-(void)goodsDelete:(NSString *)goodsID
{
    [WKProgressHUD showLoadingText:@""];
    NSString *url = [NSString configUrl:WKGoodsDelete With:@[@"goodsID"] values:@[goodsID]];
    [WKHttpRequest goodsDelete:HttpRequestMethodPost url:url param:@{} success:^(WKBaseResponse *response) {
        if(response.ResultCode == 0)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [WKProgressHUD showTopMessage:response.ResultMessage];
        }
    } failure:^(WKBaseResponse *response) {
//        [WKProgressHUD showText:response.ResultMessage];
    }];
}

- (void)back{
    [WKShowInputView showInputWithPlaceString:@"是否退出编辑?" type:LABELTYPE andBlock:^(NSString * Count) {
        [self.navigationController popViewControllerAnimated:YES];    }];
}

//保存商品修改
- (void)saveGoods
{
    NSDictionary *dict = [self.addGoodsView getGoodsInfo];
    if (dict != nil){
        [WKProgressHUD showLoadingGifText:@""];
        NSString *url = _goodsCode.integerValue == 0 ? WKAddGoods : WKGoodsUpdate;
        [WKHttpRequest uploadGoods:HttpRequestMethodPost url:url model:@"WKGoodsModel" param:dict success:^(WKBaseResponse *response)
        {
            if (self.finshedBlock) {
                [self.navigationController popViewControllerAnimated:YES];
                self.finshedBlock();
            }
        } failure:^(WKBaseResponse *response) {
            [WKProgressHUD showTopMessage:response.ResultMessage];
        }];
    }
}

// 加载商品详情
- (void)loadGoodsDetail{
    [WKProgressHUD showLoadingGifText:@""];
    NSString *url = [NSString configUrl:WKGoodsDetail With:@[@"goodsCode"] values:@[[NSString stringWithFormat:@"%@",_goodsCode]]];
    [WKHttpRequest uploadGoods:HttpRequestMethodGet url:url model:@"WKGoodsModel" param:@{} success:^(WKBaseResponse *response) {
        WKGoodsModel *md = (WKGoodsModel *)response.Data;
        self.addGoodsView.dataModel = md;
    } failure:^(WKBaseResponse *response) {
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
