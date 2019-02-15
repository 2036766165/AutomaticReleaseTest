//
//  WKAddaddressViewController.m
//  秀加加
//
//  Created by sks on 2016/9/22.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKAddaddressViewController.h"
#import "WKAddAddressTableView.h"
#import "WKAddressModel.h"

@interface WKAddaddressViewController (){
    NSString *_ID;
    WKAddressEditType _type;
    WKAddressFrom _from;
}

@property (nonatomic,strong) WKAddAddressTableView *inputList;

@end

@implementation WKAddaddressViewController

- (instancetype)initWithID:(NSString *)ID type:(WKAddressEditType)type from:(WKAddressFrom)from{
    if (self = [super init]) {
        _ID = ID;
        _type = type;
        _from = from;
    }
    return self;
}

- (WKAddAddressTableView *)inputList{
    if (!_inputList) {
        CGRect rect;
        
        CGFloat width;
        CGFloat height;
        if (WKScreenH > WKScreenW) {
            // 竖屏
            width = self.view.frame.size.width;
            height = 44 * 10;
        }else{
            // 横屏
            width = WKScreenH;
            height = WKScreenH;
        }
        
        if (_from == WKAddressFromLive) {
            rect = CGRectMake(0, 25, width, height);
        }else{
            rect = CGRectMake(0, 32, WKScreenW, WKScreenH);
        }
        
        _inputList = [[WKAddAddressTableView alloc] initWithFrame:rect from:_from];
        _inputList.oberveView = self;
    }
    return _inputList;
}

- (WKAddressModel *)dataModel{
    if (!_dataModel) {
        _dataModel = [[WKAddressModel alloc] init];
    }
    return _dataModel;
}

- (instancetype)initWithID:(NSString *)ID{
    if (self = [super init]) {
        _ID = ID;
    }
    return self;
}

//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    
//    if (_from == WKAddressFromLive) {
//        IQKeyboardManager *kbMg = [IQKeyboardManager sharedManager];
//        kbMg.enableAutoToolbar = NO;
//    }
//    NSLog(@"123");
//}
//
//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    if (_from == WKAddressFromLive) {
//        IQKeyboardManager *kbMg = [IQKeyboardManager sharedManager];
//        kbMg.enableAutoToolbar = YES;
//    }
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加地址";
    if (_type == WKAddressEditTypeEditDistrict){
        self.title = @"修改地址";
    }
    self.dataModel.ID = _ID;
    
    if (![_ID isEqualToString:@"0"]) {
        [self getAddress];
    }else{
        if (_type == WKAddressEditTypeEditDistrict) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.inputList setDataModel:self.dataModel];
            });
        }
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(addAddress)];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.inputList];
}

- (void)addAddress{
    
    NSDictionary *parameters = [self.inputList getAddressInfo];
    
    if (_type == WKAddressEditTypeEditDistrict) {
        if (parameters != nil) {
            if (self.AddSuccess) {
                self.AddSuccess(parameters);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }else{
        
        if (parameters != nil) {
            NSString *url;
            if ([_ID isEqualToString:@"0"]) {
                url = WKAddressAdd;
            }else{
                url = WKAddressUpdate;
            }
            
            [WKHttpRequest addressAdd:HttpRequestMethodPost url:url para:parameters success:^(WKBaseResponse *response) {
                if (self.AddSuccess) {
                    self.AddSuccess(parameters);
                }
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(WKBaseResponse *response) {
                [WKProgressHUD showTopMessage:response.ResultMessage];
                [self.inputList promptViewShow:response.ResultMessage];
            }];
        }
    }
}

- (void)getAddress{
    
    NSString *url = [NSString configUrl:WKAddressDetail With:@[@"ID"] values:@[_ID]];
    [WKHttpRequest getAddreddInfo:HttpRequestMethodGet url:url model:NSStringFromClass([WKAddressModel class]) para:@{} success:^(WKBaseResponse *response) {
        NSLog(@"response : %@",response);
        self.dataModel = response.Data;
        [self.inputList setDataModel:self.dataModel];
        
    } failure:^(WKBaseResponse *response) {
        
    }];
    
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
