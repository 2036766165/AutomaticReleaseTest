//
//  WKRedPacketViewController.m
//  秀加加
//
//  Created by Chang_Mac on 17/3/14.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import "WKRedPacketViewController.h"
#import "WKRedPacketView.h"
#import "WKStoreRechargeViewController.h"
#import "WKSelectIndexView.h"
#import "WKAllWebViewController.h"
@interface WKRedPacketViewController ()

@property (strong, nonatomic) WKRedPacketView *redPacketView;

@end

@implementation WKRedPacketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createMainView];
    [self reloadConfig];
}

-(void)createMainView{
    WKRedPacketView *view = [[WKRedPacketView alloc]initWithFrame:CGRectMake(0, 0, WKScreenW, WKScreenH-64)];
    self.redPacketView = view;
    [self.view addSubview:view];
    WeakSelf(WKRedPacketViewController);
    view.callBack = ^(callBackType type,NSDictionary *data){
        switch (type) {
            case rechargeType:{
                WKStoreRechargeViewController *rechargeVC = [[WKStoreRechargeViewController alloc]init];
                [rechargeVC.navigationController setModalPresentationStyle:UIModalPresentationCurrentContext];
                [self.navigationController pushViewController:rechargeVC animated:YES];
            }
                break;
            case sendRedPacketType:{
                [weakSelf launchRedPacketWith:data];
            }
                break;
        }
    };
    
}

-(void)reloadConfig{
    NSString *urlStr = [NSString configUrl:WKGetRedBagConfig With:@[@"LiveMemberNo"] values:@[self.memberNo]];
    [WKHttpRequest RedBagConfig:HttpRequestMethodGet url:urlStr param:nil success:^(WKBaseResponse *response) {
        self.redPacketView.maxAmount = response.Data[@"MaxAmount"];
        self.redPacketView.userCount = [response.Data[@"OnlineCount"] integerValue];
        self.redPacketView.content = response.Data[@"RedBagDesc"];
        self.redPacketView.memberName = self.memberName;
        [self.redPacketView createControlWithType:self.type];
    } failure:^(WKBaseResponse *response) {
        
    }];
}


-(void)launchRedPacketWith:(NSDictionary *)dic{
    if (self.type == 1) {//个人红包
        NSDictionary *param = @{@"ToBPOID":self.receiveBPOID?self.receiveBPOID:@"",@"BagAmount":dic[@"BagAmount"],@"LiveMemberNo":self.memberNo,@"BagMessage":dic[@"BagMessage"]};
        
        [WKHttpRequest LaunchOnceRedPacket:HttpRequestMethodPost url:WKOnceRedPacket param:param success:^(WKBaseResponse *response) {
            NSLog(@"个人红包发送成功");
            if ([response.Data integerValue] == 2) {
                [WKSelectIndexView showWithText:@"余额不足" btnTitles:@[@"取消",@"去充值"] SelectIndex:^(NSInteger index) {
                    if (index == 1) {
                        WKStoreRechargeViewController *rechargeVC = [[WKStoreRechargeViewController alloc]init];
                        [rechargeVC.navigationController setModalPresentationStyle:UIModalPresentationCurrentContext];
                        [self.navigationController pushViewController:rechargeVC animated:YES];
                    }
                }];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(WKBaseResponse *response) {
            [WKPromptView showPromptView:response.ResultMessage];
        }];
    }else{//群红包
        NSMutableDictionary *mutableDic = dic.mutableCopy;
        [mutableDic setObject:self.memberNo forKey:@"LiveMemberNo"];
        [WKHttpRequest LaunchFlockRedPacket:HttpRequestMethodPost url:WKFlockRedPacket param:mutableDic success:^(WKBaseResponse *response) {
            NSLog(@"群红包发送成功");
            if ([response.Data integerValue] == 2) {
                [WKSelectIndexView showWithText:@"余额不足" btnTitles:@[@"取消",@"去充值"] SelectIndex:^(NSInteger index) {
                    if (index == 1) {
                        WKStoreRechargeViewController *rechargeVC = [[WKStoreRechargeViewController alloc]init];
                        [rechargeVC.navigationController setModalPresentationStyle:UIModalPresentationCurrentContext];
                        [self.navigationController pushViewController:rechargeVC animated:YES];
                    }
                }];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(WKBaseResponse *response) {
            [WKPromptView showPromptView:response.ResultMessage];
        }];
    }
}

- (void)reloadBalance{
    [WKHttpRequest getAuthCode:HttpRequestMethodGet url:WKStoreIncome param:nil success:^(WKBaseResponse *response) {
        [self.redPacketView setUserBalance:response.Data[@"MoneyCanTake"]];
    } failure:^(WKBaseResponse *response) {
        
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setVCStyle];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self reloadBalance];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSMutableDictionary *att = [NSMutableDictionary dictionary];
    att[NSFontAttributeName] = [UIFont systemFontOfSize:18];
    att[NSForegroundColorAttributeName] = [UIColor colorWithHex:0x9CA3B3];
    [self.navigationController.navigationBar setTitleTextAttributes:att];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithHex:0x9CA3B3]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@""] forBarMetrics:(UIBarMetricsDefault)];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.navigationController.view.backgroundColor = [UIColor colorWithHexString:@"#ff6250"];
}
-(void)setVCStyle{
    UIBarButtonItem *backButton = [UIBarButtonItem itemWithImageName:@"baijiantou" highImageName:@"" target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backButton;
    self.title = self.type == 1?@"个人红包":@"发红包";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHexString:@"#ff6250"]] forBarMetrics:(UIBarMetricsDefault)];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"help_white"] selImage:nil target:self action:@selector(help)];
    [self.navigationController setDefinesPresentationContext:YES];
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)help{
    WKAllWebViewController *webView = [[WKAllWebViewController alloc]init];
    webView.urlString = @"http://www.silentwind.com.cn/HelpCenter/redpackagehelp.html";
    webView.titles = @"红包帮助";
    [self.navigationController pushViewController:webView animated:YES];
}
@end





