//
//  WKEvaluateTableViewCell.m
//  秀加加
//
//  Created by lin on 16/9/7.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKEvaluateTableViewCell.h"

@interface WKEvaluateTableViewCell ()

@property (strong, nonatomic) UIImageView *headImgView;

@property (strong, nonatomic) UILabel *title;

@property (strong, nonatomic) UILabel *content;

@property (strong, nonatomic) UILabel *money;

@property (strong, nonatomic) UILabel *date;

@end

@implementation WKEvaluateTableViewCell

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
    UIImage *headImage = [UIImage imageNamed:@"default_05"];
    self.headImgView = [[UIImageView alloc] init];
    self.headImgView.image = headImage;
    self.headImgView.layer.cornerRadius = 5.0;
    self.headImgView.layer.masksToBounds = YES;
    [self addSubview:self.headImgView];
    [self.headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self).offset((105-headImage.size.height)/2);
        make.size.mas_equalTo(CGSizeMake(headImage.size.width, headImage.size.height));
    }];
    
    self.title = [[UILabel alloc] init];
    self.title.numberOfLines = 0;
    self.title.lineBreakMode = NSLineBreakByCharWrapping;
    self.title.text = @"w2qewryuirqeyukjrqetykijlkrqewqytuiljerytu;ltreweqrtyutyluytr3ewertyruyjytrqwtj";
    self.title.font = [UIFont systemFontOfSize:14];
    self.title.textColor = [UIColor colorWithHex:0xA4AAB9];
    self.title.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.title];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImgView.mas_right).offset(10);
        make.top.equalTo(self.headImgView).offset(0);
        make.width.mas_equalTo(WKScreenW-headImage.size.width-30);
        make.height.mas_greaterThanOrEqualTo(20);
    }];
    
    self.date = [[UILabel alloc] init];
    self.date.text = @"购买日期:2016-08-16";
    self.date.font = [UIFont systemFontOfSize:12];
    self.date.textColor = [UIColor colorWithHex:0xA4AAB9];
    self.date.textAlignment = NSTextAlignmentLeft;
    CGSize dateSize = [self.date.text sizeOfStringWithFont:[UIFont systemFontOfSize:12] withMaxSize:CGSizeMake(MAXFLOAT, 13)];
    [self addSubview:self.date];
    [self.date mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.bottom.equalTo(self.headImgView).offset(0);
        make.size.sizeOffset(CGSizeMake(dateSize.width + 1, 13));
    }];
    
    self.money = [[UILabel alloc] init];
    self.money.text = @"￥ 188.00";
    self.money.font = [UIFont systemFontOfSize:12];
    self.money.textColor = [UIColor colorWithHex:0xA4AAB9];
    self.money.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.money];
    [self.money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImgView.mas_right).offset(10);
        make.right.equalTo(self.date.mas_left).offset(10);
        make.centerY.equalTo(self.date.mas_centerY);
        make.height.mas_equalTo(13);
    }];
    
    self.content = [[UILabel alloc] init];
    self.content.text = @"型号:红色 37码  数量:1234";
    self.content.font = [UIFont systemFontOfSize:12];
    self.content.textColor = [UIColor colorWithHex:0xA4AAB9];
    self.content.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.content];
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImgView.mas_right).offset(10);
        make.bottom.equalTo(self.money.mas_top).offset(-10);
        make.size.mas_greaterThanOrEqualTo(CGSizeMake(WKScreenW-headImage.size.width-30, 20));
    }];
}

-(void)setModel:(WKEvaluateTableModel *)model{
    if (_model!=model) {
        _model = model;
        [self.headImgView sd_setImageWithURL:[NSURL URLWithString:model.GoodsPicUrl]];
        self.title.text = model.GoodsName;
        if(model.GoodsModelName.length < 1)
        {
            self.content.text = [NSString stringWithFormat:@"数量:%ld",(long)model.GoodsNumber];
        }else{
            self.content.text = [NSString stringWithFormat:@"型号:%@    数量:%ld",model.GoodsModelName.description,(long)model.GoodsNumber];
        }

        self.money.text = [NSString stringWithFormat:@"¥ %.2f",[model.GoodsPrice floatValue]];
        NSArray *timeArr = [model.CreateTime componentsSeparatedByString:@" "];
        self.date.text = [NSString stringWithFormat:@"购买日期:%@",timeArr[0]];
    }
}

@end
