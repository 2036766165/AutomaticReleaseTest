//
//  WKSwitchNotifyViewController.m
//  秀加加
//
//  Created by sks on 2016/11/30.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKSwitchNotifyViewController.h"
#import "WKSwitchTableView.h"

@interface WKSwitchNotifyViewController ()

@property (nonatomic,strong) WKSwitchTableView *switchTableView;

@end

@implementation WKSwitchNotifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"开播通知";
    
    WKSwitchTableView *tabelView = [[WKSwitchTableView alloc] initWithFrame:CGRectMake(0, 64, WKScreenW, WKScreenH-64)];
    [self.view addSubview:tabelView];
    
    self.switchTableView = tabelView;
    self.view.backgroundColor = [UIColor whiteColor];

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
