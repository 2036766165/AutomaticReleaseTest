//
//  WKStoreRechargeView.m
//  秀加加
//
//  Created by Chang_Mac on 16/12/14.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKStoreRechargeView.h"
#import <CoreGraphics/CoreGraphics.h>
#import "UIButton+MoreTouch.h"
#import "WKShowInputView.h"
@interface WKStoreRechargeView ()

@property (strong, nonatomic) UILabel * balanceNum;

@property (strong, nonatomic) NSMutableArray * topIMArr;

@property (strong, nonatomic) NSString * rechargeMoney;

@property (strong, nonatomic) UITextField * textField;



@end

@implementation WKStoreRechargeView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self createUI:NO];
        
    }
    return self;
}

//内购 BOOL 是否显示提示 View
-(void)createUI:(BOOL)prompt{
    self.topIMArr = [NSMutableArray new];
    
    UIImageView *backIM = [[UIImageView alloc]initWithFrame:self.frame];
    backIM.image = [UIImage imageNamed:@"recharge"];
    [self addSubview:backIM];

    UIView *backView = [[UIView alloc]init];
    backView.layer.cornerRadius = 10*WKScaleW;
    backView.layer.masksToBounds = YES;
    backView.layer.borderColor = [UIColor whiteColor].CGColor;
    backView.layer.borderWidth = 10;
    backView.layer.opacity = 0.5;
    [self addSubview:backView];
    _backView = backView;
    NSInteger top = 0;
    if (WKScreenW == 320) {
        top = 450;
    }else if(WKScreenW == 375){
        top = 435;
    }else{
        top = 425;
    }
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(0.09*WKScreenW);
        make.top.mas_offset((WKScreenH-top*WKScaleW)/2+10);
        make.right.mas_offset(-0.09*WKScreenW);
        make.bottom.mas_offset(-(WKScreenH-top*WKScaleW)/2+10);
    }];
    
    UIView *centerView = [[UIView alloc]init];
    centerView.layer.cornerRadius = 10*WKScaleW;
    centerView.layer.masksToBounds = YES;
    centerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(0.09*WKScreenW+5);
        make.top.mas_offset((WKScreenH-top*WKScaleW)/2+15);
        make.right.mas_offset(-0.09*WKScreenW-5);
        make.bottom.mas_offset(-(WKScreenH-top*WKScaleW)/2+5);
    }];
    
    self.balanceNum = [[UILabel alloc]init];
    self.balanceNum.textColor = [UIColor colorWithHexString:@"#FA6720"];
    self.balanceNum.font = [UIFont systemFontOfSize:36];
    self.balanceNum.textAlignment = NSTextAlignmentCenter;
    self.balanceNum.text = @"0.00";
    [centerView addSubview:self.balanceNum];
    [self.balanceNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.mas_offset(15);
        make.height.mas_offset(40);
    }];
    
    UILabel *balanceLabel = [[UILabel alloc]init];
    balanceLabel.text = @"账户余额";
    balanceLabel.textColor = [UIColor colorWithHexString:@"7e879d"];
    balanceLabel.font = [UIFont systemFontOfSize:14];
    balanceLabel.textAlignment = NSTextAlignmentCenter;
    [centerView addSubview:balanceLabel];
    [balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_offset(0);
        make.left.right.mas_offset(0);
        make.top.equalTo(self.balanceNum.mas_bottom).offset(5);
        make.height.mas_offset(16);
    }];
    
    UIView *firstLine = [[UIView alloc]init];
    firstLine.backgroundColor = [UIColor colorWithHexString:@"dae0ed"];
    [centerView addSubview:firstLine];
    [firstLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(balanceLabel.mas_bottom).offset(10);
        make.height.mas_offset(1);
    }];
    
    if (prompt) {
        UILabel *label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:18];
        NSString *str = [NSString stringWithFormat:@"亲，还不能正常充值哦，老大已经撸袖子去往苹果官方准备开架了，期盼老大凯旋吧！粉粉们可以移驾‘秀加加’微信公众号充值哦！"];
        label.numberOfLines = 0;
        label.textColor = [UIColor lightGrayColor];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:10];//调整行间距
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
        [centerView addSubview:label];
        label.attributedText = attributedString;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(firstLine.mas_bottom).offset(15);
            make.left.mas_offset(15);
            make.right.mas_offset(-15);
            make.height.mas_greaterThanOrEqualTo(10);
        }];
        
    }else{
        
        NSArray *payMoneyArr = @[@(6),@(30),@(60),@(100)];
        
        CGFloat  moneyX = (WKScreenW*0.8 - 200*WKScaleW)/3;
        for (int i = 0 ; i < 4 ; i ++ ) {
            UIButton *moneyBtn = [[UIButton alloc]init];
            [centerView addSubview:moneyBtn];
//            moneyBtn.backgroundColor = [UIColor redColor];
            moneyBtn.tag = i+1;
            [moneyBtn addTarget:self action:@selector(rechargeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [moneyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_offset(moneyX*WKScaleW + (moneyX+100)*WKScaleW*(i%2==0?0:1));
                make.top.equalTo(firstLine.mas_bottom).offset(5*WKScaleW + (120)*WKScaleW*(i>1?1:0));
                make.size.mas_offset(CGSizeMake(100*WKScaleW, 120*WKScaleW));
            }];
            
            UIImageView *topIM = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"recharge_a%d",i]]];
            topIM.tag = i+1;
            topIM.contentMode = UIViewContentModeScaleAspectFit;
            [self.topIMArr addObject:topIM];
            [moneyBtn addSubview:topIM];
            [topIM mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_offset(5);
                make.left.mas_offset(5);
                make.right.mas_offset(-5);
                make.height.mas_offset(80*WKScaleW);
            }];
            
//            UILabel *realityMoney = [[UILabel alloc]init];
//            realityMoney.text = @[@"4.2元",@"20.58元",@"41.16元",@"67.24元"][i];
//            realityMoney.textAlignment = NSTextAlignmentCenter;
//            realityMoney.font = [UIFont systemFontOfSize:14*WKScaleW];
//            realityMoney.textColor = [UIColor blackColor];
//            [topIM addSubview:realityMoney];
//            [realityMoney mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.right.mas_offset(0);
//                make.bottom.mas_offset(-9);
//                make.height.mas_greaterThanOrEqualTo(14);
//            }];
            
            UIView *bottomView = [[UIView alloc]init];
            bottomView.backgroundColor = [UIColor colorWithRed:250/255.0 green:182/255.0 blue:89/255.0 alpha:1];
            [moneyBtn addSubview:bottomView];
            [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_offset(-10);
                make.left.mas_offset(10);
                make.right.mas_offset(-10);
                make.height.mas_offset(8);
            }];
            
            UILabel *payMoneyLabel = [[UILabel alloc]init];
            payMoneyLabel.textColor = [UIColor blackColor];
            payMoneyLabel.font = [UIFont systemFontOfSize:16*WKScaleW];
            payMoneyLabel.text = [NSString stringWithFormat:@"%d元",[payMoneyArr[i] intValue]];
            payMoneyLabel.textAlignment = NSTextAlignmentCenter;
            [moneyBtn addSubview:payMoneyLabel];
            [payMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(bottomView.mas_bottom).offset(0);
                make.left.right.mas_offset(0);
                make.height.mas_offset(15);
            }];
        }
        
        self.textField = [[UITextField alloc]init];
        NSMutableParagraphStyle *style1 = [self.textField.defaultTextAttributes[NSParagraphStyleAttributeName] mutableCopy];
        style1.minimumLineHeight = self.textField.font.lineHeight - (self.textField.font.lineHeight - [UIFont systemFontOfSize:14].lineHeight) / 2.5; //[UIFont systemFontOfSize:13.0f]是设置的placeholder的字体
        self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您要充值的金额" attributes:@{NSParagraphStyleAttributeName : style1}];
        [self.textField setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
        self.textField.layer.cornerRadius = 5;
        self.textField.layer.borderColor = [UIColor colorWithHexString:@"dae0ed"].CGColor;
        self.textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
        self.textField.leftViewMode = UITextFieldViewModeAlways;
        self.textField.keyboardType = UIKeyboardTypeNumberPad;
        self.textField.layer.borderWidth = 1;
        [centerView addSubview:self.textField];
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(WKScreenW*0.05);
            make.top.equalTo(firstLine.mas_bottom).offset(290*WKScaleW-WKScreenW*0.1);
            make.height.mas_offset(WKScreenW*0.08);
            make.right.offset(-WKScreenW*0.05);
        }];
        
        UIView *secondLine = [[UIView alloc]init];
        secondLine.backgroundColor = [UIColor colorWithHexString:@"dae0ed"];
        [centerView addSubview:secondLine];
        [secondLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.top.equalTo(firstLine.mas_bottom).offset(290*WKScaleW);
            make.height.mas_offset(1);
        }];
        
//        UIButton *rechargeBtn = [[UIButton alloc]init];
//        rechargeBtn.backgroundColor = [UIColor colorWithHexString:@"#FA6720"];
//        [rechargeBtn setTitle:@"立即充值" forState: UIControlStateNormal];
//        rechargeBtn.titleLabel.font = [UIFont systemFontOfSize:16*WKScaleW];
//        rechargeBtn.layer.masksToBounds = YES;
//        rechargeBtn.tag = 10001;
//        rechargeBtn.touchInterval = 1;
//        [rechargeBtn addTarget:self action:@selector(rechargeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//        [centerView addSubview:rechargeBtn];
//        [rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.mas_offset(0);
//            make.width.mas_offset(WKScreenW*0.6);
//            make.top.equalTo(secondLine.mas_bottom).offset(15*WKScaleW);
//            make.bottom.mas_offset(-15*WKScaleW);
//        }];
//        [rechargeBtn layoutIfNeeded];
//        rechargeBtn.layer.cornerRadius = rechargeBtn.frame.size.height/2;
        
        UIButton *btn = [UIButton new];
        btn.tag = 4;
        [self rechargeBtnAction:btn];
        
        for (int i = 0 ; i < 2 ; i++ ) {
    
            UIButton *rechargeBtn = [[UIButton alloc]init];
            [rechargeBtn setTitle:@[@"微信支付",@"支付宝"][i] forState: UIControlStateNormal];
            [rechargeBtn setTitleColor:[UIColor colorWithHexString:@"7e879d"] forState:UIControlStateNormal];
            rechargeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 18, 0, 0);            rechargeBtn.titleLabel.font = [UIFont systemFontOfSize:14*WKScaleW];
            rechargeBtn.layer.masksToBounds = YES;
            rechargeBtn.layer.borderColor = [UIColor colorWithHexString:@[@"#41C837",@"#148CE1"][i]].CGColor;
            rechargeBtn.layer.borderWidth = 0.5;
            rechargeBtn.layer.cornerRadius = 5;
            rechargeBtn.tag = 100+i;
            rechargeBtn.touchInterval = 1;
            [rechargeBtn addTarget:self action:@selector(rechargeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [centerView addSubview:rechargeBtn];
            [secondLine layoutIfNeeded];
            [rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_offset(WKScreenW*0.1+i*(WKScreenW*0.35));
                make.width.mas_offset(WKScreenW*0.25);
                make.height.mas_offset(30*WKScaleW);
                make.top.equalTo(secondLine.mas_bottom).offset(8*WKScaleW);
            }];
            
            
            UIImageView *im = [[UIImageView alloc]init];
            im.image = [UIImage imageNamed:@[@"weixin1",@"zhifubao1"][i]];
            [rechargeBtn addSubview:im];
            [im mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.mas_offset(5);
                make.bottom.mas_offset(-5);
                make.width.equalTo(im.mas_height);
            }];
        }
    }
}

-(void)rechargeBtnAction:(UIButton *)btn{
    if (self.block && btn.tag>99) {//立即支付
        if (self.textField.text.length>0) {
            if ([self.textField.text integerValue] > 10000000) {
                [WKPromptView showPromptView:@"单笔最大充值10000000元"];
            }else if([self.textField.text integerValue] < 1){
                [WKPromptView showPromptView:@"请输入充值金额"];
            }else{
                self.block([NSString stringWithFormat:@"%@%@",self.textField.text,btn.tag == 100?@"w":@"z"]);
            }
        }else{
            self.block([NSString stringWithFormat:@"%@%@",self.rechargeMoney,btn.tag == 100?@"w":@"z"]);
        }
    }else{//选择支付金额
        for (UIImageView *item in self.topIMArr) {
            if (item.tag == btn.tag) {
                item.image = [UIImage imageNamed:[NSString stringWithFormat:@"recharge_%ld_",(long)item.tag-1]];
                self.rechargeMoney = @[@"6",@"30",@"60",@"100"][btn.tag-1];
                self.textField.text = self.rechargeMoney;
            }else{
                item.image = [UIImage imageNamed:[NSString stringWithFormat:@"recharge_a%ld",(long)item.tag-1]];
            }
        }
    }
}

-(void)refreshBalanceMoney:(NSString *)balanceMoney{
    self.balanceNum.text = [NSString stringWithFormat:@"%0.2f",[balanceMoney floatValue]];
}


@end







