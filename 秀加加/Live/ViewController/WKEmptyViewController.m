//
//  WKEmptyViewController.m
//  秀加加
//
//  Created by Chang_Mac on 16/12/20.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKEmptyViewController.h"
#import "WKStoreRechargeViewController.h"
@interface WKEmptyViewController ()

@end

@implementation WKEmptyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    dispatch_async(dispatch_get_main_queue(), ^{
        WKStoreRechargeViewController *rechargeVC = [[WKStoreRechargeViewController alloc]init];
        rechargeVC.block=^(){
            [self dismissViewControllerAnimated:NO completion:nil];
        };
        [self presentViewController:rechargeVC animated:YES completion:NULL];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)shouldAutorotate {
    return NO;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    //    if (_type == WKGoodsLayoutTypeHoriztal) {
    //        return UIInterfaceOrientationMaskLandscapeRight;
    //    }else{
    return UIInterfaceOrientationMaskPortrait;
    //    }
}

//一开始的方向  很重要
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    //    if (_type == WKGoodsLayoutTypeHoriztal) {
    //        return UIInterfaceOrientationLandscapeRight;
    //    }else{
    return UIInterfaceOrientationPortrait;
    //    }
}
@end
