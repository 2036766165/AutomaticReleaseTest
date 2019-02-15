//
//  WKOrderNoticeTableViewCell.m
//  wdbo
//
//  Created by lin on 16/6/21.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import "WKOrderNoticeTableViewCell.h"

@interface WKOrderNoticeTableViewCell()

@property (strong, nonatomic) UILabel * timeLabel;

@end

@implementation WKOrderNoticeTableViewCell


-(void)setModel:(WKListNoticeInfo *)model
{
    NSString *str = model.Message;
    CGSize size = [str sizeOfStringWithFont:[UIFont systemFontOfSize:16] withMaxSize:CGSizeMake(WKScreenW-48, MAXFLOAT)];
    self.title.numberOfLines = 0;
    self.title.frame = CGRectMake(24, 12, WKScreenW-48, size.height);
    self.title.text = model.Message;
    [self.detail mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(24);
            make.top.equalTo(self.title.mas_bottom).offset(10);
            make.size.mas_equalTo(CGSizeMake(WKScreenW-50,16));
    }];
    self.detail.text = model.CreateTimeStr;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubView];
    }
    return self;
}

-(void)addSubView
{
    self.title = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, WKScreenW-120, 20)];
    self.title.text = @"开单说明书，早看一秒是优势";
    self.title.font = [UIFont systemFontOfSize:14];
    [self.title setTextColor:[UIColor colorWithHex:0x464646]];
    [self addSubview:self.title];
    
    self.detail = [[UILabel alloc] init];
    self.detail.font = [UIFont systemFontOfSize:12];
    [self.detail setTextColor:[UIColor colorWithHex:0xb0b0b0]];
    self.detail.numberOfLines = 0;
    self.detail.text = @"sdfsdfsdfsdfewfwefwefew";
    [self addSubview:self.detail];
    [self.detail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self.title.mas_bottom).offset(2);
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
-(void)setModel1:(WKPaymentDetailsModel *)model1{
    if (_model1 != model1) {
        _model1 = model1;
    }
    self.arrowIM.hidden = YES;
    [self.money mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(self).offset(27.5);
        make.size.mas_equalTo(CGSizeMake(80, 20));
    }];
    
    if ([_model1.AccountLogType integerValue]== 1)
    {
        self.title.text =[NSString stringWithFormat:@"订单收入-订单编号：%@",_model1.LogParm]; //@"订单收入";
        self.money.textColor = [UIColor orangeColor];
    }
    else if ([_model1.AccountLogType integerValue]== 2)
    {
        self.title.text = [NSString stringWithFormat:@"拍卖收入-订单编号：%@",_model1.LogParm];//@"拍卖收入"
        self.arrowIM.hidden = NO;
        self.money.textColor = [UIColor orangeColor];
        [self.money mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-15);
            make.top.equalTo(self).offset(20);
            make.size.mas_equalTo(CGSizeMake(80, 20));
        }];
    }
    else if ([_model1.AccountLogType integerValue]== 3)
    {
        self.title.text = @"打赏收入";
        self.money.textColor = [UIColor orangeColor];
    }
    else if ([_model1.AccountLogType integerValue]== 4)
    {
        self.title.text = @"提现";
        self.arrowIM.hidden = NO;
        self.money.textColor = [UIColor grayColor];
        [self.money mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-15);
            make.top.equalTo(self).offset(20);
            make.size.mas_equalTo(CGSizeMake(80, 20));
        }];
    }
    else if ([_model1.AccountLogType integerValue] == 5)
    {
        self.title.text = @"系统奖励";
        self.money.textColor = [UIColor orangeColor];
    }
    else if ([_model1.AccountLogType integerValue] == 6)
    {
        self.title.text = @"余额支付";
        self.money.textColor = [UIColor orangeColor];
    }
    else if ([_model1.AccountLogType integerValue] == 7)
    {
        self.title.text = @"账号入账";
        self.money.textColor = [UIColor orangeColor];
    }
    self.money.text = [NSString stringWithFormat:@"¥ %0.2f",_model1.Amount.floatValue];

    self.detail.text = model1.LogDescription;
    self.timeLabel.text = model1.CreateTime;
}
@end
