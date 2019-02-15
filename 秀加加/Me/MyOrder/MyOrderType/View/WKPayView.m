//
//  WKPayView.m
//  秀加加
//
//  Created by lin on 2016/10/13.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKPayView.h"
#import "WKAuctionStatusModel.h"
#import "NSObject+XWAdd.h"
#import "WKAddressModel.h"
#import "PlayerManager.h"
#import "WKCornerBtn.h"

@interface WKPayView ()

@property (nonatomic,strong) WKCornerBtn *weixinBtn;
@property (nonatomic,strong) WKCornerBtn *aliPayBtn;
@property (nonatomic,strong) WKCornerBtn *balanceBtn;

@property (nonatomic,copy) NSNumber *balanceNum;

@property (nonatomic,strong) UILabel *dropTitle;
@property (nonatomic,strong) UILabel *myPriceTitle;

@end

@implementation WKPayView

@synthesize auctionModel = _auctionModel;

int contentViewWidth = 0;

-(instancetype)initWithFrame:(CGRect)frame type:(NSInteger)type direction:(NSInteger)direction
{
    if (self =[super initWithFrame:frame])
    {
        [self addSubView:type direction:direction];
    }
    return self;
}

-(void)addSubView:(NSInteger)type direction:(NSInteger)direction{
    
    UIButton *maskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    maskBtn.frame = self.bounds;
//    maskBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    maskBtn.backgroundColor = [UIColor clearColor];
    [maskBtn addTarget:self action:@selector(dismissView:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:maskBtn];
    
//    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fullScreen)];
//    [self addGestureRecognizer:gesture];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 5.0;
    contentView.layer.masksToBounds = YES;
    [self addSubview:contentView];
    self.contentView = contentView;
    
    if(type == 1)
    {
        contentViewWidth = WKScreenW-80;
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake((WKScreenW-80), 200));
        }];
    }
    else if(type == 2 && direction == 1)//竖屏
    {
        contentViewWidth = WKScreenW-80;
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake((WKScreenW-40), 310));
        }];
    }
//    else if(type == 2 && direction == 0)//横屏
//    {
//        contentViewWidth = WKScreenW-300;
//        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.center.mas_equalTo(self);
//            make.size.mas_equalTo(CGSizeMake(contentViewWidth, 310));
//        }];
//    }
    
    UIImage *closeImage = [UIImage imageNamed:@"close"];
    UIButton *closeBtn = [[UIButton alloc] init];
    [closeBtn setImage:closeImage forState:UIControlStateNormal];
    closeBtn.tag = 3;
    [closeBtn addTarget:self action:@selector(payEvent:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView.mas_right).offset(-15);
        make.top.equalTo(contentView).offset(15);
        make.size.mas_equalTo(CGSizeMake(closeImage.size.width, closeImage.size.height));
    }];
    
    UILabel *title = [[UILabel alloc] init];
    title.text = @"确认地址";
    title.font = [UIFont systemFontOfSize:20];
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor colorWithHex:0x9EA1AD];
    [contentView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(0);
        make.right.equalTo(contentView.mas_right).offset(0);
        make.top.equalTo(contentView).offset(15);
        make.height.mas_equalTo(30);
    }];
    
    UILabel *money = [[UILabel alloc] init];
    money.text = [NSString stringWithFormat:@"商品价格:  %@",@"123"];
    money.font = [UIFont systemFontOfSize:20];
    money.textAlignment = NSTextAlignmentCenter;
    money.textColor = [UIColor colorWithHex:0x9EA1AD];
    self.money = money;
    [contentView addSubview:money];
    [money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(0);
        make.right.equalTo(contentView.mas_right).offset(0);
        make.top.equalTo(title.mas_bottom).offset(15);
        make.height.mas_equalTo(30);
    }];
    
    if(type == 1)
    {
        title.text = @"立即支付";
            // 底下两个按钮
            NSArray *btnTitles = @[@"weixin_icon",@"alipay",@"remainImg"];
            NSArray *titlesArr = @[@"微信支付",@"支付宝",@"余额"];
            NSArray *colorArr = @[[UIColor colorWithHexString:@"#27C025"],[UIColor colorWithHexString:@"#21A2E4"],[UIColor colorWithHexString:@"#FC6620"]];
        
       //     NSMutableArray *btnsArr = @[].mutableCopy;
        
        [self getMemberIncome];
        [contentView layoutIfNeeded];
        
        for (int i=0; i<(User.isReviewID?btnTitles.count-1:btnTitles.count); i++) {
        
                WKCornerBtn *cornerBtn = [[WKCornerBtn alloc] initWithFrame:CGRectZero title:titlesArr[i] imageName:btnTitles[i] borderColor:colorArr[i]];
                cornerBtn.tag = i+1;
                [contentView addSubview:cornerBtn];
        
                if (i==0) {
                    cornerBtn.tag = 1;
                    self.weixinBtn = cornerBtn;
                }else if (i == 1){
                    self.aliPayBtn = cornerBtn;
                    cornerBtn.tag = 2;
                }else{
                    self.balanceBtn = cornerBtn;
                    cornerBtn.tag = 5;
                }
                [cornerBtn addTarget:self sel:@selector(payEvent:)];
           }
        
        if (User.isReviewID) {
            [self.aliPayBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo((contentView.frame.size.width-140)/3);
                make.size.mas_equalTo(CGSizeMake(70, 70));
                make.bottom.mas_equalTo(contentView.mas_bottom).offset(-10);
            }];
            
            [self.weixinBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-(contentView.frame.size.width-140)/3);
                make.size.mas_equalTo(CGSizeMake(70, 70));
                make.bottom.mas_equalTo(contentView.mas_bottom).offset(-10);
            }];
        }else{
            [self.aliPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
               make.size.mas_equalTo(CGSizeMake(70, 70));
               make.bottom.mas_equalTo(contentView.mas_bottom).offset(-10);
               make.centerX.mas_equalTo(contentView);
            }];
           
            [self.weixinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
               make.size.mas_equalTo(CGSizeMake(70, 70));
               make.bottom.mas_equalTo(contentView.mas_bottom).offset(-10);
               make.right.mas_equalTo(self.aliPayBtn.mas_left).offset(-10);
            }];
            [self.balanceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(70, 70));
                make.bottom.mas_equalTo(contentView.mas_bottom).offset(-10);
                make.left.mas_equalTo(self.aliPayBtn.mas_right).offset(10);
            }];

        }        
    }
    else if(type == 2)
    {
        money.hidden = YES;
        //goods total price
        UILabel *dropName = [[UILabel alloc] init];
        dropName.font = [UIFont systemFontOfSize:14];
        dropName.text = @"商品金额";
        dropName.textColor = [UIColor colorWithHex:0x9EA1AD];
        [contentView addSubview:dropName];
        self.dropTitle = dropName;
        [dropName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView).offset(10);
            make.top.equalTo(title.mas_bottom).offset(10);
            make.size.mas_equalTo(CGSizeMake(100, 20));
        }];
        
        UILabel *dropValue = [[UILabel alloc] init];
        dropValue.font = [UIFont systemFontOfSize:14];
//        dropValue.text = @"￥0";
        dropValue.textColor = [UIColor colorWithHex:0x9EA1AD];
        dropValue.textAlignment = NSTextAlignmentRight;
        self.dropValue = dropValue;
        [contentView addSubview:dropValue];
        [dropValue mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(contentView.mas_right).offset(-10);
            make.top.equalTo(title.mas_bottom).offset(10);
            make.size.mas_greaterThanOrEqualTo(CGSizeMake(60, 20));
        }];
        
        // my offered money
        UILabel *marginName = [[UILabel alloc] init];
        marginName.font = [UIFont systemFontOfSize:14];
        marginName.text = @"我的金额";
        self.myPriceTitle = marginName;
        marginName.textColor = [UIColor colorWithHex:0x9EA1AD];
        [contentView addSubview:marginName];
        [marginName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView).offset(10);
            make.top.equalTo(dropName.mas_bottom).offset(10);
            make.size.mas_equalTo(CGSizeMake(150, 40));
        }];
        
        //已提交保证金价钱
        UILabel *marginValue = [[UILabel alloc] init];
        marginValue.font = [UIFont systemFontOfSize:14];
//        marginValue.text = @"￥0";
        marginValue.textColor = [UIColor colorWithHex:0xFC6621];
        marginValue.textAlignment = NSTextAlignmentRight;
        self.marginValue = marginValue;
        [contentView addSubview:marginValue];
        [marginValue mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(contentView.mas_right).offset(-10);
            make.top.equalTo(dropName.mas_bottom).offset(10);
            make.size.mas_equalTo(CGSizeMake(150, 40));
        }];
        
//        //还需补交
//        UILabel *payName = [[UILabel alloc] init];
//        payName.font = [UIFont systemFontOfSize:14];
//        payName.text = @"还需补交";
//        payName.textColor = [UIColor colorWithHex:0x9EA1AD];
//        [contentView addSubview:payName];
//        [payName mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(contentView).offset(10);
//            make.top.equalTo(marginName.mas_bottom).offset(10);
//            make.size.mas_equalTo(CGSizeMake(150, 20));
//        }];
//        
//        //还需补交价钱
//        UILabel *payValue = [[UILabel alloc] init];
//        payValue.font = [UIFont systemFontOfSize:14];
////        payValue.text = @"￥140";
//        payValue.textColor = [UIColor colorWithHex:0xF16517];
//        payValue.textAlignment = NSTextAlignmentRight;
//        self.payValue = payValue;
//        [contentView addSubview:payValue];
//        [payValue mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(contentView.mas_right).offset(-10);
//            make.top.equalTo(marginName.mas_bottom).offset(10);
//            make.size.mas_equalTo(CGSizeMake(150, 20));
//        }];
        
        
        //地址名字和手机号
        UILabel *name = [[UILabel alloc] init];
        name.userInteractionEnabled = YES;
        name.font = [UIFont systemFontOfSize:14];
        name.text = [NSString stringWithFormat:@"%@  %@",@"三驴子",@"12312378965"];//@"还需补交";
        name.textColor = [UIColor colorWithHex:0x9EA1AD];
        name.userInteractionEnabled = YES;
        self.name = name;
        [contentView addSubview:name];
        [name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView).offset(10);
            make.top.equalTo(self.marginValue.mas_bottom).offset(10);
//            make.size.mas_equalTo(CGSizeMake(WKScreenW-90-100, 20));
            make.height.mas_offset(40);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-80);
        }];
        
        //默认图标
        UIButton *defaultImageView = [[UIButton alloc] init];
        defaultImageView.backgroundColor = [UIColor colorWithHex:0xF06017];
        [defaultImageView setTitle:@"默认" forState:UIControlStateNormal];
        defaultImageView.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [defaultImageView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [contentView addSubview:defaultImageView];
        self.defaultBtn = defaultImageView;
        
        [defaultImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-15);
            make.centerY.equalTo(name.mas_centerY).offset(0);
            make.size.mas_equalTo(CGSizeMake(50, 20));
        }];
        
        //地址
        UILabel *address = [[UILabel alloc] init];
        address.userInteractionEnabled = YES;
        address.numberOfLines = 0;
        address.font = [UIFont systemFontOfSize:14];
        address.userInteractionEnabled = YES;
        address.textColor = [UIColor colorWithHex:0xA7A6AD];
        self.address = address;
        
        [contentView addSubview:address];
        
        [address mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView).offset(10);
            make.top.equalTo(name.mas_bottom).offset(15);
            make.size.mas_lessThanOrEqualTo(CGSizeMake(WKScreenW-90, 60));
        }];
        
        
        UIButton* holder = [[UIButton alloc] init];
        [contentView addSubview:holder];

        [holder mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(0);
            make.right.mas_offset(0);
            make.top.equalTo(name.mas_top).offset(2);
            make.bottom.equalTo(address.mas_bottom).offset(2);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectAddress:)];
        [holder addGestureRecognizer:tap];

        //前进按钮
        UIButton *backGroundBtn = [[UIButton alloc] init];
//        backGroundBtn.backgroundColor = [UIColor redColor];
        backGroundBtn.tag = 4;
        [backGroundBtn addTarget:self action:@selector(payEvent:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:backGroundBtn];
        [backGroundBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(contentView.mas_right).offset(-10);
            make.top.equalTo(name.mas_bottom).offset(15);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        
        UIImage *goImage = [UIImage imageNamed:@"go"];
        UIButton *goBtn = [[UIButton alloc] init];
        [goBtn setImage:goImage forState:UIControlStateNormal];
        [backGroundBtn addSubview:goBtn];
        [goBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(backGroundBtn.mas_right).offset(0);
            make.centerY.equalTo(backGroundBtn.mas_centerY).offset(0);
            make.size.mas_equalTo(CGSizeMake(goImage.size.width, goImage.size.height));
        }];
        backGroundBtn.hidden = NO;
        // bottom confirm btn
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"确认" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor colorWithRed:0.99 green:0.40 blue:0.13 alpha:1.00];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [contentView addSubview:btn];
        btn.layer.cornerRadius = 3.0;
        btn.clipsToBounds = YES;
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.address.mas_bottom).offset(40);
            make.left.mas_offset(10);
            make.right.mas_offset(-10);
            make.height.mas_offset(40);
        }];
    }
}

- (void)dismissView:(UIButton *)btn{
    [self removeFromSuperview];
}

- (void)setAuctionModel:(WKAuctionStatusModel *)auctionModel{
    _auctionModel = auctionModel;
    
    [_auctionModel addObserver:self forKeyPath:@"addressModel" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:NULL];
    
    self.defaultBtn.hidden = YES;
//    self.dropValue.text = [NSString stringWithFormat:@"￥%0.2f",[_auctionModel.CurrentPrice floatValue]];
    
    if (auctionModel.SaleType.integerValue == 1) {
        
        self.dropTitle.text = @"起拍价";
        self.myPriceTitle.text = @"成交价";
        
        self.marginValue.text = [NSString stringWithFormat:@"￥%0.2f",[_auctionModel.CurrentPrice floatValue]]; // current price
        self.dropValue.text = [NSString stringWithFormat:@"￥%.2f",[_auctionModel.GoodsStartPrice floatValue]];
    }else{
        self.marginValue.text = [NSString stringWithFormat:@"￥%0.2f",[_auctionModel.Price floatValue]]; // my price
        self.dropValue.text = [NSString stringWithFormat:@"￥%.2f",[_auctionModel.GoodsStartPrice floatValue]];
    }
    self.name.text = @"请选择联系人";// goods price
    self.address.text = @"请选择收货地址";
}

- (WKAuctionStatusModel *)auctionModel{
    return _auctionModel;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"addressModel"]) {
        
        self.name.text = [NSString stringWithFormat:@"%@  %@",self.auctionModel.addressModel.Contact,self.auctionModel.addressModel.Phone];
        
        if (self.auctionModel.addressModel.IsDefault) {
            self.defaultBtn.hidden = NO;
        }else{
            self.defaultBtn.hidden = YES;
        }
        
        self.address.text = [NSString stringWithFormat:@"%@ %@ %@ %@",self.auctionModel.addressModel.ProvinceName,self.auctionModel.addressModel.CityName,self.auctionModel.addressModel.CountyName,self.auctionModel.addressModel.Address];
    }
}

-(void)payEvent:(UIButton *)sender
{
    if(sender.tag == 1)
    {
        _payTypeCallBlock(1);
    }
    else if(sender.tag == 2)
    {
        _payTypeCallBlock(2);
    }
    else if(sender.tag == 3)
    {
        [self dismissView:nil];
        _payTypeCallBlock(3);
    }
    else if(sender.tag == 4)//进入地址管理
    {
        _payTypeCallBlock(4);
    }
    else if(sender.tag == 5)//进入地址管理
    {
        _payTypeCallBlock(5);
    }
}

- (void)btnClick:(UIButton *)btn{
    
    NSInteger payType;
//    if (btn.tag == 10) {
//        // 微信支
//        payType = 1;
//    }else if (btn.tag == 11){
//        // 支付宝
//        payType = 2;
//    }else{
//        // 余额
//        float payValue = _auctionModel.CurrentPrice.floatValue - _auctionModel.GoodsStartPrice.floatValue;
//        if (self.balanceNum.floatValue < payValue) {
//            [WKPromptView showPromptView:@"余额不足请充值"];
//            [self xw_postNotificationWithName:@"BALANCE" userInfo:nil];
//
//            return;
//        }
//        
//        payType = 5;
//    }
    payType = 5;

    _payTypeCallBlock(payType);

}

- (void)selectAddress:(UITapGestureRecognizer *)tap{
    if (_payTypeCallBlock) {
        _payTypeCallBlock(4);
    }
}

// 获取用户余额
- (void)getMemberIncome{
    
    [WKHttpRequest getAuthCode:HttpRequestMethodGet url:WKStoreIncome param:nil success:^(WKBaseResponse *response) {
        NSNumber *moneyCanTake = response.Data[@"MoneyCanTake"];
        self.balanceNum = moneyCanTake;
        [self.balanceBtn setTitle:[NSString stringWithFormat:@"%.2f",[moneyCanTake floatValue]]];
        
    } failure:^(WKBaseResponse *response) {
        
    }];
}

- (void)dealloc{
    [_auctionModel removeObserver:self forKeyPath:@"addressModel"];
}

@end
