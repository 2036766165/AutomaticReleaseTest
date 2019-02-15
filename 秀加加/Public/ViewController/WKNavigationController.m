//
//  WKNavigationController.m
//  wdbo
//
//  Created by sks on 16/6/15.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import "WKNavigationController.h"
#import "UIBarButtonItem+Extension.h"
#import "WKSearchViewController.h"
@interface WKNavigationController () <UIGestureRecognizerDelegate>

@end

@implementation WKNavigationController


//设置navigation背景
+ (void)initialize {
    
    if (self == [WKNavigationController class]) {
//        [self.navigationController.navigationBar setShadowImage:[UIImage alloc]];
//        UINavigationBar *bar = [UINavigationBar appearanceWhenContainedIn:self, nil];
//        [bar setBackgroundImage:[UIImage imageNamed:@""] forBarMetrics:UIBarMetricsDefault];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@""] forBarMetrics:(UIBarMetricsDefault)];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@""]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    id target = self.interactivePopGestureRecognizer.delegate;

//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
//
//    [self.view addGestureRecognizer:pan];
    
    self.interactivePopGestureRecognizer.enabled = NO;
    
//    pan.delegate = self;
    
//    [self.navigationController.navigationBar setShadowImage:[UIImage alloc]];
    // 设置文字
    NSMutableDictionary *att = [NSMutableDictionary dictionary];
    att[NSFontAttributeName] = [UIFont systemFontOfSize:18];
    att[NSForegroundColorAttributeName] = [UIColor colorWithHex:0x9CA3B3];
    [[UINavigationBar appearance] setTitleTextAttributes:att];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithHex:0x9CA3B3]];
}

//-(void)handleNavigationTransition:(UIPanGestureRecognizer *)gesture
//{
//
//}

#pragma mark ---- <UIGestureRecognizerDelegate>
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 判断下当前是不是在根控制器
    return self.childViewControllers.count > 1;
}

#pragma mark ---- <非根控制器隐藏底部tabbar>
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count > 0) {
        
        viewController.hidesBottomBarWhenPushed = YES;
//        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//        negativeSpacer.width = -5;
        
        //设置导航栏的按钮
        UIBarButtonItem *backButton = [UIBarButtonItem itemWithImageName:@"back" highImageName:@"back" target:self action:@selector(back)];
        viewController.navigationItem.leftBarButtonItem = backButton;
//        viewController.navigationItem.leftBarButtonItems = @[negativeSpacer, backButton];
    }
    [super pushViewController:viewController animated:animated];
}

- (void)back {
    [self popViewControllerAnimated:YES];
}


@end
