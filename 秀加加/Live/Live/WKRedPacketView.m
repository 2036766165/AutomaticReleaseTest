//
//  WKRedPacketView.m
//  秀加加
//
//  Created by Chang_Mac on 17/3/14.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import "WKRedPacketView.h"
#import "WKSelectIndexView.h"
@interface WKRedPacketView ()<UITextFieldDelegate>

@property (strong, nonatomic) NSMutableArray * emojiArr;
@property (strong, nonatomic) UILabel *placeLabel;
@property (strong, nonatomic) UIButton * recordBtn;
@property (strong, nonatomic) UITextField * amountField;
@property (strong, nonatomic) UIView * recordView;
@property (strong, nonatomic) UILabel * allMoneyLabel;
@property (copy, nonatomic) NSString * redPacketNum;
@property (copy, nonatomic) NSString * redPacketPrice;
@property (strong, nonatomic) UITextView * textView;
@property (assign, nonatomic) BOOL  redPacketType;//no 手气红包, yes 普通红包
@property (strong, nonatomic) UILabel * balanceLabel;
@property (assign, nonatomic) CGFloat balance;


@end

@implementation WKRedPacketView{
    NSInteger _type;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame: frame]) {
        self.image = [UIImage imageNamed:@"background"];
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor redColor];
        self.redPacketType = NO;
        self.redPacketNum = @"0";
    }
    return self;
}
-(void)createControlWithType:(NSInteger)type{//创建控件
    _type = type;
    if (type == 1) {
        [self createOnceRedPackte];
    }else{
        [self createMoreRedPacket];
    }
}
-(void)createOnceRedPackte{//单人红包
    UILabel *sendUser = [[UILabel alloc]initWithFrame:CGRectMake(WKScreenW*0.05, WKScreenW*0.05, WKScreenW*0.9, WKScreenW*0.04)];
    sendUser.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"准备发给%@",self.memberName]];
    [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"333333"] range:NSMakeRange(4, self.memberName.length)];
    sendUser.textColor = [UIColor colorWithHexString:@"7e879d"];
    sendUser.attributedText = attribute;
    sendUser.font = [UIFont systemFontOfSize:WKScreenW*0.04];
    [self addSubview:sendUser];
    
    [self redPacketView];
    [self addSubview:[self inputAmountViewWithDic:@{@"title":@"金额",@"placeholder":@"填写金额",@"unit":@"元"} andY:WKScreenW*0.74]];
    [self addSubview:[self bottomViewWithY:WKScreenW*0.9]];
    
}
-(void)setUserBalance:(NSString *)balance{
    NSString * str = [NSString stringWithFormat:@"使用账户余额付款(余额%0.2f元),充值",[balance doubleValue]];
    NSMutableAttributedString *attribut = [[NSMutableAttributedString alloc]initWithString:str];
    [attribut addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"1690e9"] range:NSMakeRange(str.length-2, 2)];
    self.balanceLabel.attributedText = attribut;
    self.balance = balance.doubleValue;
}
-(void)createMoreRedPacket{//多人红包
    self.recordView = [self inputAmountViewWithDic:@{@"title":@"总金额",@"placeholder":@"填写金额",@"unit":@"元"} andY:WKScreenW*0.1];
    [self addSubview: self.recordView];

    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(WKScreenW*0.08, WKScreenW*0.27, WKScreenW*0.9, WKScreenW*0.05)];
    label.font = [UIFont systemFontOfSize:WKScreenW*0.035];
    label.textColor = [UIColor colorWithHexString:@"7e879d"];
    NSString * str = @"当前为拼手气红包,改为普通红包";
    NSMutableAttributedString *attribut = [[NSMutableAttributedString alloc]initWithString:str];
    [attribut addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"ff6250"] range:NSMakeRange(str.length-6, 6)];
    label.attributedText = attribut;
    label.userInteractionEnabled = YES;
    [self addSubview:label];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(WKScreenW*0.3, 0, WKScreenW*0.3, WKScreenW*0.05)];
    btn.tag = 1010;
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [label addSubview: btn];
    
    [self addSubview:[self inputAmountViewWithDic:@{@"title":@"红包个数",@"placeholder":@"填写个数",@"unit":@"个"} andY:WKScreenW*0.35]];
    
    UILabel *hintLabel = [[UILabel alloc]initWithFrame:CGRectMake(WKScreenW*0.08, WKScreenW*0.5, WKScreenW*0.9, WKScreenW*0.05)];
    hintLabel.font = [UIFont systemFontOfSize:WKScreenW*0.035];
    hintLabel.textColor = [UIColor colorWithHexString:@"7e879d"];
    hintLabel.text = [NSString stringWithFormat:@"当前直播间人数%ld人",(long)self.userCount];

    [self addSubview:hintLabel];
    [self addSubview: [self bottomViewWithY:WKScreenW*0.6]];
    
    UILabel *bottomlabel = [[UILabel alloc]initWithFrame:CGRectMake(WKScreenW*0.08, WKScreenW*1.4, WKScreenW*0.84, WKScreenW*0.05)];
    bottomlabel.font = [UIFont systemFontOfSize:WKScreenW*0.035];
    bottomlabel.textColor = [UIColor colorWithHexString:@"a5a5a5"];
    bottomlabel.text = [NSString stringWithFormat:@"对方可领取的红包金额为0.01~%@元",self.maxAmount?self.maxAmount:@"200"];
    bottomlabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:bottomlabel];
    
}

-(void)btnAction:(UIButton *)btn{
    if(btn.tag >= 1000 && btn.tag<=1007){//1000-1007 红包 1008发红包 1009充值
        [btn setBackgroundImage:[UIImage imageNamed:@"Individual-red-envelopes9"] forState:UIControlStateNormal];
        self.amountField.text = @[@"0.01",@"0.1",@"0.5",@"1.0",@"5.0",@"10",@"50",@"100"][btn.tag-1000];
        [self.recordBtn setBackgroundImage:[UIImage imageNamed:@"Individual-red-envelopes10"] forState:UIControlStateNormal];
        self.recordBtn = btn;
        self.allMoneyLabel.text = [NSString stringWithFormat:@"¥ %@",self.amountField.text];
    }else if (btn.tag == 1008 ){
        NSString *allMoney = [self.allMoneyLabel.text stringByReplacingOccurrencesOfString:@"¥" withString:@""];
        if ([allMoney doubleValue]/[self.redPacketNum doubleValue]<0.01 || allMoney.doubleValue == 0) {
            [WKPromptView showPromptView:@"单个红包最小金额为0.01元"];
            return;
        }
        NSDictionary *dic = @{@"BagAmount":allMoney,@"BagCount":self.redPacketNum,@"BagMessage":self.textView.text,@"BagType":[NSString stringWithFormat:@"%d",self.redPacketType?1:2]};
        if (self.callBack) {
            self.callBack(sendRedPacketType,dic);
        }
    }else if (btn.tag == 1009 ){
        if (self.callBack) {
            self.callBack(rechargeType,nil);
        }
    }else if(btn.tag == 1010){
        btn.selected = !btn.selected;
        self.redPacketType = btn.selected;
        self.allMoneyLabel.text = [NSString stringWithFormat:@"¥ 0.00"];
        UILabel *label = (UILabel *)btn.superview;
        [self.recordView removeFromSuperview];
        if (btn.selected) {
            NSString * str = @"当前为普通红包,改为拼手气红包";
            NSMutableAttributedString *attribut = [[NSMutableAttributedString alloc]initWithString:str];
            [attribut addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"ff6250"] range:NSMakeRange(str.length-7, 7)];
            label.attributedText = attribut;
            self.recordView = [self inputAmountViewWithDic:@{@"title":@"单个金额",@"placeholder":@"填写金额",@"unit":@"元"} andY:WKScreenW*0.1];
            [self addSubview: self.recordView];
        }else{
            NSString * str = @"当前为拼手气红包,改为普通红包";
            NSMutableAttributedString *attribut = [[NSMutableAttributedString alloc]initWithString:str];
            [attribut addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"ff6250"] range:NSMakeRange(str.length-6, 6)];
            label.attributedText = attribut;
            self.recordView = [self inputAmountViewWithDic:@{@"title":@"总金额",@"placeholder":@"填写金额",@"unit":@"元"} andY:WKScreenW*0.1];
            [self addSubview:self.recordView];
        }
        
    }
}
//下面公共的 view
-(UIView *)bottomViewWithY:(CGFloat)originY{
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, originY, WKScreenW, WKScreenW*0.7)];
    
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(WKScreenW*0.05, 0, WKScreenW*0.9, WKScreenW*0.18)];
    backgroundView.layer.cornerRadius = 10;
    backgroundView.layer.borderColor = [UIColor colorWithHexString:@"dae0ed"].CGColor;
    backgroundView.backgroundColor = [UIColor whiteColor];
    backgroundView.layer.borderWidth = 1;
    [bottomView addSubview:backgroundView];
    
    UITextView *leaveView = [[UITextView alloc]initWithFrame:CGRectMake(WKScreenW*0.04, 0, WKScreenW*0.8, WKScreenW*0.18)];
    leaveView.delegate = self;
    leaveView.font = [UIFont systemFontOfSize:WKScreenW*0.045];
    leaveView.textColor = [UIColor colorWithHexString:@"7e879d"];
    [backgroundView addSubview:leaveView];
    self.textView = leaveView;
    
    UILabel *placeLabel = [[UILabel alloc]initWithFrame:CGRectMake(WKScreenW*0.01, WKScreenW*0.02, WKScreenW*0.5, WKScreenW*0.05)];
    placeLabel.textColor = [UIColor colorWithHexString:@"7e879d"];
    placeLabel.alpha = 0.7;
    placeLabel.text = self.content;
    placeLabel.font = [UIFont systemFontOfSize:WKScreenW*0.04];
    [leaveView addSubview:placeLabel];
    self.placeLabel = placeLabel;
    
    UILabel *allMoney = [[UILabel alloc]initWithFrame:CGRectMake(WKScreenW*0.05, WKScreenW*0.225, WKScreenW*0.9, WKScreenW*0.13)];
    allMoney.text = @"¥ 0.00";
    allMoney.font = [UIFont systemFontOfSize:WKScreenW*0.12];
    allMoney.textColor = [UIColor blackColor];
    allMoney.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:allMoney];
    self.allMoneyLabel = allMoney;
    
    UIButton *submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(WKScreenW*0.05, WKScreenW*0.4, WKScreenW*0.9, WKScreenW*0.12)];
    submitBtn.backgroundColor = [UIColor colorWithHexString:@"ff5345"];
    [submitBtn setTitle:@"塞钱发红包" forState:UIControlStateNormal];
    submitBtn.layer.cornerRadius = WKScreenW*0.06;
    [submitBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.tag = 1008;
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:WKScreenW*0.04];
    [bottomView addSubview:submitBtn];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(WKScreenW*0.05, WKScreenW*0.58, WKScreenW*0.9, WKScreenW*0.05)];
    label.font = [UIFont systemFontOfSize:WKScreenW*0.035];
    label.textColor = [UIColor colorWithHexString:@"333333"];
    label.textAlignment = NSTextAlignmentCenter;
    NSString * str = @"使用账户余额付款(余额0元),充值";
    NSMutableAttributedString *attribut = [[NSMutableAttributedString alloc]initWithString:str];
    [attribut addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"1690e9"] range:NSMakeRange(str.length-2, 2)];
    label.attributedText = attribut;
    label.userInteractionEnabled = YES;
    [bottomView addSubview:label];
    self.balanceLabel = label;
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(WKScreenW*0.6, 0, WKScreenW*0.3, WKScreenW*0.05)];
    btn.tag = 1009;
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [label addSubview: btn];
    return bottomView;
}

//输入金额
-(UIView *)inputAmountViewWithDic:(NSDictionary *)dic andY:(CGFloat)originY{
    
    UIView *amountView = [[UIView alloc]initWithFrame:CGRectMake(WKScreenW*0.05, originY, WKScreenW*0.9, WKScreenW*0.14)];
    amountView.backgroundColor = [UIColor whiteColor];
    amountView.layer.cornerRadius = 10;
    amountView.layer.borderColor = [UIColor colorWithHexString:@"dae0ed"].CGColor;
    amountView.layer.borderWidth = 1;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(WKScreenW*0.05, 0, WKScreenW*0.2, WKScreenW*0.14)];
    label.text = dic[@"title"];
    label.font = [UIFont systemFontOfSize:WKScreenW*0.045];
    label.textColor = [UIColor colorWithHexString:@"7e879d"];
    [amountView addSubview:label];
    
    if ([dic[@"title"] isEqualToString:@"总金额"]) {
        CGSize size = [label.text sizeOfStringWithFont:[UIFont systemFontOfSize:WKScreenW*0.05] withMaxSize:CGSizeMake(MAXFLOAT, WKScreenW*0.045)];
        label.frame = CGRectMake(WKScreenW*0.05, 0, size.width, WKScreenW*0.14);
        UIImageView *im = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), WKScreenW*0.05, WKScreenW*0.06, WKScreenW*0.04)];
        im.image = [UIImage imageNamed:@"pin"];
        [amountView addSubview:im];
    }
    
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(WKScreenW*0.35, WKScreenW*0.025, WKScreenW*0.55, WKScreenW*0.1)];
    textField.rightViewMode = UITextFieldViewModeAlways;
    textField.textColor = [UIColor colorWithHexString:@"7e879d"];
    textField.textAlignment = NSTextAlignmentRight;
    textField.keyboardType = UIKeyboardTypeDecimalPad;
    textField.font = [UIFont systemFontOfSize:WKScreenW*0.04];
    self.amountField = textField;
    if ([dic[@"title"] isEqualToString:@"红包个数"]){
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    textField.delegate = self;
    NSMutableParagraphStyle *style1 = [[NSMutableParagraphStyle alloc]init];
    style1.minimumLineHeight = textField.font.lineHeight - (textField.font.lineHeight - [UIFont systemFontOfSize:WKScreenW*0.04].lineHeight) / 2.5;
    NSAttributedString *attriStr = [[NSAttributedString alloc]initWithString:dic[@"placeholder"] attributes:@{
                            @"NSForegroundColorAttributeName":[[UIColor colorWithHexString:@"7e879d"] colorWithAlphaComponent:0.7],
                            @"NSParagraphStyleAttributeName":style1
                        }];
    textField.attributedPlaceholder = attriStr;
    [textField setValue:[UIFont systemFontOfSize:WKScreenW*0.04] forKeyPath:@"_placeholderLabel.font"];
    
    [amountView addSubview:textField];
    
    UILabel *rightView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WKScreenW*0.15, WKScreenW*0.045)];
    rightView.font = [UIFont systemFontOfSize:WKScreenW*0.045];
    rightView.textColor = [UIColor colorWithHexString:@"7e879d"];
    rightView.text = [NSString stringWithFormat:@"  %@",dic[@"unit"]];
    textField.rightView = rightView;
    
    return amountView;
}
//红包
-(void)redPacketView{
    NSArray *titleArr = @[@"0.01\n元",@"0.1\n元",@"0.5\n元",@"1.0\n元",@"5.0\n元",@"10\n元",@"50\n元",@"100\n元"];
    for (int index = 0 ; index < 8 ; index++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(WKScreenW*0.07+((index%4)*WKScreenW*0.225), WKScreenW*0.15+(floor(index/4)*WKScreenW*0.28), WKScreenW*0.18, WKScreenW*0.26)];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 1000+index;
        UIImage *image = [UIImage imageNamed:@"Individual-red-envelopes1"];
        [btn setBackgroundImage:[UIImage imageNamed:@"Individual-red-envelopes10"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"Individual-red-envelopes%d",index+1]] forState:UIControlStateNormal];
        btn.imageEdgeInsets = UIEdgeInsetsMake(-WKScreenW*0.15, 0, 0, 0);

        btn.titleLabel.numberOfLines = 2;
        btn.titleLabel.font = [UIFont systemFontOfSize:WKScreenW*0.04];
        btn.titleEdgeInsets = UIEdgeInsetsMake(WKScreenW*0.06, -image.size.width, 0, 0);

        NSString *title = titleArr[index];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
        [style setLineSpacing:WKScreenW*0.01];
        [style setAlignment:NSTextAlignmentCenter];
        
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:title];
        [attributedStr addAttribute: NSFontAttributeName value:[UIFont systemFontOfSize: WKScreenW*0.03] range: NSMakeRange(title.length-1, 1)];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#FFFFCC"] range:NSMakeRange(0, title.length)];
        
        [attributedStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, title.length)];
        [btn setAttributedTitle:attributedStr forState:UIControlStateNormal];
        
        [self addSubview:btn];
    }
    
}

#pragma mark textView Delegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(nonnull NSString *)text{
    if([self stringContainsEmoji:text]){
        [self.emojiArr addObject:text];
    }
    UITextRange *selectedRange = [textView markedTextRange];
    NSString * posStr = [textView textInRange:selectedRange];
    NSMutableString * removePosStr = [textView.text stringByReplacingOccurrencesOfString:posStr withString:@""].mutableCopy;
    if (removePosStr.length + text.length>10) {
        NSInteger index = 10;
        [removePosStr insertString:text atIndex:range.location];
            NSString *emojiStr = [self.emojiArr lastObject];
            NSString *str = [removePosStr substringWithRange:NSMakeRange(removePosStr.length-emojiStr.length, emojiStr.length)];
            if ([emojiStr isEqualToString:str]) {
                index = removePosStr.length - emojiStr.length;
                [self.emojiArr removeLastObject];
            }
        textView.text = [removePosStr substringToIndex:index];
        return NO;
    }
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length>0) {
        self.placeLabel.hidden = YES;
    }else{
        self.placeLabel.hidden = NO;
    }
}
#pragma mark textfield delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
//    textField.text = @"";
    [self.recordBtn setBackgroundImage:[UIImage imageNamed:@"Individual-red-envelopes10"] forState:UIControlStateNormal];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (_type == 1) {
        self.allMoneyLabel.text = [NSString stringWithFormat:@"¥ %0.2f",[textField.text doubleValue]];
    }else if([textField.placeholder isEqualToString:@"填写个数"]){
        self.redPacketNum = textField.text;
        if (self.redPacketType) {
            self.allMoneyLabel.text = [NSString stringWithFormat:@"¥ %0.2f",[self.redPacketNum doubleValue]*[self.redPacketPrice doubleValue]];
        }
    }else if ([textField.placeholder isEqualToString:@"填写金额"]){
        self.redPacketPrice = textField.text;
        if (self.redPacketType) {
            self.allMoneyLabel.text = [NSString stringWithFormat:@"¥ %0.2f",[self.redPacketNum doubleValue]*[self.redPacketPrice doubleValue]];
        }else{
            self.allMoneyLabel.text = [NSString stringWithFormat:@"¥ %0.2f",[self.redPacketPrice doubleValue]];
        }
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField.text.length>=9 && string.length>0 && [textField.placeholder isEqualToString:@"填写金额"]) {
//        textField.text = @"999999999";
        return NO;
    }
    return YES;
}
-(BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}
-(NSMutableArray *)emojiArr{
    if (!_emojiArr) {
        _emojiArr = [NSMutableArray new];
    }
    return _emojiArr;
}

@end



