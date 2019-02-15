//
//  WKMyIntegralTableViewCell.m
//  秀加加
//
//  Created by lin on 16/9/7.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKMyIntegralTableViewCell.h"

@interface WKMyIntegralTableViewCell()

@property (nonatomic,strong) UILabel *title;

@property (nonatomic,strong) UILabel *date;

@property (nonatomic,strong) UILabel *integral;

@end

@implementation WKMyIntegralTableViewCell

-(void)setItem:(WKMyIntegralItemModel *)item
{
    self.title.text = item.Remark;
    self.date.text = item.CreateTime;
    self.integral.text = [NSString stringWithFormat:@"+%@",item.Point];
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
    UILabel *title = [[UILabel alloc] init];
    title.text = @"购物送积分(订单号:q2324567)";
    title.font = [UIFont systemFontOfSize:14];
    title.textColor = [UIColor colorWithHex:0x7e879d];
    title.textAlignment = NSTextAlignmentLeft;
    self.title = title;
    [self addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self).offset(10);
        make.size.mas_equalTo(CGSizeMake(WKScreenW-60, 20));
    }];
    
    UILabel *date = [[UILabel alloc] init];
    date.text = @"2016-09-05  08:12:36";
    date.font = [UIFont systemFontOfSize:12];
    date.textColor = [UIColor colorWithHex:0x7e879d];
    date.textAlignment = NSTextAlignmentLeft;
    self.date = date;
    [self addSubview:date];
    [date mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(title.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(WKScreenW-60, 20));
    }];
    
    UILabel *integral = [[UILabel alloc] init];
    integral.text = @"+999";
    integral.font = [UIFont systemFontOfSize:12];
    integral.textColor = [UIColor colorWithHex:0xFB6920];
    integral.textAlignment = NSTextAlignmentRight;
    self.integral = integral;
    [self addSubview:integral];
    [integral mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(self).offset((65-30)/2);
        make.size.mas_greaterThanOrEqualTo(CGSizeMake(40, 30));
    }];
}

@end
