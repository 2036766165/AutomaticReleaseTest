//
//  WKMyIntegralViewController.m
//  秀加加
//
//  Created by lin on 16/8/30.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKMyIntegralViewController.h"
#import "WKMyIntegralTableView.h"
#import "WKMyIntegralModel.h"

@interface WKMyIntegralViewController()

@property (nonatomic,strong) WKMyIntegralTableView *myIntegralTableView;
@end

@implementation WKMyIntegralViewController


- (WKMyIntegralTableView *)myIntegralTableView
{
    if (!_myIntegralTableView) {
        _myIntegralTableView = [[WKMyIntegralTableView alloc] initWithFrame:CGRectMake(0, 36, WKScreenW, WKScreenH-72)];
    }
    return _myIntegralTableView;
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.myIntegralTableView];
    
    [self initUi];
    
    [self event];
    [self loadData];
}

-(void)initUi
{
    self.title = @"我的积分";
    self.myIntegralTableView.PersonModel = self.PersonModel;
}

-(void)event
{
    WeakSelf(WKMyIntegralViewController);
    self.myIntegralTableView.requestBlock = ^(){
        [weakSelf loadData];
    };
}

-(void)loadData
{
    NSDictionary *param = @{@"PageIndex":@(self.myIntegralTableView.pageNO),
                            @"PageSize":@(self.myIntegralTableView.pageSize)};

    [WKHttpRequest myIntegral:HttpRequestMethodPost url:WKMyIntegral model:NSStringFromClass([WKMyIntegralModel class]) param:param success:^(WKBaseResponse *response) {
        
        NSLog(@"----------%@",response.json);
        
        WKMyIntegralModel *model = response.Data;
        
        if(model.InnerList.count <= 0)//添加默认图片
        {
            [self.myIntegralTableView setRemindreImageName:@"jifen" text:@"暂无积分\n快去获得积分吧!" completion:^{
                
            }];
        }
        
        [self.myIntegralTableView reloadDataWithArray:model.InnerList];

    } failure:^(WKBaseResponse *response) {
//        [WKProgressHUD showText:response.ResultMessage];
        
        [self.myIntegralTableView setRemindreImageName:@"jifen" text:@"暂无积分\n快去获得积分吧!" completion:^{
            
            
        }];
    }];
}

@end
