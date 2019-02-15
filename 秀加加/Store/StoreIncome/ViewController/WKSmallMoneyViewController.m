//
//  WKSmallMoneyViewController.m
//  wdbo
//
//  Created by lin on 16/6/25.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import "WKSmallMoneyViewController.h"
#import "WKWithDrawApplyForViewController.h"
#import "WKStoreIncomeViewController.h"
#import "WKIncomeMoneyView.h"
@interface WKSmallMoneyViewController ()

@property (nonatomic,strong) UIView *navView;

@property (nonatomic,strong) UITextField *moneyField;

@property (nonatomic,strong) UITextField *nameTF;

@property (strong, nonatomic) UITextField * IDCard;

@property (strong, nonatomic) WKIncomeMoneyView *incomeMoney;

@end

@implementation WKSmallMoneyViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"提现";
    self.incomeMoney = [[WKIncomeMoneyView alloc]initWithFrame:CGRectMake(0, 0, WKScreenW, WKScreenH) andMaxMoney:self.maxMoney];
    WeakSelf(WKSmallMoneyViewController);
    self.incomeMoney.block = ^(NSString * money){
        [weakSelf loadingWithdrawData:money];
    };
    [self.view addSubview:self.incomeMoney];
    [self reloadPromptMessage];
}

-(void)reloadPromptMessage{
    [WKHttpRequest uploadPrompt:HttpRequestMethodGet url:promptMessage param:nil success:^(WKBaseResponse *response) {
        if (response.Data) {
            [self.incomeMoney refreshPromptMessage:response.Data];
        }
    } failure:^(WKBaseResponse *response) {
        
    }];
}

-(void)loadingWithdrawData:(NSString *)money{
    NSString *urlStr = [NSString configUrl:WKUserWithdraw With:@[@"Money"] values:@[money]];
    [WKHttpRequest userWithdraw:HttpRequestMethodPost url:urlStr param:nil success:^(WKBaseResponse *response) {
        WKWithDrawApplyForViewController  *WithDrawApplyForVC = [[WKWithDrawApplyForViewController alloc] init];
        WithDrawApplyForVC.moneyStr = money;
        [self.navigationController pushViewController:WithDrawApplyForVC animated:YES];
    } failure:^(WKBaseResponse *response) {
        if (response.ResultCode != 0) {
            [WKPromptView showPromptView:response.ResultMessage];
        }
    }];
    
}

-(void)withdrawEvent:(UIButton *)sender
{
//    [self relodData];
}
- (BOOL)isPureNumandCharacters:(NSString *)string
{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(string.length > 0)
    {
        return NO;
    }
    return YES;
}
- (BOOL)validateNumber:(NSString *) textString
{
    NSString* number=@"^[0-9]+([.]{0,1}[0-9]+){0,1}$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return [numberPre evaluateWithObject:textString];
}
@end
