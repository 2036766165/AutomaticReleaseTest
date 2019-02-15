//
//  WKWithDrawApplyForViewController.m
//  wdbo
//
//  Created by lin on 16/6/26.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import "WKWithDrawApplyForViewController.h"
#import "WKStoreIncomeViewController.h"

@interface WKWithDrawApplyForViewController()

@property (nonatomic,strong) UIView *navView;

@end


@implementation WKWithDrawApplyForViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self initUi];
}

-(void)initUi
{
    self.view.backgroundColor = [UIColor colorWithHexString:@"f3f6ff"];
    self.title = @"提现";
    
    UIView *background = [[UIView alloc] init];
    background.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:background];
    [background mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.top.equalTo(self.view).offset(74);
        make.height.mas_equalTo(190);
    }];
    
    UIImage *img = [UIImage imageNamed:@"shenqing"];
    UIImageView *imgView = [[UIImageView alloc] init];
    [imgView setImage:img];
    [background addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(background).offset((WKScreenW-img.size.width)/2);
        make.top.equalTo(background).offset(25);
        make.size.mas_equalTo(CGSizeMake(img.size.width, img.size.height));
    }];
    
    UILabel *name = [[UILabel alloc] init];
    name.text = @"提现申请已提交";
    name.textAlignment = NSTextAlignmentCenter;
    name.font = [UIFont systemFontOfSize:14];
    name.textColor = [UIColor colorWithHexString:@"7e879d"];
    [background addSubview:name];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(background).offset((WKScreenW-200)/2);
        make.top.equalTo(imgView.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
    
    UILabel *currentMoney = [[UILabel alloc] init];
    NSString *str = @"预计48小时内转入微信零钱包,请注意微信通知";
    NSMutableAttributedString *attributedStr01 = [[NSMutableAttributedString alloc] initWithString: str];
    //颜色
    [attributedStr01 addAttribute: NSForegroundColorAttributeName value: [UIColor orangeColor] range: NSMakeRange(0, 4)];
    currentMoney.attributedText= attributedStr01;
    currentMoney.font = [UIFont systemFontOfSize:11];
    currentMoney.textAlignment = NSTextAlignmentCenter;
    currentMoney.textColor = [UIColor colorWithHexString:@"7e879d"];
    [background addSubview:currentMoney];
    [currentMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(background).offset(15);
        make.top.equalTo(name.mas_bottom).offset(7);
        make.size.mas_equalTo(CGSizeMake(WKScreenW-30, 15));
    }];
    
    UIView *xianView = [[UIView alloc] init];
    xianView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    [background addSubview:xianView];
    [xianView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(background).offset(0);
        make.top.equalTo(currentMoney.mas_bottom).offset(18);
        make.size.mas_equalTo(CGSizeMake(WKScreenW, 1));
    }];
    
    UILabel *moneyName = [[UILabel alloc] init];
    moneyName.text = @"提现金额";
    moneyName.font = [UIFont systemFontOfSize:12];
    moneyName.textColor = [UIColor colorWithHexString:@"7e879d"];
    [background addSubview:moneyName];
    [moneyName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(background).offset(15);
        make.top.equalTo(xianView.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(100, 20));

    }];
    
    UILabel *money = [[UILabel alloc] init];
    money.textColor = [UIColor colorWithHex:0xBBBBBB];
    money.textAlignment = NSTextAlignmentRight;
    money.font =[UIFont systemFontOfSize:12];
    money.text = [NSString stringWithFormat:@"¥%0.2f",[self.moneyStr floatValue]];
    [background addSubview:money];
    [money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(background.mas_right).offset(-25);
        make.top.equalTo(xianView.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
    
    UIButton *okBtn = [[UIButton alloc] init];
    okBtn.layer.masksToBounds = YES;
    okBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    okBtn.backgroundColor = [UIColor colorWithHex:0xFC6620];
    [okBtn setTitle:@"确认" forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(okEvent:) forControlEvents:UIControlEventTouchUpInside];;
    [self.view addSubview:okBtn];
    [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.top.equalTo(background.mas_bottom).offset(35);
        make.height.mas_equalTo(40);
    }];
}

-(void)backEvent
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)back:(UITapGestureRecognizer *)gesture
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)okEvent:(UIButton *)sender
{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[WKStoreIncomeViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
    
}

@end
