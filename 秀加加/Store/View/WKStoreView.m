//
//  WKStoreView.m
//  秀加加
//  店铺首页
//  Created by lin on 16/9/13.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKStoreView.h"
#import "WKTimeCalcute.h"
#import "NSObject+XCTag.h"
#import "NSObject+XWAdd.h"

@interface WKStoreView()

@end

@implementation WKStoreView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame])
    {
       [self addSubView];
    }

    return self;
}

-(void)addSubView
{
    self.userInteractionEnabled = YES;
    UIView *upView = [[UIView alloc] init];
    upView.backgroundColor = [UIColor whiteColor];
    [self addSubview:upView];
    [upView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.top.equalTo(self).offset(74);
        make.height.mas_equalTo(60);
    }];
    
    //用户头像
    UIImage *leftHeadImg = [UIImage circleImageWithName:@"default_03" borderWidth:1 borderColor:[UIColor colorWithHex:0xF4C1A6]];
    self.leftImgView = [[UIImageView alloc] init];
    self.leftImgView.layer.cornerRadius = leftHeadImg.size.height/2;
    self.leftImgView.layer.masksToBounds = YES;
    self.leftImgView.layer.borderColor = [[UIColor colorWithHex:0xEE9357] CGColor];
    self.leftImgView.layer.borderWidth = 1.0;
    [upView addSubview:self.leftImgView];
    [self.leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(upView).offset(10);
        make.top.equalTo(upView).offset((60-leftHeadImg.size.height)/2);
        make.size.mas_equalTo(CGSizeMake(leftHeadImg.size.width, leftHeadImg.size.height));
    }];
    
    //用户等级
    self.levelImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dengji_1"]];
    [upView addSubview:self.levelImageView];
    [self.levelImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.leftImgView.mas_right).offset(0);
        make.bottom.equalTo(self.leftImgView.mas_bottom).offset(0);
        make.size.mas_equalTo(CGSizeMake(self.levelImageView.image.size.width,self.levelImageView.image.size.height));
    }];
    
    //用户昵称和定位地址
    self.userName = [[UILabel alloc] init];
    self.userName.font = [UIFont systemFontOfSize:10];
    self.userName.textColor = [UIColor colorWithHex:0xBABDC9];
    self.userName.text = @"";
    [upView addSubview:self.userName];
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.leftImgView.mas_top).offset(5);
        make.left.equalTo(self.leftImgView.mas_right).offset(10);
        make.right.equalTo(upView.mas_right).offset(-10);
        make.height.mas_equalTo(11);
    }];
    
    //粉丝数量
    self.fan = [[UILabel alloc] init];
    self.fan.text = [NSString stringWithFormat:@"粉丝 %@",@""];
    self.fan.font = [UIFont systemFontOfSize:10];
    self.fan.textColor = [UIColor colorWithHex:0xBABDC9];
    [upView addSubview:self.fan];
    [self.fan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImgView.mas_right).offset(10);
        make.bottom.equalTo(self.leftImgView.mas_bottom).offset(-5);
        make.size.mas_equalTo(CGSizeMake(200, 11));
    }];
    
    //直播状态
    self.liveNum = [[UILabel alloc] init];
    self.liveNum.textColor = [UIColor colorWithHex:0xFDA66D];
    self.liveNum.text = [NSString stringWithFormat:@"%@",@""];
    self.liveNum.font = [UIFont systemFontOfSize:10];
    self.liveNum.textAlignment = NSTextAlignmentRight;
    [upView addSubview:self.liveNum];
    [self.liveNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(upView.mas_right).offset(-5);
        make.centerY.equalTo(self.fan.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(100, 11));
    }];
    
    self.backGroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default_07"]];
    self.backGroundView.userInteractionEnabled = YES;
    self.backGroundView.tag = SelectEditPerson;
//    self.backGroundView.contentMode = UIViewContentModeScaleAspectFit;
    UITapGestureRecognizer *editGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editEvent)];
    [self.backGroundView addGestureRecognizer:editGesture];
    [self addSubview:self.backGroundView];
    [self.backGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.top.equalTo(upView.mas_bottom).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(-88);
        make.width.mas_equalTo(WKScreenW);
    }];
    
    //合并到一个控件中使用
    UIView *rightTopView = [[UIView alloc] init];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(authenticationStore)];
    [rightTopView addGestureRecognizer:tap];
    [self.backGroundView addSubview:rightTopView];
    [rightTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backGroundView.mas_right).offset(0);
        make.top.equalTo(self.backGroundView).offset(10);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
    
    //实体店认证
    self.renzhengLab = [[UILabel alloc] init];
    self.renzhengLab.textColor = [UIColor colorWithHex:0xB4B7B9];
    self.renzhengLab.font = [UIFont systemFontOfSize:12];
    self.renzhengLab.text = User.ShopAuthenticationStatus == 0 ? @"非实体店" : @"实体店认证";
    CGSize rzSize = [self.renzhengLab.text sizeOfStringWithFont:[UIFont systemFontOfSize:12] withMaxSize:CGSizeMake(MAXFLOAT, 13)];
    [rightTopView addSubview:self.renzhengLab];
    [self.renzhengLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(rightTopView.mas_right).offset(-5);
        make.top.equalTo(rightTopView).offset(0);
        make.size.mas_equalTo(CGSizeMake(rzSize.width + 1, 13));
    }];
    
    self.renzhengImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"renzhengSuccess"]];
    [rightTopView addSubview:self.renzhengImgView];
    [self.renzhengImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.renzhengLab.mas_left).offset(-2);
        make.centerY.equalTo(self.renzhengLab.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(self.renzhengImgView.image.size.width, self.renzhengImgView.image.size.height));
    }];
    
    UIView *downView = [[UIView alloc] init];
    downView.backgroundColor = [UIColor whiteColor];
    [self addSubview:downView];
    [downView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.top.equalTo(self.backGroundView.mas_bottom).offset(0);
        make.height.mas_equalTo(88);
    }];
    [[NSNotificationCenter defaultCenter] xw_addNotificationForName:@"TAG" block:^(NSNotification * _Nonnull notification) {
        [downView addSubview:[self createFlowButton]];
    }];
    [downView addSubview:[self createFlowButton]];
    
    //店铺的推荐商品
    self.goodsBtn = [[UIButton alloc] init];
    self.goodsBtn.tag = SelectShop;
    [self.goodsBtn setImage:[[UIImage imageNamed:@"zanwu@2x_03"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateNormal];
    self.goodsBtn.adjustsImageWhenHighlighted = NO;
    [self.goodsBtn addTarget:self action:@selector(btnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:self.goodsBtn];
    [self.goodsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(downView.mas_right).offset(-4);
        make.top.equalTo(downView).offset(2);
        make.bottom.equalTo(downView.mas_bottom).offset(-2);
        make.width.mas_equalTo(84);
    }];
    
    UIImage *biImage = [UIImage imageNamed:@"bi"];
    UIButton *bi = [[UIButton alloc] init];
    bi.tag = SelectShop;
    [bi setImage:biImage forState:UIControlStateNormal];
    [bi setImage:[UIImage imageNamed:@"bi_highlight"] forState:UIControlStateHighlighted];
    [bi addTarget:self action:@selector(btnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.goodsBtn addSubview:bi];
    [bi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.goodsBtn.mas_right).offset(-1);
        make.bottom.equalTo(self.goodsBtn.mas_bottom).offset(-1);
        make.size.mas_equalTo(CGSizeMake(biImage.size.width, biImage.size.height));
    }];

    UIImage *customImage = [UIImage imageNamed:@"custom"];
    UIImage *customImage_highlight = [UIImage imageNamed:@"custom_highlight"];
    UIButton *customBtn = [[UIButton alloc] init];
    customBtn.tag = SelectCustom;
    [customBtn setImage:customImage forState:UIControlStateNormal];
    [customBtn setImage:customImage_highlight forState:UIControlStateHighlighted];
    [customBtn setTitle:@"客户" forState:UIControlStateNormal];
    customBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 25, 0);
    customBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [customBtn setTitleColor:[UIColor colorWithHex:0x7e879d] forState:UIControlStateNormal];
    customBtn.titleEdgeInsets = UIEdgeInsetsMake(25, -customImage.size.width*2, 0, -customImage.size.width);
    customBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [customBtn addTarget:self action:@selector(btnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:customBtn];
    [customBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backGroundView).offset(10);
        make.bottom.equalTo(downView.mas_top).offset(5);
        make.size.mas_equalTo(CGSizeMake(customImage.size.width, customImage.size.height+25));
    }];

    UIButton *orderBtn = [[UIButton alloc] init];
    orderBtn.tag = SelectOrder;
    [orderBtn setImage:[UIImage imageNamed:@"order"] forState:UIControlStateNormal];
    [orderBtn setImage:[UIImage imageNamed:@"order_highlight"] forState:UIControlStateHighlighted];
    [orderBtn setTitle:@"订单" forState:UIControlStateNormal];
    orderBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 25, 0);
    orderBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [orderBtn setTitleColor:[UIColor colorWithHex:0x7e879d] forState:UIControlStateNormal];
    orderBtn.titleEdgeInsets = UIEdgeInsetsMake(25, -customImage.size.width*2, 0, -customImage.size.width);
    orderBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [orderBtn addTarget:self action:@selector(btnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:orderBtn];
    [orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(customBtn.mas_right).offset(10);
        make.bottom.equalTo(downView.mas_top).offset(5);
        make.size.mas_equalTo(CGSizeMake(customImage.size.width, customImage.size.height+25));
    }];
    
    //设置小红点显示
//    UIView *redView = [[UIView alloc] init];
//    redView.backgroundColor = [UIColor colorWithHex:0xFB5E24];
//    redView.layer.masksToBounds = YES;
//    redView.layer.cornerRadius = 2.5;
//    [orderBtn addSubview:redView];
//    [redView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(orderBtn.mas_right).offset(-7);
//        make.top.equalTo(orderBtn).offset(8);
//        make.size.mas_equalTo(CGSizeMake(5, 5));
//    }];

    UIButton *feeBtn = [[UIButton alloc] init];
    feeBtn.tag = SelectFee;
    [feeBtn setImage:[UIImage imageNamed:@"fee"] forState:UIControlStateNormal];
    [feeBtn setImage:[UIImage imageNamed:@"fee_highlight"] forState:UIControlStateHighlighted];
    [feeBtn setTitle:@"运费" forState:UIControlStateNormal];
    feeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 25, 0);
    feeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [feeBtn setTitleColor:[UIColor colorWithHex:0x7e879d] forState:UIControlStateNormal];
    feeBtn.titleEdgeInsets = UIEdgeInsetsMake(25, -customImage.size.width*2, 0, -customImage.size.width);
    feeBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [feeBtn addTarget:self action:@selector(btnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:feeBtn];
    [feeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(orderBtn.mas_right).offset(10);
        make.bottom.equalTo(downView.mas_top).offset(5);
        make.size.mas_equalTo(CGSizeMake(customImage.size.width, customImage.size.height+25));
    }];

    UIButton *incomeBtn = [[UIButton alloc] init];
    incomeBtn.tag = SelectIncome;
    [incomeBtn setImage:[UIImage imageNamed:@"income"] forState:UIControlStateNormal];
    [incomeBtn setImage:[UIImage imageNamed:@"income_highlight"] forState:UIControlStateHighlighted];
    [incomeBtn setTitle:@"收入" forState:UIControlStateNormal];
    incomeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 25, 0);
    incomeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [incomeBtn setTitleColor:[UIColor colorWithHex:0x7e879d] forState:UIControlStateNormal];
    incomeBtn.titleEdgeInsets = UIEdgeInsetsMake(25, -customImage.size.width*2, 0, -customImage.size.width);
    incomeBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [incomeBtn addTarget:self action:@selector(btnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:incomeBtn];
    [incomeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(feeBtn.mas_right).offset(10);
        make.bottom.equalTo(downView.mas_top).offset(5);
        make.size.mas_equalTo(CGSizeMake(customImage.size.width, customImage.size.height+25));
    }];

    UIButton *shareBtn = [[UIButton alloc] init];
    shareBtn.tag = SelectShare;
    [shareBtn setImage:[UIImage imageNamed:@"store_share_normal"] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"store_share_highlight"] forState:UIControlStateHighlighted];
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    shareBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 25, 0);
    shareBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [shareBtn setTitleColor:[UIColor colorWithHex:0x7e879d] forState:UIControlStateNormal];
    shareBtn.titleEdgeInsets = UIEdgeInsetsMake(25, -customImage.size.width*2, 0, -customImage.size.width);
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [shareBtn addTarget:self action:@selector(btnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:shareBtn];
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backGroundView.mas_right).offset(-10);
        make.bottom.equalTo(downView.mas_top).offset(5);
        make.size.mas_equalTo(CGSizeMake(customImage.size.width, customImage.size.height+25));
    }];
}

-(WKFlowButton *)createFlowButton{
    if (self.flowButton) {
        [self.flowButton removeFromSuperview];
    }
    NSDictionary *dic = [NSDictionary dicWithJsonStr:User.ShopTag];
    self.flowButton = [[WKFlowButton alloc]initWithFrame:CGRectMake(0, 0, WKScreenW-90, 78) andTitleArr:dic[@"titleArr"] andColorArr:dic[@"colorArr"] andFont:13 andType:flowButtonLeft :^(NSInteger index, NSString *content) {
        [self flowEvent];
    }];
    UITapGestureRecognizer *flowTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(flowEvent)];
    [self.flowButton addGestureRecognizer:flowTap];
    return self.flowButton;
}

-(void)flowEvent{
    if(_selectClickType)
    {
        _selectClickType(SelectTitles);
    }
}

-(void)btnEvent:(UIButton *)sender
{
    if(_selectClickType)
    {
        _selectClickType((ClickType)sender.tag);
    }
}

-(void)editEvent
{
    if(_selectClickType)
    {
        _selectClickType(SelectEditPerson);
    }
}

- (void)shopEvent:(UITapGestureRecognizer *)tap{
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"TAG" object:nil];
}

// MARK: 实体店认证
- (void)authenticationStore{
    if (self.selectClickType) {
        self.selectClickType(SelectAuthentiaction);
    }
}
-(void)promptViewShow:(NSString *)message{
    [WKPromptView showPromptView:message];
}
@end
