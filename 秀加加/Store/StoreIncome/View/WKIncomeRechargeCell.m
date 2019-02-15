//
//  WKIncomeRechargeCell.m
//  秀加加
//
//  Created by Chang_Mac on 17/2/17.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import "WKIncomeRechargeCell.h"

@implementation WKIncomeRechargeCell

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
    
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    [self.timeLabel setTextColor:[UIColor colorWithHex:0xb0b0b0]];
    self.timeLabel.text = @"2016-06-13 22:32:32";
    self.timeLabel.numberOfLines = 0;
    [self addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self.titleBtn.mas_bottom).offset(8);
        make.size.mas_equalTo(CGSizeMake(WKScreenW-50,16));
        
    }];
    
    self.money = [[UILabel alloc] init];
    self.money.text = @"+700";
    self.money.textAlignment = NSTextAlignmentRight;
    self.money.font = [UIFont systemFontOfSize:16];
    [self.money setTextColor:[UIColor orangeColor]];
    [self addSubview:self.money];
    [self.money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(self).offset(27.5);
        make.size.mas_equalTo(CGSizeMake(150, 20));
    }];
}

-(void)setModel:(WKPaymentDetailsModel *)model{
    if (_model != model) {
        _model = model;
        [self.titleBtn setTitle: @"充值" forState:UIControlStateNormal];
        self.timeLabel.text = model.CreateTime;
        self.money.text = [NSString stringWithFormat:@"¥ %0.2f",model.Amount.floatValue];
        
    }
}

@end
