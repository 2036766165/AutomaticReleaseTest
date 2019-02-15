
//
//  WKStoreIncomView.m
//  秀加加
//
//  Created by Chang_Mac on 16/9/28.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKStoreIncomView.h"

@interface WKStoreIncomView ()

@property (strong, nonatomic) UILabel * priceNum;

@property (strong, nonatomic) UILabel * backCard;

@property (strong, nonatomic) NSMutableArray * dataArray;

@property (strong, nonatomic) UIImageView * statusIM;

@property (strong, nonatomic) UIButton *withdrawDeposit;

@property (strong, nonatomic) UILabel * label;

@property (strong, nonatomic) UILabel *allMoneyLabel;

@property (strong, nonatomic) UILabel * zhiyi;

@property (strong, nonatomic) UILabel * label1;

@property (assign, nonatomic) incomeType type;

@end

@implementation WKStoreIncomView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createMainUI];
    }
    return self;
}

-(void)createMainUI{
    self.type = copyType;
    self.dataArray = [NSMutableArray new];
    self.backgroundColor = [UIColor colorWithHexString:@"f3f6ff"];
    
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.mas_offset(70);
        make.height.mas_offset(290);
    }];
    
    self.allMoneyLabel = [[UILabel alloc]init];
    self.allMoneyLabel.text = @"总余额";
    self.allMoneyLabel.font = [UIFont systemFontOfSize:12];
    self.allMoneyLabel.textColor = [UIColor grayColor];
    self.allMoneyLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:self.allMoneyLabel];
    [self.allMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(20);
        make.size.sizeOffset(CGSizeMake(WKScreenW-40, 15));
    }];
    
    self.priceNum = [[UILabel alloc]init];
    self.priceNum.textColor = [UIColor orangeColor];
    self.priceNum.font = [UIFont systemFontOfSize:35];
    self.priceNum.text = @"0.00";
    self.priceNum.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:self.priceNum];
    [self.priceNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(-20);
        make.top.equalTo(self.allMoneyLabel.mas_bottom).offset(5);
        make.size.sizeOffset(CGSizeMake(80, 36));
    }];
    
    UIImage *certificationImage = [UIImage imageNamed:@"weirenzheng"];
    NSString *certificationStr = @"未认证";
    self.statusIM = [[UIImageView alloc]initWithImage:certificationImage];
    [backView addSubview:self.statusIM];
    [self.statusIM mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceNum.mas_right).offset(10);
        make.centerY.equalTo(self.priceNum.mas_centerY).offset(0);
        make.size.sizeOffset(CGSizeMake(18, 20));
    }];
    
    self.label = [[UILabel alloc]init];
    self.label.font = [UIFont systemFontOfSize:12];
    self.label.textColor = [UIColor grayColor];
    self.label.text = certificationStr;
    [backView addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.statusIM.mas_right).offset(5);
        make.centerY.equalTo(self.statusIM.mas_centerY);
        make.size.sizeOffset(CGSizeMake(50, 20));
    }];
    
    UIView *line1 = [[UIView alloc]init];
    line1.backgroundColor = [UIColor colorWithHexString:@"dae0ed"];
    [backView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.equalTo(self.priceNum.mas_bottom).offset(20);
        make.size.sizeOffset(CGSizeMake(WKScreenW, 0.5));
    }];
    
    for (int i = 0 ; i < 3 ; i ++ ) {
        UIImageView *picIM = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@[@"Personal_jine1",@"Personal_jine2",@"Personal_jine3"][i]]];
        [backView addSubview:picIM];
        [picIM mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(WKScreenW/3*i+(WKScreenW/3-28)/2);
            make.top.equalTo(line1.mas_bottom).offset(20);
            make.size.sizeOffset(CGSizeMake(28, 25));
        }];
        NSArray *labelArr;
        if (User.isReviewID) {
            labelArr = @[@"余额",@"交易中",@"已完成"];
        }else{
            labelArr = @[@"可提现金额",@"交易中金额",@"已提现金额"];
        }
        UILabel *label = [[UILabel alloc]init];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor grayColor];
        label.text = labelArr[i];
        [backView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(WKScreenW/3*i);
            make.top.equalTo(picIM.mas_bottom).offset(15);
            make.size.sizeOffset(CGSizeMake(WKScreenW/3, 15));
        }];
        
        UILabel *moneyLabel = [[UILabel alloc]init];
        moneyLabel.textAlignment = NSTextAlignmentCenter;
        moneyLabel.font = [UIFont systemFontOfSize:16];
        moneyLabel.tag = i+1;
        moneyLabel.textColor = [UIColor colorWithHexString:@"7e879d"];
        [self.dataArray addObject:moneyLabel];
        NSMutableAttributedString *attributedStr01 = [[NSMutableAttributedString alloc] initWithString: @[@"¥0.00",@"¥0.00",@"¥0.00"][i]];
        //字号
        [attributedStr01 addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:12] range: NSMakeRange(0, 1)];
        moneyLabel.attributedText = attributedStr01;
        [backView addSubview:moneyLabel];
        [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(WKScreenW/3*i);
            make.top.equalTo(label.mas_bottom).offset(15);
            make.size.sizeOffset(CGSizeMake(WKScreenW/3, 15));
        }];
    }
    
    UIView *line2 = [[UIView alloc]init];
    line2.backgroundColor = [UIColor colorWithHexString:@"dae0ed"];
    [backView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.equalTo(line1.mas_bottom).offset(130);
        make.size.sizeOffset(CGSizeMake(WKScreenW, 0.5));
    }];
    
    UIButton *payMentDetailsBtn = [[UIButton alloc]init];
    [payMentDetailsBtn setImage:[UIImage imageNamed:@"Personal_mingxi"] forState:UIControlStateNormal];
    payMentDetailsBtn.tag = 103;
    [payMentDetailsBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [payMentDetailsBtn setTitle:@"  收支明细" forState: UIControlStateNormal];
    [payMentDetailsBtn setTitleColor:[UIColor colorWithHexString:@"7e879d"] forState:UIControlStateNormal];
    payMentDetailsBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    payMentDetailsBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [backView addSubview:payMentDetailsBtn];
    [payMentDetailsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(25);
        make.right.mas_offset(0);
        make.top.equalTo(line2.mas_bottom).offset(0);
        make.bottom.equalTo(backView.mas_bottom).offset(0);
    }];
    
    UIImageView *arrowIM = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Personal_right_arrow"]];
    [payMentDetailsBtn addSubview:arrowIM];
    [arrowIM mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-20);
        make.centerY.equalTo(payMentDetailsBtn.mas_centerY);
        make.size.sizeOffset(CGSizeMake(6, 10));
    }];
    
    UIButton *withDrawbtn = [[UIButton alloc]init];
    [withDrawbtn setImage:[UIImage imageNamed:@"Personal_tixian"] forState:UIControlStateNormal];
    [withDrawbtn setTitleColor:[UIColor colorWithHexString:@"7e879d"] forState:UIControlStateNormal];
    withDrawbtn.backgroundColor = [UIColor whiteColor];
    [withDrawbtn setTitle:@"  提现认证" forState: UIControlStateNormal];
    withDrawbtn.titleLabel.font = [UIFont systemFontOfSize:16];
    withDrawbtn.layer.masksToBounds = YES;
    withDrawbtn.tag = 100;
    [withDrawbtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:withDrawbtn];
    [withDrawbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.top.equalTo(backView.mas_bottom).offset(20);
        make.size.sizeOffset(CGSizeMake((WKScreenW-30)/2, 50));
    }];
    [withDrawbtn layoutIfNeeded];
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:withDrawbtn.bounds byRoundingCorners: UIRectCornerBottomLeft| UIRectCornerTopLeft cornerRadii:CGSizeMake(25, 25)];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = bezierPath.CGPath;
    shapeLayer.strokeColor = [UIColor grayColor].CGColor;
    withDrawbtn.layer.mask = shapeLayer;
    CAShapeLayer *colorLayer = [CAShapeLayer layer];
    colorLayer.path = bezierPath.CGPath;
    colorLayer.fillColor = [UIColor clearColor].CGColor;
    colorLayer.strokeColor = [UIColor colorWithHexString:@"dae0ed"].CGColor;
    colorLayer.lineWidth = 1;
    colorLayer.frame=withDrawbtn.bounds;
    [withDrawbtn.layer addSublayer:colorLayer];
    self.withdrawDeposit = withDrawbtn;
    
    UIButton *rechargeBtn = [[UIButton alloc]init];
    [rechargeBtn setImage:[UIImage imageNamed:@"Personal_chongzhi"] forState:UIControlStateNormal];
    [rechargeBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    rechargeBtn.tag = 101;
    rechargeBtn.backgroundColor = [UIColor whiteColor];
    [rechargeBtn setTitle:@"  充值" forState: UIControlStateNormal];
    rechargeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    rechargeBtn.layer.masksToBounds = YES;
    [rechargeBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rechargeBtn];
    [rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(WKScreenW/2);
        make.top.equalTo(backView.mas_bottom).offset(20);
        make.size.sizeOffset(CGSizeMake((WKScreenW-30)/2, 50));
    }];
    [rechargeBtn layoutIfNeeded];
    UIBezierPath *bezierPath1 = [UIBezierPath bezierPathWithRoundedRect:withDrawbtn.bounds byRoundingCorners: UIRectCornerBottomRight| UIRectCornerTopRight cornerRadii:CGSizeMake(25, 25)];
    CAShapeLayer *shapeLayer1 = [CAShapeLayer layer];
    shapeLayer1.path = bezierPath1.CGPath;
    shapeLayer1.strokeColor = [UIColor grayColor].CGColor;
    rechargeBtn.layer.mask = shapeLayer1;
    CAShapeLayer *colorLayer1 = [CAShapeLayer layer];
    colorLayer1.path = bezierPath1.CGPath;
    colorLayer1.fillColor = [UIColor clearColor].CGColor;
    colorLayer1.strokeColor = [UIColor colorWithHexString:@"dae0ed"].CGColor;
    colorLayer1.lineWidth = 1;
    colorLayer1.frame=rechargeBtn.bounds;
    [rechargeBtn.layer addSublayer:colorLayer1];
    
//    UIImage *withdrawImage = [UIImage imageNamed:@"tixian"];
//    NSString *withdrawStr = @"  提现认证";
//    self.withdrawDeposit = [[UIButton alloc]init];
//    self.withdrawDeposit.layer.borderColor = [UIColor orangeColor].CGColor;
//    self.withdrawDeposit.layer.borderWidth = 1;
//    self.withdrawDeposit.layer.cornerRadius = 3;
//    self.withdrawDeposit.layer.masksToBounds = YES;
//    [self.withdrawDeposit setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
//    self.withdrawDeposit.tag = 100;
//    [self.withdrawDeposit setImage:withdrawImage forState:UIControlStateNormal];
//    self.withdrawDeposit.titleLabel.font = [UIFont systemFontOfSize:16];
//    [self.withdrawDeposit setTitle:withdrawStr forState:UIControlStateNormal];
//    [self.withdrawDeposit addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:self.withdrawDeposit];
//    [self.withdrawDeposit mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(10);
//        make.top.equalTo(backView.mas_bottom).offset(30);
//        make.size.sizeOffset(CGSizeMake(WKScreenW-20, 40));
//    }];
    
//    UIButton *rechargeBtn = [[UIButton alloc]init];
//    [rechargeBtn setImage:[UIImage imageNamed:@"chargeIcon"] forState:UIControlStateNormal];
//    [rechargeBtn setTitle:@"  充值" forState:UIControlStateNormal];
//    rechargeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//    [rechargeBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
//    rechargeBtn.tag = 101;
//    rechargeBtn.layer.borderColor = [UIColor orangeColor].CGColor;
//    rechargeBtn.layer.borderWidth = 1;
//    rechargeBtn.layer.cornerRadius = 3;
//    rechargeBtn.layer.masksToBounds = YES;
//
//    [rechargeBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:rechargeBtn];
//    [rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(10);
//        make.top.equalTo(self.withdrawDeposit.mas_bottom).offset(15);
//        make.size.sizeOffset(CGSizeMake(WKScreenW-20, 40));
//    }];
    
    self.zhiyi = [[UILabel alloc]init];
    self.zhiyi.text = @"认证步骤";
    self.zhiyi.textColor = [UIColor redColor];
    self.zhiyi.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.zhiyi];
    [self.zhiyi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(rechargeBtn.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    
    self.label1 = [[UILabel alloc]init];
    NSString *str = [NSString stringWithFormat:@"1.点击提现认证按钮获取提现验证码\n2.关注 “秀加加” 公众号 “提现” 菜单中粘贴验证码,完成验证\n3.返回show++应用,操作提现,提现金额将在48小时内转入微信零钱包 "];
    self.label1.numberOfLines = 0;
    self.label1.textColor = [UIColor lightGrayColor];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:10];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
    self.label1.attributedText = attributedString;
    self.label1.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.label1];
    [self.label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self.zhiyi.mas_bottom).offset(5);
        make.width.mas_offset(WKScreenW-20);
        make.height.mas_greaterThanOrEqualTo(100);
    }];
    
    if (User.isReviewID) {//上线判断
        withDrawbtn.hidden = YES;
        self.label1.hidden = YES;
        self.zhiyi.hidden = YES;
        rechargeBtn.hidden = YES;
    }
}

-(void)refreshDataWithData:(WKIncomeModel *)model{
    CGSize size = [[NSString stringWithFormat:@"%0.2f",[model.TotalBalance floatValue]] sizeOfStringWithFont:[UIFont systemFontOfSize:35] withMaxSize:CGSizeMake(MAXFLOAT, 25)];
    [self.priceNum mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(-20);
        make.top.equalTo(self.allMoneyLabel.mas_bottom).offset(5);
        make.size.sizeOffset(CGSizeMake(size.width+3, 36));
    }];
    [self.priceNum layoutIfNeeded];
    self.priceNum.text = [NSString stringWithFormat:@"%0.2f",[model.TotalBalance floatValue]];
    for (int i = 0 ; i < self.dataArray.count; i++ ) {
        UILabel *label = self.dataArray[i];
        switch (i) {
            case 0:
                label.text = [NSString stringWithFormat:@"¥%0.2f",[model.MoneyCanTake floatValue]];
                break;
            case 1:
                label.text = [NSString stringWithFormat:@"¥%0.2f",[model.MoneyInBusiness floatValue]];
                break;
            case 2:
                label.text = [NSString stringWithFormat:@"¥%0.2f",[model.MoneyTaked floatValue]];
                break;
        }
    }
    if ([model.IsCheck boolValue]) {
        self.type = withDrawType;
//        [self.withdrawDeposit setImage:[UIImage imageNamed:@"shouru"] forState:UIControlStateNormal]; ;
        [self.withdrawDeposit setTitle:@"  提现" forState:UIControlStateNormal];
//        self.withdrawDeposit.backgroundColor = [UIColor colorWithHexString:@"ff6600"];
//        [self.withdrawDeposit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.label1.hidden = YES;
        self.zhiyi.hidden = YES;
        self.statusIM.image = [UIImage imageNamed:@"renzheng-2"];
        self.label.text = @"已认证";
        }
}

-(void)buttonAction:(UIButton *)btn{
    if (self.block) {
        if (btn.tag == 100) {
            self.block(self.type);
        }
        else if(btn.tag == 103){
            self.block(incomeDetailsType);
        }
        else if (btn.tag == 101){
            self.block(rechargeType);
        }
    }
}

@end
