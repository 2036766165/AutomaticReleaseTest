//
//  WKIncomeDetailsViewController.m
//  wdbo
//
//  Created by Chang_Mac on 16/6/27.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import "WKIncomeDetailsViewController.h"
#import "WKIncomeSmallTableViewCell.h"
#import "WKIncomeDetailsModel.h"
#import "WKIncomeDetailsView.h"
#import "WKAuctionDetailsModel.h"

@interface WKIncomeDetailsViewController ()

@property (strong, nonatomic) UITableView * tableView;

@property (strong, nonatomic) UILabel * label;

@property (strong, nonatomic) WKIncomeDetailsModel *model;

@property (strong, nonatomic) WKIncomeDetailsView * incomeDetails;

@end

@implementation WKIncomeDetailsViewController

-(WKIncomeDetailsView *)incomeDetails{
    if (!_incomeDetails) {
        _incomeDetails = [[WKIncomeDetailsView alloc]initWithFrame:CGRectMake(0, 0, WKScreenW, WKScreenH)];
        if (self.type.integerValue == 4) {
            _incomeDetails.type = 1; //提现类型
        }else if(self.type.integerValue == 2){
            _incomeDetails.type = 2; //拍卖类型
            _incomeDetails.createTime=self.createTime;
        }
    }
    return _incomeDetails;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收支明细";
    [self.view addSubview:self.incomeDetails];
    [self  sealView];
    
}


-(void)sealView{
    
    if (self.type.integerValue == 4) {
        [self LoadingIncomeDetailsData];
    }
    else{
        UIImage *image = [UIImage imageNamed:@"yinzhang"];
        self.auctionView = [[UIImageView alloc]initWithImage:image];
        [self.view addSubview:self.auctionView];
        [self.auctionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(CGPointMake(-20, -100));
            make.size.mas_equalTo(image.size);
        }];

        [self LoadingAuctionDetailsData];
    }
    
}
-(void)LoadingIncomeDetailsData{
    NSString *UrlStr = [NSString configUrl:WKWithdrawDetailsUrl With:@[@"WithdrawID"] values:@[self.orderID]];
    [WKHttpRequest incomeDetailsMessage:HttpRequestMethodGet url:UrlStr param:nil success:^(WKBaseResponse *response) {
        WKIncomeDetailsModel *model = [WKIncomeDetailsModel yy_modelWithDictionary:response.Data];
        self.incomeDetails.model = model;
        [self.incomeDetails reloadData];
    } failure:^(WKBaseResponse *response) {
        
    }];
}

-(void) LoadingAuctionDetailsData{
    NSString *UrlStr = [NSString configUrl:WKOrderDetail With:@[@"orderCode"] values:@[self.orderID]];
    [WKHttpRequest auctionDetailMessage:HttpRequestMethodGet url:UrlStr param:nil success:^(WKBaseResponse *response){
        WKAuctionDetailsModel *model = [WKAuctionDetailsModel yy_modelWithDictionary:response.Data];
        self.incomeDetails.auctionModel= model;
        NSLog(@"%@",self.createTime);
        if(self.incomeDetails.auctionModel.PayStatus.integerValue != 1){
            //保证金支付
            self.auctionView.image=[UIImage imageNamed:@"jieshu"];
        }
        [self.incomeDetails reloadData];
    } failure:^(WKBaseResponse *response){}];
}

@end
