//
//  WKLiveMarginView.m
//  秀加加
//
//  Created by lin on 2016/10/10.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKLiveMarginView.h"

@interface WKLiveMarginView()

@property (nonatomic,strong) UIView *backGroundView;

@end

@implementation WKLiveMarginView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self initUi];
    }
    return self;
}

-(void)initUi
{
    self.backGroundView = [[UIView alloc] init];
    self.backGroundView.backgroundColor = [UIColor whiteColor];
    self.backGroundView.layer.cornerRadius = 8.0;
    self.backGroundView.layer.masksToBounds = YES;
    [self addSubview:self.backGroundView];
    [self.backGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(35);
        make.right.equalTo(self.mas_right).offset(-35);
        make.top.equalTo(self).offset(235);
        make.bottom.equalTo(self.mas_bottom).offset(-235);
    }];
    
    UILabel *title = [[UILabel alloc] init];
    title.text = @"保证金提交";
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont systemFontOfSize:18];
    title.textColor = [UIColor colorWithHex:0xA09DAA];
    [self.backGroundView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backGroundView).offset(0);
        make.right.equalTo(self.backGroundView.mas_right).offset(0);
        make.top.equalTo(self.backGroundView).offset(15);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *content = [[UILabel alloc] init];
    content.text = @"拍卖结束后全款退还保证金";
    content.textAlignment = NSTextAlignmentCenter;
    content.font = [UIFont systemFontOfSize:18];
    content.textColor = [UIColor colorWithHex:0xA09DAA];
    [self.backGroundView addSubview:content];
    [content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backGroundView).offset(0);
        make.right.equalTo(self.backGroundView.mas_right).offset(0);
        make.top.equalTo(title.mas_bottom).offset(20);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *detailContent = [[UILabel alloc] init];
    detailContent.text = @"注意:如拍得商品后60分钟没有支付,保证金将抵扣";
    detailContent.textAlignment = NSTextAlignmentCenter;
    detailContent.font = [UIFont systemFontOfSize:12];
    detailContent.textColor = [UIColor colorWithHex:0xA09DAA];
    [self.backGroundView addSubview:detailContent];
    [detailContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backGroundView).offset(0);
        make.right.equalTo(self.backGroundView.mas_right).offset(0);
        make.top.equalTo(content.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
    }];
    
    UIImage *closeImage = [UIImage imageNamed:@"close"];
    UIButton *closeBtn = [[UIButton alloc] init];
    [closeBtn setImage:closeImage forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.backGroundView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backGroundView.mas_right).offset(-15);
        make.top.equalTo(self.backGroundView).offset(15);
        make.size.mas_equalTo(CGSizeMake(closeImage.size.width, closeImage.size.height));
    }];
    
    //微信支付
    UIImage *weixinImage = [UIImage imageNamed:@"weixinpay"];
    UIButton *weixinBtn = [[UIButton alloc] init];
    weixinBtn.tag = WeiXinPayType;
    [weixinBtn setImage:weixinImage forState:UIControlStateNormal];
    [weixinBtn addTarget:self action:@selector(payEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.backGroundView addSubview:weixinBtn];
    [weixinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backGroundView).offset(25);
        make.bottom.equalTo(self.backGroundView.mas_bottom).offset(-25);
        make.size.mas_equalTo(CGSizeMake(weixinImage.size.width, weixinImage.size.height));
    }];
    
    //支付宝支付
    UIImage *zhifuImage = [UIImage imageNamed:@"zhifubao"];
    UIButton *zhifuBtn = [[UIButton alloc] init];
    zhifuBtn.tag = ZhiFuBaoPayType;
    [zhifuBtn setImage:zhifuImage forState:UIControlStateNormal];
    [zhifuBtn addTarget:self action:@selector(payEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.backGroundView addSubview:zhifuBtn];
    [zhifuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backGroundView.mas_right).offset(-25);
        make.bottom.equalTo(self.backGroundView.mas_bottom).offset(-25);
        make.size.mas_equalTo(CGSizeMake(zhifuImage.size.width, zhifuImage.size.height));
    }];
}

-(void)payEvent:(UIButton *)sender
{
    if(sender.tag == WeiXinPayType)
    {
        _clickPayType(WeiXinPayType);
    }
    else if(sender.tag == ZhiFuBaoPayType)
    {
        _clickPayType(ZhiFuBaoPayType);
    }
}

-(void)closeEvent
{
    [self removeFromSuperview];
}

@end
