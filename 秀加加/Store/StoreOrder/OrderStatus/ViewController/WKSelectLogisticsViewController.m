//
//  WKSelectLogisticsViewController.m
//  秀加加
//
//  Created by lin on 2016/9/27.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKSelectLogisticsViewController.h"
#import "WKSelectLogisticsTableView.h"

@interface WKSelectLogisticsViewController ()

@property (strong, nonatomic) WKSelectLogisticsTableView * tableView;

@property (strong, nonatomic) NSMutableArray *dataArr;

@property (nonatomic, strong) NSMutableArray *arr;

@end

@implementation WKSelectLogisticsViewController

-(WKSelectLogisticsTableView *)tableView{
    if (!_tableView) {
        _tableView = [[WKSelectLogisticsTableView alloc]initWithFrame:CGRectMake(0, WKScreenH*0.5, WKScreenW, WKScreenH*0.5)andDataArr:self.array Block:^(NSString *backName,NSInteger type) {
            if (backName.length>0) {
                self.block(backName,@(type).stringValue);
                [self maskButtonClick:nil];
            }
        }];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createMainUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)createMainUI
{
    UIButton *maskButton = [[UIButton alloc]init];
    maskButton.backgroundColor = [UIColor grayColor];
    maskButton.alpha = 0.8;
    [maskButton addTarget:self action:@selector(maskButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:maskButton];
    [maskButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.view);
    }];
    [self.view addSubview:self.tableView];
}


-(void)maskButtonClick:(UIButton *)button{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
