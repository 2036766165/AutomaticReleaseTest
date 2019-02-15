//
//  WKBatchTableViewCell.m
//  秀加加
//
//  Created by sks on 2016/9/20.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKBatchTableViewCell.h"
#import "WKGoodsModel.h"

@interface WKBatchTableViewCell (){
    WKGoodsListItem *_tempModel;
}

@property (nonatomic,strong) UIImageView *iconImage;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *priceLabel;
@property (nonatomic,strong) UILabel *salesLabel;
@property (nonatomic,strong) UILabel *stockLabel;

@property (nonatomic,strong) UIButton *selectedBtn;

@end

@implementation WKBatchTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"pro_select"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"pro_selected"] forState:UIControlStateSelected];
    btn.userInteractionEnabled = NO;
    [self.contentView addSubview:btn];
    self.selectedBtn = btn;
    
    self.iconImage = [[UIImageView alloc] init];
    self.iconImage.contentMode = UIViewContentModeScaleAspectFill;
    self.iconImage.clipsToBounds = YES;
    [self.contentView addSubview:self.iconImage];
    
    self.nameLabel = [UILabel new];
    self.nameLabel.textColor = [UIColor lightGrayColor];
    self.nameLabel.font = [UIFont systemFontOfSize:12];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.nameLabel];
    
    self.salesLabel = [UILabel new];
    self.salesLabel.textColor = [UIColor lightGrayColor];
    self.salesLabel.font = [UIFont systemFontOfSize:11];
    self.salesLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.salesLabel];
    
    self.stockLabel = [UILabel new];
    self.stockLabel.textColor = [UIColor lightGrayColor];
    self.stockLabel.font = [UIFont systemFontOfSize:11];
    self.stockLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.stockLabel];
    
    UIView *priceView = [[UIView alloc]init];
    [self.contentView addSubview:priceView];
    [priceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom);
        make.bottom.equalTo(self.salesLabel.mas_top);
        make.left.equalTo(self.iconImage.mas_right);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
    }];
    
    self.priceLabel = [UILabel new];
    self.priceLabel.textColor = [UIColor colorWithHexString:@"#FC6620"];
    self.priceLabel.font = [UIFont systemFontOfSize:14.0f];
    self.priceLabel.textAlignment = NSTextAlignmentLeft;
    [priceView addSubview:self.priceLabel];

    [self layoutUI];
}

- (void)layoutUI{
    [self.selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_offset(10);
        make.size.mas_offset(CGSizeMake(20, 20));
    }];
    
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.selectedBtn.mas_right).offset(15);
        make.top.mas_equalTo(self.contentView.mas_top).offset(15);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(self.iconImage.mas_height);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImage.mas_top).offset(2);
        make.left.mas_equalTo(self.iconImage.mas_right).offset(10);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        make.height.mas_equalTo(13);
    }];
    
    [self.salesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.iconImage.mas_bottom).offset(-2);
        make.left.mas_equalTo(self.iconImage.mas_right).offset(10);
        make.size.mas_offset(CGSizeMake(100, 12));
    }];
    
    [self.stockLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.salesLabel.mas_centerY).offset(0);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        make.size.mas_offset(CGSizeMake(100, 12));
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.priceLabel.superview.mas_left).offset(10);
        make.right.equalTo(self.priceLabel.superview.mas_right).offset(0);
        make.centerY.equalTo(self.priceLabel.superview.mas_centerY);
        make.height.mas_equalTo(15);
    }];
}

- (void)setModel:(WKGoodsListItem *)model{
    _tempModel = model;
    
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:model.PicUrl] placeholderImage:[UIImage imageNamed:@"zanwu"]];
    self.nameLabel.text = model.GoodsName;
    self.priceLabel.text = [NSString stringWithFormat:@"￥ %0.2f",model.Price.floatValue];
    self.salesLabel.text = [NSString stringWithFormat:@"销量 %@",model.SaleCount];
    self.stockLabel.text = [NSString stringWithFormat:@"库存 %@",model.Stock];
    self.selectedBtn.selected = model.isSelected;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
