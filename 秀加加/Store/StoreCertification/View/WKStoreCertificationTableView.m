//
//  WKStoreCertificationTableView.m
//  秀加加
//
//  Created by lin on 16/9/5.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKStoreCertificationTableView.h"
#import "WKStoreCertificationTableViewCell.h"
#import "WKStoreCerMessageTableViewCell.h"
#import "WKAuthShopModel.h"
#import "NSObject+XWAdd.h"
#import "NSObject+WKImagePicker.h"
#import "WKMapViewController.h"
#import "WKStoreCertificationViewController.h"
#import <objc/runtime.h>


@interface WKStoreCertificationTableView() <UITextFieldDelegate> {
    NSInteger _countTime;
    NSTimer *_timer;
    NSInteger _imageType; // 0 营业执照 1 身份证正面 2 身份证反面
}

@property (nonatomic,strong) UIButton *authCodeBtn;
@property (nonatomic,strong) UIButton *confirmBtn;

@property (nonatomic,strong) NSArray *titles;

@property (nonatomic,strong) NSDictionary *dict;

@property (nonatomic,assign) BOOL canBeEdit;
@end

@implementation WKStoreCertificationTableView

@synthesize dataModel = _dataModel;

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame]){
      //  _countTime = 60.0;
        self.canBeEdit = User.ShopAuthenticationStatus == 0?YES:NO;
        self.isOpenHeaderRefresh = NO;
        self.isOpenFooterRefresh = NO;
        self.tableView.showsVerticalScrollIndicator = NO;
//        [self.tableView initWithFrame:frame style:UITableViewStylePlain];
    }
    [self initData];
    return self;
}

- (WKAuthShopModel *)dataModel{
    if (!_dataModel) {
        _dataModel = [[WKAuthShopModel alloc] init];
    }
    return _dataModel;
}

- (void)setDataModel:(WKAuthShopModel *)dataModel{
    _dataModel = dataModel;
    
    if (_dataModel) {
        if (_dataModel.ApproveStatus.integerValue == 0) {
            // 认证中
            [self getReminderViewWith:@"07" type:@"资料审核中" reminder:@"结果24小时内以短信形式发送到你的手机"];
            self.canBeEdit = NO;
        }else if (_dataModel.ApproveStatus.integerValue == 1){
            // 成功
            self.canBeEdit = NO;
            [self getReminderViewWith:@"05" type:@"实体店认证成功" reminder:@"认证店铺更值得信赖!快去维护商品吧!"];
        }else{
            // 失败
            [WKPromptView showPromptView:@"认证失败,请重新提交"];

            self.canBeEdit = YES;
        }
    }else{
        self.canBeEdit = YES;
    }
    
    [self.tableView reloadData];
    
    
}

-(void)initData{
    self.titles = @[@"实体店名:",@"责任人:",@"手机号码:",@"验证码:",@"所在地区:",@"详细地址:"];
    
    self.dict = @{
                                 @"实体店名:":@"ShopName",
                                 @"责任人:":@"ShopLeader",
                                 @"手机号码:":@"LeaderPhone",
                                 @"验证码:":@"CheckCode",
                                 @"所在地区:":@"ProvinceName",
                                 @"详细地址:":@"ShopAddress",
                                 @"营业执照或资格证书":@"ShopLicenses",
                                 @"身份证照正面":@"IDCardFrontPhoto",
                                 @"身份证照反面":@"IDCardBackPhoto"
                                 };

    [self.tableView reloadData];
    
}

- (NSDictionary *)getUploadInfo{
   
    [self endEditing:YES];
    
    NSDictionary *parameters = @{
                           @"ShopName":@"实体店名:",
                           @"ShopLeader":@"责任人:",
                           @"LeaderPhone":@"手机号码:",
                           @"CheckCode":@"验证码:",
                           @"ProvinceName":@"所在地区:",
                           @"ShopAddress":@"详细地址:",
                           @"ShopLicenses":@"营业执照或资格证书",
                           @"IDCardFrontPhoto":@"身份证照正面",
                           @"IDCardBackPhoto":@"身份证照反面"
                           };
    
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList([WKAuthShopModel class], &outCount);
    
    NSMutableDictionary *dict = @{}.mutableCopy;
    
    for (int i=0; i<outCount; i++) {
        objc_property_t p = properties[i];
        const char *n = property_getName(p);
        
        NSString *keyPath = [NSString stringWithUTF8String:n];
        NSString *value = [self.dataModel valueForKeyPath:keyPath];
        if(![keyPath isEqualToString:@"ApproveStatus"]){
        if (value&&![value isEqualToString:@""]) {
            [dict addEntriesFromDictionary:@{keyPath:value}];
        }else{
            NSString *reminderStr = parameters[keyPath];
            [WKPromptView showPromptView:[NSString stringWithFormat:@"%@必填",reminderStr]];
            return nil;
        }
        }
    }
    
    free(properties);
    return dict;
}

#pragma mark - UITableView Delegate/DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return self.titles.count;
    }
    else
        return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"cell";
    WKStoreCertificationTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
    {
        cell = [[WKStoreCertificationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.content.delegate = self;
        cell.name.text = self.titles[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if ([cell.name.text isEqualToString:@"验证码:"]) {
            cell.content.keyboardType = UIKeyboardTypeNumberPad;
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:@"验证" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(getAuthCode:) forControlEvents:UIControlEventTouchUpInside];
            btn.layer.borderColor = [UIColor colorWithHexString:@"#FC6620"].CGColor;
            btn.layer.borderWidth = 1.0;
            btn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
            [btn setTitleColor:[UIColor colorWithHexString:@"#FC6620"] forState:UIControlStateNormal];
            [cell.contentView addSubview:btn];
            self.authCodeBtn = btn;
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(cell.contentView);
                make.right.mas_equalTo(cell.contentView.mas_right).offset(-10);
                make.size.mas_equalTo(CGSizeMake(30, 20));
            }];
        }
        
        if ([cell.name.text isEqualToString:@"手机号码:"]) {
            cell.content.keyboardType = UIKeyboardTypeNumberPad;
            cell.content.text = self.dataModel.LeaderPhone;
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setImage:[UIImage imageNamed:@"login_tipsicon"] forState:UIControlStateNormal];
            [btn setTitle:@"请输入有效手机号" forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
            [btn setTitleColor:[UIColor colorWithHexString:@"#FC6620"] forState:UIControlStateNormal];
            [cell.contentView addSubview:btn];
            self.confirmBtn = btn;
            
            [cell.content addTarget:self action:@selector(phoneNumberChange:) forControlEvents:UIControlEventEditingChanged];
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(cell.contentView);
                make.right.mas_equalTo(cell.contentView.mas_right).offset(10);
                make.size.mas_equalTo(CGSizeMake(130, 20));
            }];
        }
        
        if ([cell.name.text isEqualToString:@"所在地区:"]) {
            cell.content.userInteractionEnabled = NO;
        }
    }
    
    self.authCodeBtn.hidden = !self.canBeEdit;
    self.confirmBtn.hidden = !self.canBeEdit;
    
    if (!self.canBeEdit) {
        if (indexPath.section == 0 && indexPath.row == 3) {
            cell.hidden = YES;
        }
    }
    
    NSString *value = [self.dataModel valueForKeyPath:self.dict[cell.name.text]];
    
    
    if (![cell.name.text isEqualToString:@"所在地区:"]) {
        if (value) {
            cell.content.text = value;
        }
    }else{
        if(![self.dataModel.ProvinceName isEqual:[NSNull null]]&&self.dataModel.ProvinceName!=nil){
        cell.content.text = [NSString stringWithFormat:@"%@ %@ %@",self.dataModel.ProvinceName,self.dataModel.CityName,self.dataModel.CountyName];
        }
    }
    
    NSString *cellIdentifierAdd = @"celladd";
    WKStoreCerMessageTableViewCell  *celladd = [tableView dequeueReusableCellWithIdentifier:cellIdentifierAdd];
    if(!celladd)
    {
        celladd = [[WKStoreCerMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierAdd];
    }
    celladd.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(indexPath.section == 0)
    {
        if(indexPath.row != 4)
        {
            cell.goImageView.hidden = YES;
        }
        else if(indexPath.row == 2)
        {
            cell.content.text = @"街道，小区";
            cell.content.placeholder = @"街道，小区";
        }
        
        return cell;
    }
    else if(indexPath.section == 1)
    {
        celladd.name.text = @"营业执照或资格证书";
        celladd.titleUp.hidden = YES;
        celladd.titleDown.hidden = YES;
        celladd.shenFen.hidden = YES;
        
        if (self.dataModel.ShopLicenses) {
            [celladd.frontShenfen sd_setImageWithURL:[NSURL URLWithString:self.dataModel.ShopLicenses] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"zanwu"]];
        }
        
        celladd.clickPhoto = ^(int type,UIButton *btn)
        {
            _imageType = 0;
            [self captureImageWithtype:_imageType btn:btn];
        };
        return celladd;
    }
    else if(indexPath.section == 2)
    {
        celladd.name.text = @"责任人身份证";
        celladd.titleUp.text = @"身份证照正面";
        celladd.titleDown.text = @"身份证照反面";
        
        if (self.dataModel.IDCardFrontPhoto) {
            [celladd.frontShenfen sd_setImageWithURL:[NSURL URLWithString:self.dataModel.IDCardFrontPhoto] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"zanwu"]];
        }
        
        if (self.dataModel.IDCardBackPhoto) {
            [celladd.shenFen sd_setImageWithURL:[NSURL URLWithString:self.dataModel.IDCardBackPhoto] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"zanwu"]];
        }
        
        celladd.clickPhoto = ^(int type,UIButton *btn)
        {
            if(type == 1){
                _imageType = 1;
            }
            else if(type == 2){
                _imageType = 2;
            }
            
            [self captureImageWithtype:_imageType btn:btn];
        };
        return celladd;
    }else{
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 4) {
        WKMapViewController *mapView = [[WKMapViewController alloc] initWith:0];
        mapView.locationBlock = ^(WKAnnotationTest *anntion){
            self.dataModel.ProvinceName = anntion.province;
            self.dataModel.CityName = anntion.city;
            self.dataModel.CountyName = anntion.country;
            self.dataModel.ShopLong = [NSString stringWithFormat:@"%lf",anntion.coordinate.longitude];
            self.dataModel.ShopLat = [NSString stringWithFormat:@"%lf",anntion.coordinate.latitude];
            self.dataModel.ShopAddress = anntion.street;
            
            WKStoreCertificationTableViewCell *cellDistrict = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
            WKStoreCertificationTableViewCell *cellAddress = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
            cellDistrict.content.text = [NSString stringWithFormat:@"%@ %@ %@",self.dataModel.ProvinceName,self.dataModel.CityName,self.dataModel.CountyName];
            cellAddress.content.text = self.dataModel.ShopAddress;
        };
        
        [self.obserview.navigationController pushViewController:mapView animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        if(indexPath.row == 5)
        {
            return 75;
        }else if (indexPath.row == 3){
            if (!self.canBeEdit) {
                return 0;
            }else
                return 50.0;
        }
        return 50;
    }
    else if(indexPath.section == 1){
        return 160;
    }
    else
        return 180;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WKScreenW, 10)];
    headView.backgroundColor = [UIColor colorWithHex:0xEEF1FB];
    return headView;
}

- (void)phoneNumberChange:(UITextField *)textField{
    NSString *phoneNum = textField.text;
    
    self.dataModel.LeaderPhone = phoneNum;
    if (![NSString isVaildPhoneNumber:phoneNum]) {
        self.confirmBtn.hidden = NO;
    }else{
        self.dataModel.LeaderPhone = phoneNum;
        self.confirmBtn.hidden = YES;
    }
}

#pragma mark - UITextField Delegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    UILabel *lab = [textField.superview viewWithTag:101];
    
    NSDictionary *dict = @{
                           @"实体店名:":@"ShopName",
                           @"责任人:":@"ShopLeader",
                           @"手机号码:":@"LeaderPhone",
                           @"验证码:":@"CheckCode",
//                           @"所在地区:":@"ProvinceName",
                           @"详细地址:":@"ShopAddress"
                           };
    
    [self.dataModel setValue:textField.text forKey:dict[lab.text]];
    
}

//MARK: 选择图片
- (void)captureImageWithtype:(NSInteger)type btn:(UIButton *)btn{
    
    [self captureImageWith:^(UIImage *image) {
        [btn setImage:image forState:UIControlStateNormal];
        
        [WKHttpRequest uploadImages:HttpRequestMethodPost url:WKUploadImage fileArr:@[image] success:^(WKBaseResponse *response) {
            
            NSString *picurl = [((NSArray *)response.Data) firstObject];
            _LOGD(@"picurl is %@",picurl);
            
            if (type == 0) {
                self.dataModel.ShopLicenses = picurl;
            }else if (type == 1){
                self.dataModel.IDCardFrontPhoto = picurl;
            }else{
                self.dataModel.IDCardBackPhoto = picurl;
            }
            
            
        } failure:^(WKBaseResponse *response) {
            
        }];
    }];
}
//MARK: 获取验证码
- (void)getAuthCode:(UIButton *)btn{
    if (![NSString isVaildPhoneNumber:self.dataModel.LeaderPhone]) {
        [WKPromptView showPromptView:@"请输入合法的手机号"];
        return;
    }
    
    NSArray *keys = @[@"PhoneNumber",@"SendType"];
    NSArray *values = @[self.dataModel.LeaderPhone,@"2"];
    
    NSString *url = [NSString configUrl:WKGetAuthCode With:keys values:values];
    
    [WKHttpRequest getAuthCode:HttpRequestMethodPost url:url param:@{} success:^(WKBaseResponse *response) {
        _LOGD(@"%@",response);
        [WKPromptView showPromptView:@"验证码已发送"];
        _countTime=60;
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeCount) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        
    } failure:^(WKBaseResponse *response) {
        
    }];
}

- (void)timeCount{
    
    if (_countTime == 0) {
        [_timer invalidate];
        _timer = nil;
        self.authCodeBtn.userInteractionEnabled = YES;
        [self.authCodeBtn setTitleColor:[UIColor colorWithHexString:@"#FC6620"] forState:UIControlStateNormal];
        self.authCodeBtn.backgroundColor = [UIColor whiteColor];
        [self.authCodeBtn setTitle:@"验证" forState:UIControlStateNormal];

    }else{
         
        --_countTime;
        [self.authCodeBtn setTitle:[NSString stringWithFormat:@"%zd",_countTime] forState:UIControlStateNormal];
        self.authCodeBtn.userInteractionEnabled = NO;
    }
}

- (void)getReminderViewWith:(NSString *)image type:(NSString *)type reminder:(NSString *)reminder{
    
    UIView *preView = [[UIView alloc] initWithFrame:CGRectZero];
    
    preView.backgroundColor = [UIColor blackColor];
    preView.alpha = 0.6;
    [self addSubview:preView];
    
    [preView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(32, 0, -32, 0));
    }];
    
    // 图片
    UIImage *imaged = [UIImage imageNamed:image];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:imaged];
    [preView addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(WKScreenW * 0.4);
        make.centerX.mas_equalTo(preView);
        make.size.mas_equalTo(imaged.size);
    }];
    
    UILabel *typeLab = [[UILabel alloc] init];
    typeLab.font = [UIFont systemFontOfSize:16.0f];
    typeLab.textAlignment = NSTextAlignmentCenter;
    typeLab.textColor = [UIColor whiteColor];
    typeLab.text = type;
    typeLab.backgroundColor = [UIColor clearColor];
    [preView addSubview:typeLab];
    
    [typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imageView.mas_bottom).offset(20);
//        make.left.and.right.mas_equalTo(preView).mas_offset(10);
        make.left.mas_offset(10);
        make.width.mas_offset(WKScreenW - 20);
        make.height.mas_offset(40);
    }];
    
    
    UILabel *reminderlab = [[UILabel alloc] init];
    reminderlab.font = [UIFont systemFontOfSize:14.0f];
    reminderlab.textAlignment = NSTextAlignmentCenter;
    reminderlab.textColor = [UIColor whiteColor];
    reminderlab.text = reminder;
    reminderlab.backgroundColor = [UIColor clearColor];
    [preView addSubview:reminderlab];
    
    [reminderlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(typeLab.mas_bottom).offset(20);
        make.left.and.right.mas_equalTo(preView).mas_offset(10);
        make.height.mas_offset(40);
    }];
    
}

- (void)dealloc{
    [_timer invalidate];
    _timer = nil;
}


@end
