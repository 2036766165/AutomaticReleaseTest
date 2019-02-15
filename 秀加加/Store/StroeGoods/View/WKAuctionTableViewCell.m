//
//  WKAuctionTableViewCell.m
//  秀加加
//
//  Created by sks on 2016/9/13.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKAuctionTableViewCell.h"
#import "WKGoodsModel.h"
#import "WKGoodsItemProtocol.h"

@interface WKAuctionTableViewCell () {
    WKGoodsListItem *_tempModel;
}

@property (nonatomic,strong) UIImageView *iconImage;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *priceLabel;

@property (nonatomic,strong) UIButton *shareBtn;
@property (nonatomic,strong) UIButton *topBtn;

@end

@implementation WKAuctionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    self.iconImage = [[UIImageView alloc] init];
    self.iconImage.contentMode = UIViewContentModeScaleAspectFill;
    self.iconImage.clipsToBounds = YES;
    [self.contentView addSubview:self.iconImage];
    
    self.nameLabel = [UILabel new];
    self.nameLabel.textColor = [UIColor lightGrayColor];
    self.nameLabel.font = [UIFont systemFontOfSize:12];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.nameLabel];
    
    self.priceLabel = [UILabel new];
    self.priceLabel.textColor = [UIColor colorWithHexString:@"#FC6620"];
    self.priceLabel.font = [UIFont systemFontOfSize:14.0f];
    self.priceLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.priceLabel];
    
    NSArray *titles = @[@" 分享",@" 置顶"];
    NSArray *images = @[@"pro_share",@"pro_top"];
    
    UIView *btnBgView = [UIView new];
    [self.contentView addSubview:btnBgView];
    
    [btnBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        make.top.equalTo(self.priceLabel.mas_bottom);
        make.bottom.equalTo(self.iconImage.mas_bottom);
        make.left.equalTo(self.iconImage.mas_right).offset(10);
    }];
    
    for (int i=0; i<titles.count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        btn.tag = 10 + i;
        btn.titleLabel.font = [UIFont systemFontOfSize:11];
        [btn setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btnBgView addSubview:btn];
        
        if (i == 0)
        {
            self.shareBtn = btn;
        }
        else
        {
            self.topBtn = btn;
        }
    }
    
    [self layoutUI];
}

- (void)layoutUI{
    
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(10);
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
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(20);
        make.left.mas_equalTo(self.iconImage.mas_right).offset(10);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        make.height.mas_equalTo(15);
    }];
    
//    NSArray *views = @[self.shareBtn,self.topBtn];
//    
//    [views mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:20 leadSpacing:0 tailSpacing:5];
//    [views mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(50, 30));
//        make.centerY.mas_equalTo(self.shareBtn.superview.mas_centerY);
//    }];
    
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.shareBtn.superview.mas_bottom).offset(7);
        make.centerX.mas_equalTo(self.shareBtn.superview.mas_centerX);
        make.size.mas_offset(CGSizeMake(60, 30));
    }];
    
    [self.topBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.topBtn.superview.mas_bottom).offset(7);
        make.right.mas_equalTo(self.topBtn.superview.mas_right).offset(11);
        make.size.mas_offset(CGSizeMake(60, 30));
    }];
    
}

- (void)setModel:(WKGoodsListItem *)md{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _tempModel = md;
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:md.PicUrl] placeholderImage:[UIImage imageNamed:@"zanwu"]];
    self.nameLabel.text = md.GoodsName;
    self.priceLabel.text = [NSString stringWithFormat:@"起拍￥ %0.2f",[md.Price floatValue]];
}

// MARK : 置顶 分享
- (void)btnClick:(UIButton *)btn{
    
    WKOperateType type;
    
    if (btn.tag == 10) {
        // 分享
        type = WKOperateTypeShare;
    }else{
        // 置顶
        type = WKOperateTypeTop;
    }
    
    if ([_delegate respondsToSelector:@selector(operateGoods:obj:)]) {
        [_delegate operateGoods:type obj:_tempModel];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
