//
//  WKContributorViewController.m
//  秀加加
//  标题：贡献榜控制器
//  Created by sks on 2017/2/14.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import "WKContributorViewController.h"
#import "WKRankListModel.h"
#import "WKContributorTableViewCell.h"

@interface WKContributorViewController () <UITableViewDelegate,UITableViewDataSource>{
    UITableView *_tableView;
    NSMutableArray *_dataArr;
    NSString *_shopOwnerNo;
}

@end

@implementation WKContributorViewController

- (instancetype)initWithShopOwnerNo:(NSString *)shopOwnerNo{
    self = [super init];
    if (self) {
        _shopOwnerNo = shopOwnerNo;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"贡献榜";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(bbiBack)];

    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
//    [_tableView registerClass:[WKContributorTableViewCell class] forCellReuseIdentifier:NSStringFromClass([WKContributorTableViewCell class])];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(64, 0, 0, 0));
    }];
    [self loadDataList];
}

- (void)setupSelfInfo:(WKRankListModel *)info{
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor colorWithRed:0.99 green:0.40 blue:0.13 alpha:1.00];
    [self.view addSubview:backView];
    
    // 用户头像
    UIImageView *iconImageV = [[UIImageView alloc] initWithFrame:CGRectZero];
    [backView addSubview:iconImageV];
    iconImageV.layer.cornerRadius = 50/2.0f;
    iconImageV.clipsToBounds = YES;
    
    // 名字
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectZero];
    nameLab.textColor = [UIColor whiteColor];
    nameLab.textAlignment = NSTextAlignmentLeft;
    nameLab.font = [UIFont systemFontOfSize:14.0f];
    [backView addSubview:nameLab];
    
    // 消费
    UILabel *consumeLab = [[UILabel alloc] initWithFrame:CGRectZero];
    consumeLab.textColor = [UIColor whiteColor];
    consumeLab.textAlignment = NSTextAlignmentLeft;
    consumeLab.font = [UIFont systemFontOfSize:14.0f];
    [backView addSubview:consumeLab];
    
    // 排名
    UILabel *rankListLab = [[UILabel alloc] initWithFrame:CGRectZero];
    rankListLab.textColor = [UIColor whiteColor];
    rankListLab.textAlignment = NSTextAlignmentCenter;
    rankListLab.font = [UIFont systemFontOfSize:14.0f];
    [backView addSubview:rankListLab];
    
    if (info.Sort.integerValue == 0) {
        rankListLab.text = @"...";
    }else{
        rankListLab.text = [NSString stringWithFormat:@"NO.%@",info.Sort];
    }
    
    [iconImageV sd_setImageWithURL:[NSURL URLWithString:info.MemberPicUrl] placeholderImage:[UIImage imageNamed:@"default_02"]];
    nameLab.text = info.MemberName;
    consumeLab.text = [NSString stringWithFormat:@"消费总额￥%.2f",info.Amount.floatValue];
    
    [rankListLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(10);
        make.centerY.mas_offset(0);
        make.size.mas_offset(CGSizeMake(50, 30));
    }];
    
    [iconImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_offset(0);
        make.left.mas_equalTo(rankListLab.mas_right).offset(10);
        make.size.sizeOffset(CGSizeMake(50, 50));
    }];
    
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(iconImageV.mas_top).offset(5);
        make.left.mas_equalTo(iconImageV.mas_right).offset(30);
        make.size.mas_equalTo(CGSizeMake(WKScreenW * 0.5, 15));
    }];
    
    [consumeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(iconImageV.mas_bottom).offset(-5);
        make.left.mas_equalTo(iconImageV.mas_right).offset(30);
        make.size.mas_offset(CGSizeMake(WKScreenH * 0.5, 15));
    }];
    
    [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(64, 0, 60, 0));
    }];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.mas_offset(0);
        make.height.mas_offset(60);
    }];
}

- (void)loadDataList{
    
    NSString *url = [NSString configUrl:WKRankList With:@[@"shopOwnerNo"] values:@[_shopOwnerNo]];
    
    [WKHttpRequest auctionGoods:HttpRequestMethodPost url:url param:nil model:NSStringFromClass([WKRankListModel class]) success:^(WKBaseResponse *response) {

        _dataArr = [NSArray yy_modelArrayWithClass:[WKRankListModel class] json:response.json[@"Data"][@"InnerList"]].mutableCopy;
        WKRankListModel *model;
        if (_dataArr.count==1) {
            model = _dataArr[0];
        }
        
        if (_dataArr.count == 0 || (_dataArr.count == 1 && model.IsSelf)) {
            _tableView.loading = YES;
            _tableView.dataVerticalOffset = -50;
            _tableView.buttonText = @"";
            _tableView.descriptionText = @"暂无榜单";
            _tableView.buttonNormalColor = [UIColor colorWithHexString:@"7e879d"];
            _tableView.loadedImageName = @"paihangbangzanwu";
            _tableView.loading = NO;
        }
        for (int i=0; i<_dataArr.count; i++) {
            WKRankListModel *item = _dataArr[i];
            if (item.IsSelf) {
                [self setupSelfInfo:item];
                [_dataArr removeObjectAtIndex:i];
                break;
            }
        }
        
        [_tableView reloadData];
        
    } failure:^(WKBaseResponse *response) {
        
    }];
}

- (void)bbiBack{
//    [self dismissViewControllerAnimated:YES completion:NULL];
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 140;
    }else if (indexPath.row == 1 || indexPath.row == 2){
        return 100;
    }else
        return 75;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *identifier = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row];
    WKContributorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[WKContributorTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setRanklist:_dataArr[indexPath.row]];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
