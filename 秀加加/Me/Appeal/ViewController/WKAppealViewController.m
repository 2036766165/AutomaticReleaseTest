//
//  WKAppealViewController.m
//  秀加加
//
//  Created by lin on 16/8/30.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKAppealViewController.h"
#import "UITextView+Placeholder.h"

@interface WKAppealViewController ()

@end

@implementation WKAppealViewController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    self.title = @"处罚申诉";
    
    self.view.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.00];
    
    UILabel *lab = [UILabel new];
    
    lab.textAlignment = NSTextAlignmentLeft;
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:@"请填写申诉理由"];
    [attri addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x626262]} range:NSMakeRange(0, attri.length)];
    lab.attributedText = attri;
    lab.font = [UIFont systemFontOfSize:16.0f];
    [self.view addSubview:lab];
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_offset(10);
        make.topMargin.mas_offset(64 + 20);
        make.size.mas_offset(CGSizeMake(200, 35));
    }];
    
    UITextView *textView = [UITextView new];
    textView.tag = 1001;
    textView.font = [UIFont systemFontOfSize:14.0f];
    textView.placeholder = @"请填写申诉说明";
    [self.view addSubview:textView];
    
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lab.mas_bottom).offset(10);
        make.left.mas_offset(0);
        make.width.mas_offset(WKScreenW);
        make.height.mas_offset(220 * WKScaleH);
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.layer.cornerRadius = 5.0f;
    [btn setTitle:@"发起申诉" forState:UIControlStateNormal];
    btn.backgroundColor = MAIN_COLOR;
    
    btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(textView.mas_bottom).offset(10);
        make.left.mas_offset(10);
        make.right.mas_offset(-10);
        make.height.mas_offset(40);
    }];
}

- (void)btnClick:(UIButton *)btn{
    [self.view endEditing:YES];
    
    UITextView *textView = [self.view viewWithTag:1001];
    
    if (textView.text.length == 0) {
        [WKPromptView showPromptView:@"请填写申诉内容！"];
        return;
    }
    
    NSString *url = [NSString configUrl:WKCommonPunish With:@[@"content"] values:@[textView.text]];
    
    [WKHttpRequest punishWith:HttpRequestMethodPost url:url param:@{} success:^(WKBaseResponse *response) {
        [WKPromptView showPromptView:@"申诉提交成功！"];
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(WKBaseResponse *response) {}];
}
@end
