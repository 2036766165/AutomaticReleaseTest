//
//  WKIncomeTestView.m
//  秀加加
//
//  Created by Chang_Mac on 16/10/10.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKIncomeTestView.h"

@implementation WKIncomeTestView

+(void)incomeTest:(NSString *)testString{
    WKIncomeTestView *incomeText = [[WKIncomeTestView alloc]initWithFrame:CGRectMake(0, 0, WKScreenW, WKScreenH)];
    incomeText.backgroundColor = [UIColor clearColor];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:incomeText];
    
    incomeText.backView = [[UIView alloc]initWithFrame:CGRectMake(WKScreenW*0.1, WKScreenH*0.3, WKScreenW*0.8, WKScreenW*0.4)];
    incomeText.backView.backgroundColor = [UIColor whiteColor];
    incomeText.backView.hidden = YES;
    incomeText.backView.layer.cornerRadius = 10;
    incomeText.backView.layer.masksToBounds = NO;
    [incomeText addSubview:incomeText.backView];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [UIColor colorWithHexString:@"7e879d"];
    titleLabel.text = @"提取验证码";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [incomeText.backView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(30);
        make.top.mas_offset(15);
        make.right.mas_offset(-30);
        make.height.mas_offset(17);
    }];
    
    UIButton *backButton = [[UIButton alloc]init];
    [backButton setImage:[UIImage imageNamed:@"exit"] forState:UIControlStateNormal];
    [backButton addTarget:incomeText action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [incomeText.backView addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(5);
        make.right.mas_offset(-15);
        make.size.mas_offset(CGSizeMake(30, 30));
    }];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"f3f6ff"];
    [incomeText.backView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(20);
        make.top.mas_offset(incomeText.backView.frame.size.height*0.6);
        make.right.mas_offset(-20);
        make.height.mas_offset(1);
    }];
    
    UILabel *testLabel = [[UILabel alloc]init];
    testLabel.font = [UIFont systemFontOfSize:14];
    testLabel.text = testString;
    testLabel.textAlignment = NSTextAlignmentCenter;
    testLabel.textColor = [UIColor colorWithHexString:@"ff6600"];
    [incomeText.backView addSubview:testLabel];
    [testLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lineView.mas_top).offset(-10);
        make.right.mas_offset(-15);
        make.height.mas_offset(15);
        make.left.mas_offset(15);
    }];
    
    UILabel *promptLabel = [[UILabel alloc]init];
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.textColor = [UIColor colorWithHexString:@"7e879d"];
    promptLabel.text = @"已为您复制到剪切板";
    promptLabel.font = [UIFont systemFontOfSize:13];
    [incomeText.backView addSubview:promptLabel];
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(15);
        make.right.mas_offset(-15);
        make.height.mas_offset(15);
        make.left.mas_offset(15);
    }];
    
    [UIView animateWithDuration:0.2 animations:^{
        incomeText.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        incomeText.backView.hidden = NO;
    }];
}

-(void)backButtonAction{
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.backView.hidden = YES;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

@end
