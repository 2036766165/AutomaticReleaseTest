//
//  WKEditViewController.m
//  秀加加
//
//  Created by sks on 2017/2/9.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import "WKEditViewController.h"
#import "WKGoodsModel.h"
#import "WKEditGoodsView.h"

@interface WKEditViewController (){
    NSNumber *_goodsCode;
    WKGoodsType _type;
}
@property(nonatomic,strong) WKEditGoodsView *goodsView;

@end

@implementation WKEditViewController

- (instancetype)initWithGoodsCode:(NSNumber *)goodsCode type:(WKGoodsType)type{
    if (self = [super init]) {
        _goodsCode = goodsCode;
        _type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_goodsCode.integerValue == 0) {
        self.title = @"添加商品";
    }else
        self.title = @"编辑商品";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(saveGoods)];

    WKEditGoodsView *editView = [[WKEditGoodsView alloc] initWithFrame:CGRectMake(0, 64, WKScreenW, WKScreenH-64) type:WKGoodsTypeSale];
    [self.view addSubview:editView];
    
    self.goodsView = editView;
    
    if (_goodsCode.integerValue != 0) {
        // 加载商品详情
        [self loadGoodsDetail];
    }
}

// 加载商品详情
- (void)loadGoodsDetail{
    [WKProgressHUD showLoadingGifText:@""];
    
    NSString *url = [NSString configUrl:WKGoodsDetail With:@[@"goodsCode"] values:@[[NSString stringWithFormat:@"%@",_goodsCode]]];
    
    [WKHttpRequest uploadGoods:HttpRequestMethodGet url:url model:@"WKGoodsModel" param:@{} success:^(WKBaseResponse *response) {
        WKGoodsModel *md = (WKGoodsModel *)response.Data;
        self.goodsView.dataModel = md;
        
    } failure:^(WKBaseResponse *response) {
        
    }];
}

#pragma mark - 保存商品
- (void)saveGoods{
    NSDictionary *parameters = [self.goodsView getEditInfo];
    if (parameters) {
        NSLog(@"parametes %@",parameters);
        
        [WKProgressHUD showLoadingGifText:@""];
        NSString *url = _goodsCode.integerValue == 0 ? WKAddGoods : WKGoodsUpdate;
        [WKHttpRequest uploadGoods:HttpRequestMethodPost url:url model:@"WKGoodsModel" param:parameters success:^(WKBaseResponse *response)
         {
             NSLog(@"添加成功");
             if ([_delegate respondsToSelector:@selector(finshEdit)]) {
                 [_delegate finshEdit];
             }
             [self.navigationController popViewControllerAnimated:YES];

//             if (self.finshedBlock) {
//                 [self.navigationController popViewControllerAnimated:YES];
//                 self.finshedBlock();
//             }
             
         } failure:^(WKBaseResponse *response) {
             [WKProgressHUD showTopMessage:response.ResultMessage];
         }];

    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
