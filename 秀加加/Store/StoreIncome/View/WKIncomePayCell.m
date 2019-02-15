//
//  XCIncomePayCell.m
//  秀加加
//
//  Created by Chang_Mac on 17/2/17.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import "WKIncomePayCell.h"

@implementation WKIncomePayCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    self.titleBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 12, WKScreenW-120, 20)];
    [self.titleBtn setTitle:@"开单说明书，早看一秒是优势" forState:UIControlStateNormal];
    self.titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.titleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.titleBtn setTitleColor:[UIColor colorWithHexString:@"7e879d"] forState:UIControlStateNormal];
    [self addSubview:self.titleBtn];
    
    self.detail = [[UILabel alloc] init];
    self.detail.font = [UIFont systemFontOfSize:12];
    [self.detail setTextColor:[UIColor colorWithHex:0xb0b0b0]];
    self.detail.numberOfLines = 0;
    self.detail.text = @"sdfsdfsdfsdfewfwefwefew";
    [self addSubview:self.detail];
    [self.detail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self.titleBtn.mas_bottom).offset(2);
        make.size.mas_equalTo(CGSizeMake(WKScreenW-120,16));
        
    }];
    
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    [self.timeLabel setTextColor:[UIColor colorWithHex:0xb0b0b0]];
    self.timeLabel.text = @"2016-06-13 22:32:32";
    self.timeLabel.numberOfLines = 0;
    [self addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self.detail.mas_bottom).offset(2);
        make.size.mas_equalTo(CGSizeMake(WKScreenW-50,16));
        
    }];
    
    self.money = [[UILabel alloc] init];
    self.money.text = @"+700";
    self.money.textAlignment = NSTextAlignmentRight;
    self.money.font = [UIFont systemFontOfSize:16];
    [self.money setTextColor:[UIColor colorWithHex:0xb0b0b0]];
    [self addSubview:self.money];
    [self.money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(self).offset(27.5);
        make.size.mas_equalTo(CGSizeMake(80, 20));
    }];
    
    self.arrowIM = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"go"]];
    self.arrowIM.hidden = YES;
    [self addSubview:self.arrowIM];
    [self.arrowIM mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(self.money.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(6, 12));
    }];
}

-(void)setModel:(WKPaymentDetailsModel *)model{
    if (_model != model) {
        _model = model;
        NSArray *titleArr = @[@"  商品订单",@"  拍卖订单",@"红包收入",@"提现",@"  系统奖励",@"账户支付",@"账户充值",@"  账户退款",@"  幸运购订单"];
        NSArray *imageArr = @[@"Personal_order_pic",@"Personal_paimai",@"",@"",@"Personal_xitong",@"",@"",@"Personal_xitong",@"Personal_lucky"];
        [self.titleBtn setImage:[UIImage imageNamed:imageArr[model.AccountLogType.integerValue-1]] forState:UIControlStateNormal];
        [self.titleBtn setTitle: titleArr[model.AccountLogType.integerValue-1] forState:UIControlStateNormal];
        self.detail.text = model.LogDescription;
        self.timeLabel.text = model.CreateTime;
        self.money.text = [NSString stringWithFormat:@"¥ %0.2f",model.Amount.floatValue];
        
    }
}









@end
