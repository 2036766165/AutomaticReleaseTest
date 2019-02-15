//
//  WKIncomeMoneyView.m
//  秀加加
//
//  Created by Chang_Mac on 16/9/28.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKIncomeMoneyView.h"

@implementation WKIncomeMoneyView

-(instancetype)initWithFrame:(CGRect)frame andMaxMoney:(NSString *)money{
    if (self = [super initWithFrame:frame]) {
        self.maxMoney = money;
        [self initUi];
    }
    return self;
}
-(void)initUi
{
    self.backgroundColor = [UIColor colorWithHexString:@"f3f6ff"];
    UIView *background = [[UIView alloc] init];
    background.backgroundColor = [UIColor whiteColor];
    [self addSubview:background];
    [background mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.top.equalTo(self).offset(74);
        make.height.mas_equalTo(150);
    }];
    
    UILabel *moneyName = [[UILabel alloc] init];
    moneyName.text = @"提现金额";
    moneyName.font = [UIFont systemFontOfSize:14];
    moneyName.textColor = [UIColor colorWithHexString:@"7e879d"];
    [background addSubview:moneyName];
    [moneyName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(background).offset(15);
        make.top.equalTo(background.mas_top).offset(15);
        make.size.mas_equalTo(CGSizeMake(80, 20));
    }];
    
    UILabel *money = [[UILabel alloc] init];
    money.textColor = [UIColor colorWithHex:0x696969];
    money.text = @"￥";
    money.font =[UIFont systemFontOfSize:22];
    [background addSubview:money];
    [money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(background).offset(15);
        make.top.equalTo(moneyName.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(30, 45));
    }];
    
    
    self.moneyField = [[UITextField alloc] init];
    self.moneyField.keyboardType=UIKeyboardTypeDecimalPad;
    [background addSubview:self.moneyField];
    [self.moneyField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(money.mas_right).offset(0);
        make.top.equalTo(moneyName.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(WKScreenW-30-15-15, 45));
    }];
    
    UIView *xianView = [[UIView alloc] init];
    xianView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    [background addSubview:xianView];
    [xianView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(background).offset(15);
        make.top.equalTo(self.moneyField.mas_bottom).offset(0);
        make.size.mas_equalTo(CGSizeMake(WKScreenW-30, 1));
    }];
    
    UILabel *currentMoney = [[UILabel alloc] init];
    NSString *str1 = [NSString stringWithFormat:@"当前可提现余额%0.2f元",[self.maxMoney floatValue]];
    CGSize size = [str1 sizeOfStringWithFont:[UIFont systemFontOfSize:12] withMaxSize:CGSizeMake(MAXFLOAT, 20)];
    currentMoney.text = str1;
    currentMoney.font = [UIFont systemFontOfSize:12];
    currentMoney.textColor = [UIColor colorWithHexString:@"7e879d"];
    [background addSubview:currentMoney];
    //    currentMoney.backgroundColor = [UIColor redColor];
    [currentMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(background).offset(15);
        make.top.equalTo(xianView.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(size.width+10, 20));
    }];
    
    UIButton *button = [[UIButton alloc]init];
    [button setTitle:@"全部提现" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:40/255.0 green:68/255.0 blue:118/255.0 alpha:1] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [background addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(currentMoney.mas_right).offset(0);
        make.top.equalTo(xianView.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(50, 20));
    }];
    
    UIButton *withdrawBtn = [[UIButton alloc] init];
    withdrawBtn.layer.masksToBounds = YES;
    withdrawBtn.backgroundColor = [UIColor colorWithHex:0xFC6620];
    withdrawBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [withdrawBtn setTitle:@"  确认提现" forState:UIControlStateNormal];
    [withdrawBtn setImage:[UIImage imageNamed:@"shouru"] forState:UIControlStateNormal];
    [withdrawBtn addTarget:self action:@selector(withdrawEvent:) forControlEvents:UIControlEventTouchUpInside];;
    [self addSubview:withdrawBtn];
    [withdrawBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(background.mas_bottom).offset(30);
        make.height.mas_equalTo(40);
    }];
    
    UILabel *zhiyi = [[UILabel alloc]init];
    zhiyi.text = @"注意事项:";
    zhiyi.textColor = [UIColor redColor];
    zhiyi.font = [UIFont systemFontOfSize:14];
    [self addSubview:zhiyi];
    [zhiyi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(withdrawBtn.mas_bottom).offset(25);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    
    self.promptLabel = [[UILabel alloc]init];
    NSString *str = [NSString stringWithFormat:@"1.每天可提现一次, 最高提现金额¥2000\n2.提现金额将在48小时内转入微信零钱包,请注意微信通知\n3.如有疑问,请在 “秀加加” 公众号中联系我们"];
    self.promptLabel.numberOfLines = 0;
    self.promptLabel.textColor = [UIColor lightGrayColor];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:10];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
    self.promptLabel.attributedText = attributedString;
    self.promptLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.promptLabel];
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(zhiyi.mas_bottom).offset(10);
        make.width.mas_offset(WKScreenW-20);
        make.height.mas_greaterThanOrEqualTo(50);
    }];
    
    UIView *showView = [[UIView alloc] init];
    showView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [showView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(showView.mas_left).offset(0);
        make.top.equalTo(showView.mas_top).offset(100);
        make.width.mas_equalTo(WKScreenW);
        make.height.mas_equalTo(49);
        
    }];
}
-(void)buttonClick{
    self.moneyField.text = [NSString stringWithFormat:@"%0.2f",[self.maxMoney floatValue]];
}

-(void)withdrawEvent:(UIButton *)sender
{
    if ([self.moneyField.text floatValue] > [self.maxMoney floatValue]) {
        [self MessageShow:@"超过可提现金额数"];
        return;
    }
//    }else if ([self.moneyField.text floatValue] > 2000.00) {
//        [self MessageShow:@"每天提现金额限制2000元"];
//        return;
//    }
//    else if ([self.moneyField.text floatValue] <1.0) {
//        [self MessageShow:@"提现最少限额1元"];
//        return;
//    }
    self.block(self.moneyField.text);
}

-(void)MessageShow:(NSString *)message{
    [WKPromptView showPromptView:message];
}

-(void)refreshPromptMessage:(NSString *)promptStr{
    NSString *str = [NSString stringWithFormat:@"1.每天可提现一次, 最高提现金额¥2000\n2.提现金额将在48小时内转入微信零钱包,请注意微信通知\n3.如有疑问,请在 “秀加加” 公众号中联系我们\n%@",promptStr];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:10];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
    self.promptLabel.attributedText = attributedString;
    [self.promptLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_greaterThanOrEqualTo(50);
    }];
}

@end








