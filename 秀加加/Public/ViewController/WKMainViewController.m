//
//  WKMainViewController.m
//  秀加加
//
//  Created by lin on 16/8/29.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKMainViewController.h"
#import "UIView+XJExtension.h"
#import "WKLiveViewController.h"
#import "WKHomeViewController.h"
#import "WKNavigationController.h"
#import "UIImage+Image.h"
#import "WKMessageViewController.h"
#import "WKStoreViewController.h"
#import "WKHomeGoodsBaseViewController.h"
#import "WKHomePlayViewController.h"
#import "WKLiveTitleViewController.h"
#import "WKPersonalCenterViewController.h"
//#import "WKLiveViewController.h"
#import "WKLiveAgreeMent.h"
#import "NSObject+XWAdd.h"

@interface WKMainViewController ()<UITabBarControllerDelegate>

@end

@implementation WKMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTabBarBackgroundImage];
    [self setupAllViewController];
    [self setupAllTabBarButton];
    [self addLiveButton];
    [self addRedDot];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)setupTabBarBackgroundImage {
//    self.tabBar.backgroundColor = [UIColor colorWithHex:0xF7F9FF];
    self.tabBar.layer.shadowColor = [UIColor orangeColor].CGColor;
    self.tabBar.layer.shadowOffset = CGSizeMake(0, -1);
    self.tabBar.layer.shadowOpacity = 0.1;
    self.tabBar.layer.shadowRadius = 2;
    UIImageView *backIM = [[UIImageView alloc]initWithFrame:CGRectMake(0, -21, WKScreenW, 70)];
    backIM.image = [UIImage imageNamed:@"shouye_03"];
    [self.tabBar addSubview:backIM];
}

//自定义TabBar高度
- (void)viewWillLayoutSubviews {
    
    CGRect tabFrame = self.tabBar.frame;
    tabFrame.size.height = 49;
    tabFrame.origin.y = self.view.frame.size.height - 49;
    self.tabBar.frame = tabFrame;
}

- (void)setupAllViewController {
    
    NSArray *viewControllers = @[[WKHomePlayViewController class],[WKHomeGoodsBaseViewController class]];
    NSArray *titles = @[@"热门", @"热卖"];

    WKHomeViewController *pageController = [[WKHomeViewController alloc] initWithViewControllerClasses:viewControllers andTheirTitles:titles];
    pageController.menuHeight = 44;
    pageController.menuViewStyle = WMMenuViewStyleTriangle;
    pageController.preloadPolicy = WMPageControllerPreloadPolicyNever;
    pageController.cachePolicy = WMPageControllerCachePolicyLowMemory;
    pageController.titleSizeSelected = 18;
    pageController.titleSizeNormal = 18;
    pageController.itemMargin = 30;
    pageController.showOnNavigationBar = YES;
    pageController.menuBGColor = [UIColor clearColor];
    pageController.titleColorNormal = [UIColor colorWithHex:0xB1B6C3];
    pageController.titleColorSelected = [UIColor colorWithHex:0xFB7934];
    pageController.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
    WKNavigationController *homeNav = [[WKNavigationController alloc] initWithRootViewController:pageController];
//    [self addChildViewController:homeNav];

    WKLiveTitleViewController *pushFlowVC = [[WKLiveTitleViewController alloc] init];
    WKNavigationController *liveNav = [[WKNavigationController alloc] initWithRootViewController:pushFlowVC];
//    [self addChildViewController:liveNav];

//    WKStoreViewController *meVc = [[WKStoreViewController alloc] init];
//    WKNavigationController *meNav = [[WKNavigationController alloc] initWithRootViewController:meVc];
    WKPersonalCenterViewController *meVc = [[WKPersonalCenterViewController alloc] init];
    WKNavigationController *meNav = [[WKNavigationController alloc] initWithRootViewController:meVc];
    //    [self addChildViewController:meNav];
    
    self.viewControllers = @[homeNav,liveNav,meNav];
}

-(void)setupAllTabBarButton
{
    WKHomeViewController *homeVC = self.viewControllers[0];
    homeVC.tabBarItem.image = [UIImage imageNamed:@"shouye_10"];
    UIImage *homeimage = [UIImage imageNamed:@"shouye_12"];
    homeimage = [homeimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeVC.tabBarItem.selectedImage = homeimage;
    
    WKLiveTitleViewController *pushFlowVC = self.childViewControllers[1];
    pushFlowVC.tabBarItem.enabled = NO;
    
//    WKStoreViewController *meVC = self.viewControllers[2];
//    meVC.tabBarItem.image = [UIImage imageNamed:@"me_normal"];
//    UIImage *meimage = [UIImage imageNamed:@"me_select"];
//    meimage = [meimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    meVC.tabBarItem.selectedImage = meimage;

    WKPersonalCenterViewController *meVC = self.viewControllers[2];
    meVC.tabBarItem.image = [UIImage imageNamed:@"shouye_17"];
    UIImage *meimage = [UIImage imageNamed:@"shouye_15"];
    meimage = [meimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    meVC.tabBarItem.selectedImage = meimage;
    
    UIEdgeInsets insets = UIEdgeInsetsMake(6, 0, -6, 0);
    UIEdgeInsets liveInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    homeVC.tabBarItem.imageInsets = insets;
    pushFlowVC.tabBarItem.imageInsets = liveInsets;
    meVC.tabBarItem.imageInsets = insets;
    
    //隐藏阴影线
    [[UITabBar appearance] setShadowImage:[UIImage new]];
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc]init]];
}

- (void)addLiveButton {
    
    UIButton *liveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [liveBtn setImage:[UIImage imageNamed:@"shouye_07"] forState:UIControlStateNormal];
//    [liveBtn setImage:[UIImage imageNamed:@"live_select"] forState:UIControlStateHighlighted];
    [liveBtn sizeToFit];
    
    liveBtn.center = CGPointMake(self.tabBar.frame.size.width * 0.5, self.tabBar.frame.size.height * 0.5 - 12);
    [liveBtn addTarget:self action:@selector(clickliveBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBar addSubview:liveBtn];
}

-(void)addRedDot{
    UIView *redView = [[UIView alloc]initWithFrame:CGRectMake(WKScreenW*0.86, 15, 5, 5)];
    [redView layoutIfNeeded];
    redView.layer.cornerRadius = 2.5;
    redView.hidden = YES;
    redView.backgroundColor = [UIColor colorWithWholeRed:253 green:100 blue:30];
    [self.tabBar addSubview:redView];
    
    __block int sendCount = 0;
    __block int orderCount = 0;
    [self xw_addNotificationForName:@"SHOPREDDOT" block:^(NSNotification * _Nonnull notification) {
        if ([notification.userInfo[@"isHidden"] boolValue]) {//隐藏
            if ([notification.userInfo[@"type"] integerValue]==1) {// 订单
                [[NSUserDefaults standardUserDefaults]setObject:@true forKey:@"orderRedDot"];
                orderCount = 0;
            }else{//发货
                [[NSUserDefaults standardUserDefaults]setObject:@true forKey:@"sendGoodsRedDot"];
                sendCount = 0;
            }
        }else{//显示
            if ([notification.userInfo[@"type"] integerValue]==1) {//订单
                [[NSUserDefaults standardUserDefaults]setObject:@false forKey:@"orderRedDot"];
                orderCount = 1;
            }else{//发货
                [[NSUserDefaults standardUserDefaults]setObject:@false forKey:@"sendGoodsRedDot"];
                sendCount = 1;
            }
        }
        if (orderCount == 1 || sendCount == 1) {
            redView.hidden = NO;
        }else{
            redView.hidden = YES;
        }
        
    }];
}

//- (BOOL)shouldAutorotate{
//    return NO;
//}
//
//
//-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
//    return UIInterfaceOrientationMaskPortrait;
//}
//
////一开始的方向  很重要
//-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
//    return UIInterfaceOrientationPortrait;
//}

- (void)clickliveBtn {
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:EVER_IN]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:EVER_IN];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL firstLunch = [userDefaults boolForKey:@"firstLaunch"];
    
    if (!firstLunch) {
        WKLiveTitleViewController *show = [[WKLiveTitleViewController alloc] init];
        [self presentViewController:show animated:YES completion:NULL];
        
    }else{
        
        WKLiveAgreeMent *agree = [[WKLiveAgreeMent alloc] init];
        
        WKNavigationController *nav = [[WKNavigationController alloc] initWithRootViewController:agree];
        
        [self presentViewController:nav animated:YES completion:NULL];
    }
}

@end




