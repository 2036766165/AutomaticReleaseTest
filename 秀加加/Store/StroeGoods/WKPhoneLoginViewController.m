//
//  WKPhoneLoginViewController.m
//  秀加加
//
//  Created by sks on 2016/9/8.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKPhoneLoginViewController.h"
#import "WKPhoneLoginView.h"

@interface WKPhoneLoginViewController ()

@end

@implementation WKPhoneLoginViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    IQKeyboardManager *kbMg = [IQKeyboardManager sharedManager];
    kbMg.enableAutoToolbar = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WKPhoneLoginView *phoneLoginView = [[WKPhoneLoginView alloc] init];
    phoneLoginView.frame = self.view.bounds;
    phoneLoginView.obserview = self;
    [self.view addSubview:phoneLoginView];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
