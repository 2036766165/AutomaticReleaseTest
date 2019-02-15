//
//  WKInComeDetailViewController.m
//  wdbo
//
//  Created by lin on 16/6/26.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import "WKInComeDetailViewController.h"
#import "WKPagesView.h"
#import "WKAllMoneyDetailViewController.h"
#import "WKDaShangViewController.h"
#import "WKOrderIncomeViewController.h"
#import "WKTiXianViewController.h"
#import "WKAuctionViewController.h"

@interface WKInComeDetailViewController()

@property (nonatomic,strong) UIView *navView;

@end

@implementation WKInComeDetailViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self initUi];
}

-(void)initUi
{
    self.view.backgroundColor = [UIColor colorWithHexString:@"f3f6ff"];
    self.title = @"收支明细";
//    [WKAllMoneyDetailViewController alloc]init],
    
    
    NSMutableArray *viewControllsers = @[[[WKDaShangViewController alloc] init],
                                  [[WKOrderIncomeViewController alloc] init],[[WKAuctionViewController alloc] init],
                                  [[WKTiXianViewController alloc] init]].mutableCopy;
    NSMutableArray *titleArr = @[@"支付",@"收入",@"充值",@"提现"].mutableCopy;
    NSMutableArray *imageArr = @[@"Personal_pay",@"Personal_gain",@"Personal_chongzhi-1",@"Personal_tixian"].mutableCopy;
    NSMutableArray *seleImageArr = @[@"Personal_pay_select",@"Personal_gain_select",@"Personal_chongzhi_select",@"Personal_tixian_select"].mutableCopy;
    if (User.isReviewID) {//上线判断
        [viewControllsers removeLastObject];
        [titleArr removeLastObject];
        [imageArr removeLastObject];
        [seleImageArr removeLastObject];
    }
    
    WKPagesView *pageView = [[WKPagesView alloc] initWithFrame:CGRectZero toolBarType:WKPageTypeOrder BtnTitles:titleArr images: imageArr selectedImages:seleImageArr viewController:viewControllsers];
    [self.view addSubview:pageView];
    
    [pageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(70);
        make.bottom.mas_equalTo(self.view).offset(0);
        make.left.mas_offset(0);
        make.right.mas_offset(0);
    }];

}

-(void)backEvent
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)back:(UITapGestureRecognizer *)gesture
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
