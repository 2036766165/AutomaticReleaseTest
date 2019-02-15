//
//  WKSwitchTableView.m
//  秀加加
//
//  Created by sks on 2016/11/30.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKSwitchTableView.h"
#import "WKSwitchTableViewCell.h"
#import "WKShowRemindModel.h"

@interface WKSwitchTableView () <WKSwitchDelegate>

@end
@implementation WKSwitchTableView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame])
    {
        self.isOpenHeaderRefresh = YES;
        self.isOpenFooterRefresh = YES;
        self.tableView.showsVerticalScrollIndicator = NO;
//        [self.tableView initWithFrame:frame style:UITableViewStyleGrouped];
        
        UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WKScreenW, 90)];
        tableHeaderView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.tableView.frame = CGRectMake(0, 90, WKScreenW, WKScreenH - 90-64);

        UIView *contentView = [UIView new];
        contentView.backgroundColor = [UIColor whiteColor];
        [tableHeaderView addSubview:contentView];
        [self addSubview:tableHeaderView];
        
        UILabel *nameLab = [UILabel new];
        nameLab.text = @"开播提醒";
        nameLab.textAlignment = NSTextAlignmentLeft;
        nameLab.font = [UIFont systemFontOfSize:16.0f];
        nameLab.textColor = [UIColor darkGrayColor];
        [contentView addSubview:nameLab];
        
        UILabel *infoLab = [UILabel new];
        infoLab.text = @"关闭某个人的消息提醒,不再收到TA的开播提醒!";
        infoLab.textAlignment = NSTextAlignmentLeft;
        infoLab.font = [UIFont systemFontOfSize:14.0f];
        infoLab.textColor = [UIColor lightGrayColor];
        [contentView addSubview:infoLab];
        
        UIButton *switchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [switchBtn setImage:[UIImage imageNamed:@"开播通知按钮_normal"] forState:UIControlStateNormal];
        [switchBtn setImage:[UIImage imageNamed:@"开播通知按钮"] forState:UIControlStateSelected];
        [switchBtn addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventTouchUpInside];
        switchBtn.tag = 100;
        [contentView addSubview:switchBtn];
        
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_offset(CGSizeMake(WKScreenW, 65));
            make.top.mas_offset(15);
            make.left.mas_offset(0);
        }];
        
        [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(contentView.mas_left).offset(10);
            make.top.mas_equalTo(contentView.mas_top).offset(10);
            make.size.mas_offset(CGSizeMake(180, 30));
        }];
        
        [infoLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(contentView.mas_left).offset(10);
            make.bottom.mas_equalTo(contentView.mas_bottom).offset(-5);
            make.size.mas_offset(CGSizeMake(300, 15));
        }];
        
        [switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_offset(CGSizeMake(30 * 113/70, 30));
            make.centerY.mas_equalTo(contentView);
            make.right.mas_equalTo(contentView.mas_right).offset(-10);
        }];
        
        [self getRemindStatus];
    }
    return self;
}

- (void)getRemindStatus{
    [WKHttpRequest getAuthCode:HttpRequestMethodGet url:WKGetMemberMessageCount param:nil success:^(WKBaseResponse *response) {
        NSLog(@"response data : %@",response.Data);
        NSNumber *liveStatus = response.Data[@"LiveNotificationStatus"];
        UIButton *btn = [self viewWithTag:100];
        
        btn.selected = liveStatus.boolValue;
        
        [self setTableStateWithState:liveStatus];
        
//        if (liveStatus.boolValue) {
//            
//            self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//                self.pageNO = 1;
//                [self getAttentionList];
//            }];
//            
//            self.tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
//                self.pageNO += 1;
//                [self getAttentionList];
//            }];
//            [self getAttentionList];
//
////            [self.tableView.mj_header beginRefreshing];
//            
//        }else{
//            self.tableView.mj_header = nil;
//            self.tableView.mj_footer = nil;
//        }
        
    } failure:^(WKBaseResponse *response) {
        
    }];
}

// 获取关注列表
- (void)getAttentionList{
    
    NSString *url = [NSString configUrl:WKAttentionList With:@[@"PageSize",@"PageIndex"] values:@[@"10",@(self.pageNO)]];
    
    [WKHttpRequest getGoodsList:HttpRequestMethodGet url:url model:NSStringFromClass([WKShowRemindModel class]) param:nil success:^(WKBaseResponse *response) {
        
        WKShowRemindModel *singlePageMd = response.Data;
        if (singlePageMd.InnerList.count >0) {
            [self reloadDataWithArray:singlePageMd.InnerList];
        }else{
            [self setRemindreImageName:@"guanzhudefault" text:@"您还没有关注的主播" offsetY:-80 completion:^{
                
            }];
        }
    } failure:^(WKBaseResponse *response) {
        
    }];
}

// 总通知开关
- (void)setFocusStatus:(NSNumber *)status{
    
    NSString *url = [NSString configUrl:WKSetFocusStatus With:@[@"IsOpen"] values:@[status]];
    
    [WKHttpRequest getAuthCode:HttpRequestMethodPost url:url param:nil success:^(WKBaseResponse *response) {
        
        [self setTableStateWithState:status];
        
    } failure:^(WKBaseResponse *response) {
        
    }];
}

- (void)setTableStateWithState:(NSNumber *)status{
    
    if (status.integerValue == 1) {
        
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self.pageNO = 1;
            [self getAttentionList];
        }];
        
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            self.pageNO += 1;
            [self getAttentionList];
        }];
        
        [self getAttentionList];
    }else{
        
        [self.dataArray removeAllObjects];
        [self.tableView reloadData];
        
        self.tableView.mj_header = nil;
        self.tableView.mj_footer = nil;
    }
}
// 个人通知开关
- (void)setFocusStatus:(NSNumber *)status bopid:(NSString *)bpoid{
    
    NSString *url = [NSString configUrl:WKSingleFocus With:@[@"IsAccept",@"BPOID"] values:@[status,bpoid]];
    
    [WKHttpRequest getAuthCode:HttpRequestMethodPost url:url param:nil success:^(WKBaseResponse *response) {
        for (WKShowItemModel *item in self.dataArray) {
            if ([item.BPOID isEqualToString:bpoid]) {
                NSInteger index = [self.dataArray indexOfObject:item];
                item.IsAccept = status;
                
                WKSwitchTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
                [cell setItem:item];
            }
        }
        
    } failure:^(WKBaseResponse *response) {
        
    }];
}

// 是否开启播放通知
- (void)switchClick:(UIButton *)btn{
    self.pageNO = 1;
    btn.selected = !btn.selected;
    [self setFocusStatus:@(btn.selected)];
}

// 单个是否开启通知
- (void)switchDelegateWithItem:(WKShowItemModel *)item{
    [self setFocusStatus:item.IsAccept bopid:item.BPOID];
}

#pragma mark - UITableView delegate/DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"cell";
    WKSwitchTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
    {
        cell = [[WKSwitchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setItem:self.dataArray[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

@end
