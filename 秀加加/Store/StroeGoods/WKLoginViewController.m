//
//  WKLoginViewController.m
//  秀加加
//
//  Created by sks on 2016/9/8.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKLoginViewController.h"
#import "WKLoginView.h"

@interface WKLoginViewController ()

@end

@implementation WKLoginViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    IQKeyboardManager *kbMg = [IQKeyboardManager sharedManager];
    kbMg.enableAutoToolbar = YES;
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WKLoginView *loginView = [[WKLoginView alloc] init];
    loginView.frame = self.view.bounds;
    loginView.obserview = self;
    [self.view addSubview:loginView];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
