//
//  WKStoreCarriageView.m
//  秀加加
//  标题：运费设置
//  Created by lin on 16/9/8.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKStoreCarriageView.h"
#import "WKShowInputView.h"

@interface WKStoreCarriageView()
@end

@implementation WKStoreCarriageView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame])
    {
        [self addSubview];
    }
    return self;
}

-(void)addSubview
{
    self.transform = CGAffineTransformMakeScale(0.9, 0.9);
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.transform = CGAffineTransformMakeScale(1.2, 1.2);
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        
    }];

    UIView *centerView = [[UIView alloc] init];
    centerView.layer.masksToBounds = YES;
    centerView.layer.cornerRadius = 8.0;
    centerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(46);
        make.right.equalTo(self.mas_right).offset(-46);
        make.top.equalTo(self).offset((WKScreenH-150)/2);
        make.size.mas_equalTo(CGSizeMake(WKScreenW-46*2, 130));
    }];
    
    UITextField *money = [[UITextField alloc] init];
    money.placeholder = @"请设置默认运费";
    money.font = [UIFont systemFontOfSize:16];
    money.textColor = [UIColor colorWithHex:0x8E96AB];
    money.keyboardType = UIKeyboardTypeNumberPad;
    money.text = [NSString stringWithFormat:@"%.2f", User.ShopTranFee.floatValue];
    self.money = money;
    [centerView addSubview:money];
    [money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerView).offset(10);
        make.right.equalTo(centerView.mas_right).offset(-10);
        make.top.equalTo(centerView).offset(30);
        make.height.mas_equalTo(30);
    }];
    
    UIView *xianView = [[UIView alloc] init];
    xianView.backgroundColor = [UIColor colorWithHex:0x8E96AB];
    [centerView addSubview:xianView];
    [xianView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerView).offset(0);
        make.right.equalTo(centerView.mas_right).offset(0);
        make.bottom.equalTo(centerView.mas_bottom).offset(-45);
        make.height.mas_equalTo(1);
    }];
    
    UIButton *cancelBtn = [[UIButton alloc] init];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    cancelBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    cancelBtn.backgroundColor = [UIColor whiteColor];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithHex:0x8E96AB] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelEvent:) forControlEvents:UIControlEventTouchUpInside];
    [centerView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerView).offset(0);
        make.top.equalTo(xianView.mas_bottom).offset(0);
        make.size.mas_equalTo(CGSizeMake((WKScreenW-46*2)/2, 45));
    }];
    
    UIButton *sureBtn = [[UIButton alloc] init];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    sureBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    sureBtn.backgroundColor = [UIColor colorWithHex:0xE05F1F];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor colorWithHex:0x8E96AB] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureEvent:) forControlEvents:UIControlEventTouchUpInside];
    [centerView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(centerView.mas_right).offset(0);
        make.top.equalTo(xianView.mas_bottom).offset(0);
        make.size.mas_equalTo(CGSizeMake((WKScreenW-46*2)/2, 45));
    }];
}

-(void)cancelEvent:(UIButton *)sender
{
    [self removeFromSuperview];
}

-(void)sureEvent:(UIButton *)sender
{
    NSString *tranFee = self.money.text;
    if(![self isPureFloat:tranFee] || tranFee.floatValue < 0)
    {
        [WKPromptView showPromptView:@"请输入正确的运费"];
        return;
    }
    tranFee = [self roundFloat:tranFee.floatValue];
    
    NSString *url = [NSString configUrl:WKMemberUpdateInfo With:@[@"Key",@"Value"] values:@[[NSString stringWithFormat:@"%d",6],[NSString stringWithFormat:@"%@",tranFee]]];
    
    [WKHttpRequest GetStoreTranFee:HttpRequestMethodPost url:url model:nil param:nil success:^(WKBaseResponse *response) {
        [UIView animateWithDuration:0.2 animations:^{
            self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
            self.transform = CGAffineTransformMakeScale(1.2, 1.2);
            self.transform = CGAffineTransformMakeScale(0, 0);
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
        
        self.money.text = tranFee;
        User.ShopTranFee = tranFee;
        _tranFeeBlock(self.money.text);

    } failure:^(WKBaseResponse *response) {
        [WKPromptView showPromptView:response.ResultMessage];
    }];
}

//判断是否为浮点形：
- (BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

//进行四舍五入
-(NSString *)roundFloat:(float)price{
    NSString *newStr = [NSString stringWithFormat:@"%.2f",(floorf(price*100 + 0.5))/100];
    return newStr;
}

@end
