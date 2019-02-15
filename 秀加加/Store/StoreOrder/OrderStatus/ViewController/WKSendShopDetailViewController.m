//
//  WKSendShopDetailViewController.m
//  wdbo
//
//  Created by lin on 16/6/24.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import "WKSendShopDetailViewController.h"
#import "WKSendShopDetailView.h"
#import "WKMessageCenterModel.h"
#import "WKInnerListModel.h"

@interface WKSendShopDetailViewController()

@property (nonatomic,strong) UIView *headView;

@property (nonatomic,strong) WKSendShopDetailView *sendShopDetailVC;

@property (strong, nonatomic) WKMessageCenterModel *model;

@property (strong, nonatomic) UIButton *headBtn;

@property (strong, nonatomic) UILabel *shopStatus;

@property (strong, nonatomic) UILabel *company;

@property (strong, nonatomic) UILabel *number;

@property (strong, nonatomic) WKInnerListModel * innerModel;

@end

@implementation WKSendShopDetailViewController

- (WKSendShopDetailView *)sendShopDetailVC
{
    if (!_sendShopDetailVC) {
        _sendShopDetailVC = [[WKSendShopDetailView alloc] initWithFrame:CGRectMake(0, 0, WKScreenW, WKScreenH - 204)];
    }
    return _sendShopDetailVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initUi];
    [self downloadData];
}

-(void)initUi
{
    self.title = @"物流详情";
    self.view.backgroundColor = [UIColor colorWithHex:0xf0f0f0];
    self.headView = [[UIView alloc] init];
    self.headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.headView];
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.top.equalTo(self.view).offset(74);
        make.height.mas_equalTo(120);
    }];
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor greenColor];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.top.equalTo(self.headView.mas_bottom).offset(10);
        make.height.equalTo(self.view).offset(0);
    }];
    [view addSubview:self.sendShopDetailVC];
    
    self.headBtn = [[UIButton alloc] init];
    [self.headBtn setBackgroundImage:[UIImage imageNamed:@"orderCar"] forState:UIControlStateNormal];
    self.headBtn.userInteractionEnabled = NO;
    [self.headView addSubview:self.headBtn];
    [self.headBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headView).offset(15);
        make.top.equalTo(self.headView).offset(15);
        make.size.mas_equalTo(CGSizeMake(90, 90));
    }];
    
    self.shopStatus = [[UILabel alloc] init];
    self.shopStatus.textColor = [UIColor colorWithHexString:@"7e879d"];
    self.shopStatus.font = [UIFont systemFontOfSize:16];

    NSString *ShipStatus = @"";
    if(self.orderType.integerValue == 0)
    {
        ShipStatus = @"未发货";
    }
    else if(self.orderType.integerValue == 1)
    {
        ShipStatus = @"已发货";
    }
    else if(self.orderType.integerValue == 2)
    {
        ShipStatus = @"配送中";
    }
    else if(self.orderType.integerValue == 3)
    {
        ShipStatus = @"已签收";
    }
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@"物流状态：%@",ShipStatus]];
    
    //颜色
    [attributedStr addAttribute: NSForegroundColorAttributeName value: [UIColor orangeColor] range: NSMakeRange(5, 3)];
    self.shopStatus.attributedText = attributedStr;
    [self.headView addSubview:self.shopStatus];
    [self.shopStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headView).offset(15);
        make.top.equalTo(self.headView).offset(18);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
    
    self.company = [[UILabel alloc] init];
    self.company.text = [NSString stringWithFormat:@"快递单号：%@",self.orderNum];
    self.company.font = [UIFont systemFontOfSize:15];
    self.company.textColor = [UIColor lightGrayColor];
    [self.headView addSubview:self.company];
    [self.company mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headView).offset(15);
        make.top.equalTo(self.shopStatus.mas_bottom).offset(11);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
    
    self.number = [[UILabel alloc] init];
    self.number .text = [NSString stringWithFormat:@"承运公司：%@",self.companyName];
    self.number .font =[UIFont systemFontOfSize:15];
    self.number .textColor = [UIColor lightGrayColor];
    [self.headView addSubview:self.number ];
    [self.number  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headView).offset(15);
        make.top.equalTo(self.company.mas_bottom).offset(11);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
}

-(void)downloadData
{
    NSString *urlStr = [NSString configUrl:WKSendShopDetails With:@[@"orderCode"] values:@[self.orderCode]];
    [WKHttpRequest SendShopDetails:HttpRequestMethodGet url:urlStr param:nil success:^(WKBaseResponse *response) {
        self.innerModel = [WKInnerListModel yy_modelWithDictionary:response.Data];
        self.sendShopDetailVC.model = self.innerModel;
        [self.sendShopDetailVC reloadData];
    } failure:^(WKBaseResponse *response) {
        
    }];
}

@end
