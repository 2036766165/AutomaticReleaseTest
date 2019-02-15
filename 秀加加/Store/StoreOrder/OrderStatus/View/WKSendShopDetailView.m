//
//  WKSendShopDetailView.m
//  wdbo
//
//  Created by lin on 16/6/24.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import "WKSendShopDetailView.h"
#import "WKSendShopDetailViewCell.h"

@interface WKSendShopDetailView()

@end

@implementation WKSendShopDetailView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame])
    {
        self.isOpenHeaderRefresh = NO;
        self.isOpenFooterRefresh = NO;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.tableHeaderView = [self headView];
    }
    return self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.model.InnerList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"cell";
    WKSendShopDetailViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
    {
        cell = [[WKSendShopDetailViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
//    InnerListModel *model = self.model.InnerList[indexPath.row];
    if (indexPath.row == 0 && indexPath.row != self.model.InnerList.count -1) {
        cell.date.textColor = [UIColor orangeColor];
        cell.view.backgroundColor = [UIColor orangeColor];
        cell.detail.textColor = [UIColor orangeColor];
        cell.view.image = [UIImage imageNamed:@"pro_selected"];
    }else{
        cell.date.textColor = [UIColor lightGrayColor];
        cell.detail.textColor = [UIColor colorWithHex:0x9e9e9e];
        cell.view.backgroundColor = [UIColor lightGrayColor];
        cell.view.image = [UIImage imageNamed:@""];
    }
    cell.model = self.model.InnerList[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InnerListModel *model = self.model.InnerList[indexPath.row];
    CGSize size = [model.context sizeOfStringWithFont:[UIFont systemFontOfSize:16] withMaxSize:CGSizeMake(WKScreenW-45, MAXFLOAT)];
    return 65+size.height;
}

-(UIView *)headView
{
    UIView *titleView = [[UIView alloc] init];
    titleView.frame = CGRectMake(0, 0, WKScreenW, 45);
    titleView.backgroundColor = [UIColor whiteColor];
    [self addSubview:titleView];
    
    UILabel *title = [[UILabel alloc] init];
    title.textColor = [UIColor colorWithHex:0x919191];
    title.text = @"物流跟踪";
    [titleView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleView).offset(15);
        make.top.equalTo(titleView).offset((45-20)/2);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    
    UIView *xianView = [[UIView alloc] init];
    xianView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    [titleView addSubview:xianView];
    [xianView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleView).offset(0);
        make.top.equalTo(titleView.mas_top).offset(45);
        make.size.mas_equalTo(CGSizeMake(WKScreenW, 1));
    }];
    return titleView;
}


#pragma mark -- refreshing
- (void)headerRequestWithData
{
    if (self.requestBlock) {
        self.requestBlock();
    }
}

- (void)footerRequestWithData
{
    if (self.requestBlock) {
        self.requestBlock();
    }
}


@end
