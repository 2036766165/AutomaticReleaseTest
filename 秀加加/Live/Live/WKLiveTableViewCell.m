//
//  WKLiveTableViewCell.m
//  wdbo
//
//  Created by lin on 16/6/30.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import "WKLiveTableViewCell.h"
#import "WKGoodsModel.h"

@interface WKLiveTableViewCell(){
    WKGoodsListItem *_tempMd;
}

@property (nonatomic,assign) NSInteger type;
@property (nonatomic,strong) UIImageView *backGroundView;
@property (nonatomic,strong) UIButton *confirmBtn;
@property (nonatomic,assign) BOOL reommandClick;

@end

@implementation WKLiveTableViewCell

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
    UIView *bgView = [UIView new];
    bgView.tag = 1001;
    bgView.userInteractionEnabled = NO;
    bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bgView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recommandEvent:)];
    [bgView addGestureRecognizer:tap];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(2, 4 * WKScaleH, 2, 4 * WKScaleH));
    }];
    
    self.backGroundView = [[UIImageView alloc] init];
    self.backgroundColor = [UIColor clearColor];
    self.backGroundView.contentMode = UIViewContentModeScaleAspectFill;
    self.backGroundView.clipsToBounds = YES;
    [self.contentView addSubview:self.backGroundView];
    
    [self.backGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(3);
        make.top.equalTo(bgView).offset(3);
        make.bottom.mas_equalTo(bgView.mas_bottom).mas_offset(-3);
        make.width.mas_offset(60);
    }];
    
    self.name = [[UILabel alloc] init];
    self.name.text = @"二代商务系列";
    self.name.textAlignment = NSTextAlignmentLeft;
    self.name.numberOfLines = 0;
    //self.name.backgroundColor = [UIColor greenColor];
    self.name.textColor = [UIColor darkGrayColor];
    self.name.font = [UIFont systemFontOfSize:16];
    [bgView addSubview:self.name];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backGroundView.mas_right).offset(4);
        make.top.equalTo(bgView).offset(3 * WKScaleH);
        //make.size.mas_equalTo(CGSizeMake(100, 20));
        make.height.mas_greaterThanOrEqualTo(30);
        make.right.mas_equalTo(bgView.mas_right).offset(-4);
    }];
    
    self.value = [[UILabel alloc] init];
    self.value.text = @"RMB:99.9";
    self.value.textAlignment = NSTextAlignmentLeft;
    self.value.textColor = [UIColor colorWithHexString:@"#FC6620"];
    self.value.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:self.value];
    [self.value mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backGroundView.mas_right).offset(6);
        make.bottom.equalTo(bgView.mas_bottom).offset(-15);
        //make.size.mas_equalTo(CGSizeMake(100, 20));
        make.height.mas_offset(20);
        make.width.mas_offset(80);
    }];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor whiteColor];
    btn.layer.borderColor = [UIColor colorWithHexString:@"#FC6620"].CGColor;
    btn.layer.borderWidth = 2.0;
    [btn setTitleColor:[UIColor colorWithHexString:@"#FC6620"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn];
    self.confirmBtn = btn;
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-15);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
        make.size.mas_equalTo(CGSizeMake(40, 25));
    }];
    
    self.recommand = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"live_recommended"]];
    self.recommand.layer.cornerRadius = 4.0;
    self.recommand.layer.masksToBounds = YES;
    [bgView addSubview:self.recommand];
    [self.recommand mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView.mas_right).offset(-5);
        make.bottom.equalTo(bgView.mas_bottom).offset(-15);
        make.size.mas_equalTo(CGSizeMake(86, 70));
    }];
}

-(void)recommandEvent:(UITapGestureRecognizer *)sender
{
//    NSInteger type = _tempMd.IsRecommend.integerValue == 0?1:0;
//    
//    if ([_delegate respondsToSelector:@selector(recomendWith:type:cell:)]) {
//        [_delegate recomendWith:_tempMd type:type cell:self];
//    }
}

- (void)setModel:(WKGoodsListItem *)model{
    
    _tempMd = model;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.backGroundView sd_setImageWithURL:[NSURL URLWithString:model.PicUrl] placeholderImage:[UIImage imageNamed:@"zanwu"]];
    self.name.text = model.GoodsName;
    
    NSString *str = [NSString stringWithFormat:@"￥%@",model.Price];

    self.value.text = str;
    self.value.textColor = [UIColor redColor];

    if (!model.IsAuction) {
        // 商品
        [self.confirmBtn setTitle:@"推荐" forState:UIControlStateNormal];

        UIView *bgView = [self.contentView viewWithTag:1001];
        if (!model.IsRecommend) {
            self.recommand.hidden = YES;
            bgView.layer.borderWidth = 0.0f;
            self.confirmBtn.hidden = NO;
        }else{
            self.recommand.hidden = NO;
            self.confirmBtn.hidden = YES;
            bgView.layer.borderColor = MAIN_COLOR.CGColor;
            bgView.layer.borderWidth = 3.0f;
        }
    }else{
        // 拍卖品
        self.confirmBtn.hidden = NO;
        self.recommand.hidden = YES;
        
        [self.confirmBtn setTitle:@"拍卖" forState:UIControlStateNormal];
    }
    
}

- (void)btnClick:(UIButton *)btn{
    if ([_delegate respondsToSelector:@selector(recomendWith:cell:)]) {
        [_delegate recomendWith:_tempMd cell:self];
    }
}

@end
