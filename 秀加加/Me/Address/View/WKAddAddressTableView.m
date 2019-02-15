//
//  WKAddAddressTableView.m
//  秀加加
//
//  Created by sks on 2016/9/22.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKAddAddressTableView.h"
#import "WKAddAddressTableViewCell.h"
#import "WKSelectedDistrictView.h"
#import "UITextView+Placeholder.h"

@interface WKAddAddressTableView () <UITableViewDelegate,UITableViewDataSource>{
    NSArray *_titlesArr;
    UITableView *_tableView;
    
    WKAddressModel *_tempModel;
    NSArray *_addressArr;
    
    WKAddressFrom _from;
    
    BOOL _isDefault;
}

@property (nonatomic,strong) UIButton *defaultBtn;
@property (nonatomic,strong) NSMutableArray *cellArr;

@end

@implementation WKAddAddressTableView

- (instancetype)initWithFrame:(CGRect)frame from:(WKAddressFrom)from{
    if (self = [super initWithFrame:frame]) {
        
        _from = from;
        if (_from == WKAddressFromLive) {
            _titlesArr = @[@"收 货 人:",@"手 机 号:",@"所在地区:",@"详细地址:",@"邮政编码:",@"设为默认地址",@"备 注:"];
        }
        else if(_from == WKAddressFromOrder){
            _titlesArr = @[@"收 货 人:",@"手 机 号:",@"所在地区:",@"详细地址:",@"邮政编码:"];
        }
        else{
            _titlesArr = @[@[@"收 货 人:",@"手 机 号:",@"所在地区:",@"详细地址:"],@[@"邮政编码:",@"设为默认地址"],@[@"备 注:"]];
        }
        
        _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _addressArr = @[@"",@"",@""];
        
        self.cellArr = @[].mutableCopy;
        
        _isDefault = NO;
        [self addSubview:_tableView];
        

    }
    
    
    return self;
}

- (void)setOberveView:(UIViewController *)oberveView{
    _oberveView = oberveView;
}

#pragma mark - UITableView delegate/DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_from == WKAddressFromLive || _from == WKAddressFromOrder) {
        return 1;
    }else{
        return _titlesArr.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_from == WKAddressFromLive || _from == WKAddressFromOrder) {
        return _titlesArr.count;
    }else{
        NSArray *sectionArr = _titlesArr[section];
        return sectionArr.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_from == WKAddressFromLive) {
        return 44.0f;
    }else{
        if (indexPath.section == 0 && indexPath.row == 3) {
            return 80.0f;
        }else{
            return 44.0f;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId = [NSString stringWithFormat:@"%zd%zd",indexPath.row,indexPath.section];
    WKAddAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    NSString *title;
    if (_from == WKAddressFromLive || _from == WKAddressFromOrder) {
        title = _titlesArr[indexPath.row];
    }else{
        title = _titlesArr[indexPath.section][indexPath.row];
    }
    
    if (!cell) {
        cell = [[WKAddAddressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
        cell.titleLabel.text = title;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentTextField.hidden = NO;
        cell.contentTextView.hidden = YES;
        
        if ([title isEqualToString:@"所在地区:"] || [title isEqualToString:@"设为默认地址"]) {
            cell.contentTextView.hidden = YES;
            cell.contentTextField.userInteractionEnabled = NO;
        }
        
        if ([title isEqualToString:@"详细地址:"]) {
            cell.contentTextView.hidden = NO;
            cell.contentTextField.hidden = YES;
            cell.contentTextView.placeholder = @"街道,小区";
            
        }
        
        if ([title isEqualToString:@"手 机 号:"] || [title isEqualToString:@"邮政编码:"]) {
            cell.contentTextField.keyboardType = UIKeyboardTypeNumberPad;
        }
        
        if ([title isEqualToString:@"设为默认地址"]) {
           
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setImage:[UIImage imageNamed:@"order_cancel"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"order_open"] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btn];
            btn.tag = 1001;
            self.defaultBtn = btn;
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(cell.contentView.mas_right).offset(-10);
                make.centerY.mas_equalTo(cell.contentView);
                make.size.mas_offset(CGSizeMake(50, 30));
            }];
        }
        
        [self.cellArr addObject:cell];
    }
    
    if ([title isEqualToString:@"所在地区:"]) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.contentTextField.placeholder = @"省,市,县";
        cell.contentTextField.text = [_addressArr componentsJoinedByString:@" "];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 2) {
        
        [WKSelectedDistrictView showWithDefaultProvince:_addressArr[0] city:_addressArr[1] country:_addressArr[2] completion:^(NSArray *arr) {
                     _addressArr = arr;
            [_tableView reloadData];
        }];
    }
}

- (NSDictionary *)getAddressInfo{
//    NSArray *cells = [_tableView visibleCells];

    NSDictionary *parameters = @{
                                 @"收 货 人:":@"Contact",
                                 @"手 机 号:":@"Phone",
                                 @"所在地区:":@"",
                                 @"详细地址:":@"Address",
                                 @"邮政编码:":@"PostCode",
                                 @"设为默认地址":@"IsDefault",
                                 @"备 注:":@"Memo",
                                 @"省份名称":@"ProvinceName",
                                 @"城市名称":@"CityName",
                                 @"区县名称":@"CountyName"
                                 };
    
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    [self endEditing:YES];
    
    NSMutableDictionary *dict = @{}.mutableCopy;
    
    for (WKAddAddressTableViewCell *cell in self.cellArr) {
        
        UILabel *titleLabel = [cell.contentView viewWithTag:101];
        
        if (![titleLabel.text isEqualToString:@"所在地区:"] && ![titleLabel.text isEqualToString:@"设为默认地址"]) {
            NSString *key = parameters[titleLabel.text];
            NSLog(@"title is %@",titleLabel.text);
            
            if ([titleLabel.text isEqualToString:@"详细地址:"]) {
                [dict addEntriesFromDictionary:@{key:cell.contentTextView.text}];
            }else{
                [dict addEntriesFromDictionary:@{key:cell.contentTextField.text}];
            }
        }
    }
    
    NSArray *arr = @[@"ProvinceName",@"CityName",@"CountyName"];
    
    NSDictionary *addressDict = [NSDictionary dictionaryWithObjects:_addressArr forKeys:arr];
    
    [dict addEntriesFromDictionary:addressDict];
    [dict addEntriesFromDictionary:@{@"IsDefault":@(_isDefault)}];
    
    if(((NSString *)dict[@"Contact"]).length == 0 )
    {
        [self promptViewShow:@"请输入收货人！"];
        return nil;
    }
    else
    {
        if(((NSString *)dict[@"Contact"]).length > 12)
        {
            [self promptViewShow:@"收货人限制12个字符！"];
            return nil;
        }
    }
    
    if (![NSString isVaildPhoneNumber:dict[@"Phone"]]) {
        [self promptViewShow:@"请输入正确手机号！"];
        return nil;
    }
    
    if (_addressArr.count != 3) {
        [self promptViewShow:@"请选择正确区域！"];
        return nil;
    }
    else
    {
        for (int i = 0; i< _addressArr.count ; i++) {
            NSString *arr = _addressArr[i];
            if(arr.length == 0)
            {
                [self promptViewShow:@"请输入省市县信息！"];
                return nil;
            }
        }
    }
    
    if(((NSString *)dict[@"Address"]).length == 0)
    {
        [self promptViewShow:@"请输入详细地址！"];
        return nil;
    }
    else
    {
        if(((NSString *)dict[@"Address"]).length > 150)
        {
            [self promptViewShow:@"详细地址限制150个字符！"];
            return nil;
        }
    }
    
    if(((NSString *)dict[@"PostCode"]).length > 0)
    {
        if (![NSString isZipCode:dict[@"PostCode"]]) {
            [self promptViewShow:@"请输入正确邮编！"];
            return nil;
        }
    }
    
    if (((NSString *)dict[@"Memo"]).length > 5) {
        [self promptViewShow:@"备注限制5个字符！"];
        return nil;
    }
    
    if (_tempModel) {
        [dict addEntriesFromDictionary:@{@"AddressID":_tempModel.ID}];
    }

    return  dict;
}

- (void)setDataModel:(WKAddressModel *)model{
    
    _tempModel = model;
    NSDictionary *parameters = @{
                                 @"收货人:":@"Contact",
                                 @"手机号:":@"Phone",
                                 @"所在地区:":@"",
                                 @"详细地址:":@"Address",
                                 @"邮政编码:":@"PostCode",
                                 @"设为默认地址":@"IsDefault",
                                 @"备注:":@"Memo",
                                 @"省份名称":@"ProvinceName",
                                 @"城市名称":@"CityName",
                                 @"区县名称":@"CountyName"
                                 };
    
    for (WKAddAddressTableViewCell *cell in self.cellArr) {
        UILabel *titleLabel = [cell.contentView viewWithTag:101];
        NSString *key = [titleLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        NSString *value = parameters[key];
        
        if (![key isEqualToString:@"所在地区:"] && ![key isEqualToString:@"设为默认地址"]) {
            
            if ([key isEqualToString:@"详细地址:"]) {
                cell.contentTextView.text = [model valueForKeyPath:value];
            }else{
                cell.contentTextField.text = [model valueForKeyPath:value];
            }
        }
    }
    
    // 显示地址
    _addressArr = @[model.ProvinceName,model.CityName,model.CountyName];

    // 显示是否默认
    [self.defaultBtn setSelected:model.IsDefault];
    _isDefault = model.IsDefault;

    [_tableView reloadData];
    
}

- (void)btnClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    _isDefault = btn.selected;
}

-(void)promptViewShow:(NSString *)message{
//    CGRect rect;
//    if (WKScreenH > WKScreenW) {
//        // 竖屏
//        rect = CGRectMake(0, 0, WKScreenW, 40);
//    }else{
//        // 横屏
//        rect = CGRectMake(0, 0, WKScreenH, 40);
//    }
    [WKPromptView showPromptView:message];
}

@end
