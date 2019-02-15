//
//  WKAddressViewController.m
//  秀加加
//
//  Created by lin on 16/8/30.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKAddressViewController.h"
#import "WKAddressTableView.h"
#import "WKAddaddressViewController.h"
#import "WKAddressModel.h"

@interface WKAddressViewController()<WKGoodsItemProtocol>{
    BOOL _isEdit;
    WKAddressFrom _from;
}

@property (nonatomic,strong) WKAddressTableView *addressTableView;
@property (nonatomic,strong) UIButton *deleteBtn;
@property (nonatomic,strong) UIView *downView;
@property (nonatomic,assign) WKAddressFrom from;

@end

@implementation WKAddressViewController

- (instancetype)initWithFrom:(WKAddressFrom)from{
    if (self = [super init]) {
        self.from = from;
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    _isEdit = NO;
    
    if (_from != WKAddressFromLive) {
        self.title = @"地址管理";
        self.view.backgroundColor = [UIColor whiteColor];

        UIBarButtonItem *item0 = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(bbiClick:)];
        item0.tag = 1002;
        self.navigationItem.rightBarButtonItem = item0;

    }else{
        self.view.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];

        UIBarButtonItem *leftBBI = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(bbiClick:)];
        leftBBI.tag = 1000;
        self.navigationItem.leftBarButtonItem = leftBBI;

        UIBarButtonItem *item0 = [[UIBarButtonItem alloc] initWithTitle:@"新建" style:UIBarButtonItemStylePlain target:self action:@selector(bbiClick:)];
        item0.tag = 1001;
        
        UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(bbiClick:)];
        item1.tag = 1002;
        self.navigationItem.rightBarButtonItems = @[item1,item0];
    }
    
    [self.view addSubview:self.addressTableView];

    [self addDownView];
        
    WeakSelf(WKAddressViewController);
    self.addressTableView.requestBlock = ^(){
        [weakSelf loadAddress];
    };
    
    [self.addressTableView.tableView.mj_header beginRefreshing];
}

- (WKAddressTableView *)addressTableView
{
    if (!_addressTableView) {
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
            rect = CGRectMake(0, 32, self.view.frame.size.width, self.view.frame.size.height - 64);
        }

        
//        if (_from == WKAddressFromLive) {
//            
//            rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//        }else{
//            rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 55);
//        }
        _addressTableView = [[WKAddressTableView alloc] initWithFrame:rect];
        _addressTableView.delegate = self;
    }
    return _addressTableView;
}

-(void)addDownView
{
    UIView *downView = [[UIView alloc] init];
    downView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:downView];
    
    [downView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.height.mas_equalTo(55);
    }];
    
    UIButton *newAddressBtn = [[UIButton alloc] init];
    newAddressBtn.layer.cornerRadius = 4.0;
    newAddressBtn.layer.masksToBounds = YES;
    newAddressBtn.backgroundColor = [UIColor colorWithHex:0xFC6621];
    [newAddressBtn setTitle:@"+  新建地址" forState:UIControlStateNormal];
    [newAddressBtn addTarget:self action:@selector(newAddressEvent) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:newAddressBtn];
    [newAddressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(downView).offset(15);
        make.right.equalTo(downView.mas_right).offset(-15);
        make.top.equalTo(downView).offset(5);
        make.bottom.equalTo(downView.mas_bottom).offset(-5);
    }];
    self.deleteBtn = newAddressBtn;
    self.downView = downView;
    
    if (_from == WKAddressFromLive) {
        downView.hidden = YES;
    }
}

-(void)newAddressEvent
{
    if (_isEdit) {
        NSArray *arr = [self.addressTableView getSelectedArr];
        
        if (arr.count == 0) {
            [WKProgressHUD showTopMessage:@"请选择一个地址"];
            return;
        }
        
        [self deleteWith:arr];
        
    }else{
        WKAddaddressViewController *addAddress = [[WKAddaddressViewController alloc] initWithID:@"0" type:WKAddressEditTypeAdd from:_from];
        addAddress.AddSuccess = ^(NSDictionary* a){
            [self.addressTableView.tableView.mj_header beginRefreshing];
        };
        [self.navigationController pushViewController:addAddress animated:YES];
    }
}

-(void)editEvent:(UIButton *)btn{
    _isEdit = !_isEdit;
    self.addressTableView.isEidt = _isEdit;

    if (_isEdit) {
        [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    }else{
        [self.deleteBtn setTitle:@"+  新建地址" forState:UIControlStateNormal];
    }
}

- (void)bbiClick:(UIBarButtonItem *)bbi{
    
    if (bbi.tag == 1000) {
        // 移除地址视图
        if ([_delegate respondsToSelector:@selector(leaveAddressList)]) {
            [_delegate leaveAddressList];
        }
    }else if (bbi.tag == 1001) {
        // 新建
        WKAddaddressViewController *addAddress = [[WKAddaddressViewController alloc] initWithID:@"0" type:WKAddressEditTypeAdd from:self.from];
        addAddress.AddSuccess = ^(NSDictionary* a){
            [self.addressTableView.tableView.mj_header beginRefreshing];
        };
        [self.navigationController pushViewController:addAddress animated:YES];
        
    }else{
        // 编辑
        _isEdit = !_isEdit;
        self.addressTableView.isEidt = _isEdit;
        
        if (_isEdit) {
            
            if (_from == WKAddressFromLive) {
                self.downView.hidden = NO;
                self.addressTableView.frame = CGRectMake(0, 0, WKScreenW, WKScreenH - 55);
            }
            [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
            
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(bbiClick:)];
        }else{
            
            if (_from == WKAddressFromLive) {
                self.downView.hidden = YES;
                self.addressTableView.frame = CGRectMake(0, 0, WKScreenW, WKScreenH);
            }
            
            [self.deleteBtn setTitle:@"+  新建地址" forState:UIControlStateNormal];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(bbiClick:)];
        }
    }
}
// MARK: 加载地址列表
- (void)loadAddress{
    
    [WKHttpRequest  getAddress:HttpRequestMethodGet url:WKAddresssList model:NSStringFromClass([WKAddressListModel class]) param:@{} success:^(WKBaseResponse *response) {
        _LOGD(@"response : %@",response);
        WKAddressListModel *md = response.Data;
        [self.addressTableView reloadDataWithArray:md.InnerList];
        
        if (self.addressTableView.dataArray.count == 0) {
            
            if (_from == WKAddressFromLive) {
                // 跳转添加
                WKAddaddressViewController *addAddress = [[WKAddaddressViewController alloc] initWithID:@"0" type:WKAddressEditTypeAdd from:self.from];
                addAddress.AddSuccess = ^(NSDictionary* a){
                    [self.addressTableView.tableView.mj_header beginRefreshing];
                };
                [self.navigationController pushViewController:addAddress animated:YES];
            }else{
                WeakSelf(WKAddressViewController);
                [self.addressTableView setRemindreImageName:@"pro_add" text:@"添加地址" completion:^{
                    WKAddaddressViewController *addAddress = [[WKAddaddressViewController alloc] initWithID:@"0" type:WKAddressEditTypeAdd from:weakSelf.from];
                    addAddress.AddSuccess = ^(NSDictionary* a){
                        [weakSelf.addressTableView.tableView.mj_header beginRefreshing];
                    };
                    
                    [weakSelf.navigationController pushViewController:addAddress animated:YES];
                }];
            }
        }
        
    } failure:^(WKBaseResponse *response) {
        
    }];
}

- (void)operateGoods:(WKOperateType)type obj:(id)model{
    
    if (type == WKOperateTypeDelete) {
        [self deleteWith:model];
    }else if (type == WKOperateTypeDetail){
        
        // 选择了地址
        if (_from == WKAddressFromLive) {
            if ([_delegate respondsToSelector:@selector(selectedAddress:)]) {
                [_delegate selectedAddress:model];
            }
        }else if (_from == WKAddressFromCenter){
            WKAddressListItem *item = (WKAddressListItem *)model;
            WKAddaddressViewController *addAddress = [[WKAddaddressViewController alloc] initWithID:item.ID type:WKAddressEditTypeAdd from:self.from];
            addAddress.AddSuccess = ^(NSDictionary* a){
                [self.addressTableView.tableView.mj_header beginRefreshing];
            };
            
            [self.navigationController pushViewController:addAddress animated:YES];
        }else{
            if ([_delegate respondsToSelector:@selector(selectedAddress:)]) {
                [_delegate selectedAddress:model];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }else if (type == WKOperateTypeEdit){
        WKAddressListItem *item = (WKAddressListItem *)model;
        WKAddaddressViewController *addAddress = [[WKAddaddressViewController alloc] initWithID:item.ID type:WKAddressEditTypeAdd from:self.from];
        addAddress.AddSuccess = ^(NSDictionary* a){
            [self.addressTableView.tableView.mj_header beginRefreshing];
        };
        
        [self.navigationController pushViewController:addAddress animated:YES];
    }
}

// 删除地址
- (void)deleteWith:(NSArray *)arr{

    NSString *str;
    if (arr.count == 1) {
        str = [arr firstObject];
    }else
        str = [arr componentsJoinedByString:@","];
    
    NSString *url = [NSString configUrl:WKAddressDelete With:@[@"AddressIDs"] values:@[str]];
    
    [WKHttpRequest addressDelete:HttpRequestMethodPost url:url para:@{} success:^(WKBaseResponse *response) {
        
        for (int i=0; i<arr.count; i++) {
            NSString *itemID = arr[i];

            for (int j=0; j<self.addressTableView.dataArray.count; j++) {
                WKAddressListItem *item = self.addressTableView.dataArray[j];
                if ([item.ID isEqualToString:itemID]) {
                    [self.addressTableView.dataArray removeObject:item];
                    
                    if (self.addressTableView.dataArray.count == 0) {
                        [self loadAddress];
                        break;
                    }
                }
            }
        }
        
        [self.addressTableView reloadData];

    } failure:^(WKBaseResponse *response) {
        
    }];
}


@end
