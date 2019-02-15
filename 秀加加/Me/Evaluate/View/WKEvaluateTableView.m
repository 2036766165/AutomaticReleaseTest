//
//  WKEvaluateTableView.m
//  秀加加
//
//  Created by lin on 16/9/7.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKEvaluateTableView.h"
#import "WKEvaluateTableViewCell.h"
#import "UIImage+Gif.h"
@implementation WKEvaluateTableView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame])
    {
        self.isOpenHeaderRefresh = YES;
        self.isOpenFooterRefresh = YES;
        self.tableView.showsVerticalScrollIndicator = NO;
        [self.tableView initWithFrame:frame style:UITableViewStyleGrouped];
    }
    return self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"cell";
    WKEvaluateTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
    {
        cell = [[WKEvaluateTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.model = self.dataArray[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    WKEvaluateTableModel *model = self.dataArray[section];
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WKScreenW, 45)];
    headView.backgroundColor = [UIColor colorWithHex:0xF2F6FF];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, WKScreenW, 40)];
    titleView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *headIM = [[UIImageView alloc]init];
    headIM.layer.cornerRadius = 15;
    headIM.layer.masksToBounds = YES;
    [headIM sd_setImageWithURL:[NSURL URLWithString:model.ShopOwnerPicUrl]placeholderImage:[UIImage circleImageWithName:@"default_03" borderWidth:0.25 borderColor:[UIColor colorWithHexString:@"ff6600"]]];
    [titleView addSubview:headIM];
    [headIM mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(15);
        make.centerY.mas_offset(0);
        make.size.sizeOffset(CGSizeMake(30, 30));
    }];
    
    UILabel *ownerLabel = [[UILabel alloc]init];
    ownerLabel.text = model.ShopOwnerName;
    ownerLabel.font = [UIFont systemFontOfSize:14];
    ownerLabel.textColor = [UIColor colorWithHexString:@"7e879d"];
    [titleView addSubview:ownerLabel];
    [ownerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headIM.mas_right).offset(10);
        make.centerY.mas_offset(0);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_offset(15);
    }];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"yuyin" ofType:@"gif"];
    UIImage *image = [UIImage animatedImageWithAnimatedGIFURL:[NSURL fileURLWithPath:path]];
    UIImageView *liveStatus = [[UIImageView alloc]initWithImage:image];
    
    if (model.IsShow.integerValue == 1) {
        liveStatus.hidden = NO;
    }else{
        liveStatus.hidden = YES;
    }
    [titleView addSubview:liveStatus];
    [liveStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ownerLabel.mas_right).offset(10);
        make.bottom.equalTo(ownerLabel.mas_bottom).offset(-1);
        make.width.mas_offset(12);
        make.height.mas_offset(10);
    }];
    
    [headView addSubview:titleView];
    
    return headView;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WKScreenW, 50)];
    footView.backgroundColor = [UIColor whiteColor];
    
    UIButton *rightBtn = [[UIButton alloc] init];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn setTitle:@"评价晒单" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor colorWithHex:0xFC944E] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightEvent:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.layer.masksToBounds = YES;
    rightBtn.layer.cornerRadius = 8.0;
    rightBtn.layer.borderColor = [[UIColor colorWithHex:0xFC944E] CGColor];
    rightBtn.layer.borderWidth = 1.0;
    rightBtn.tag = section;
    [footView addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(footView.mas_right).offset(-10);
        make.top.equalTo(footView).offset((50-40)/2);
        make.size.mas_equalTo(CGSizeMake(80, 40));
    }];
    return footView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50;
}

-(void)rightEvent:(UIButton *)sender
{
    if(_clickEvaluateCall)
    {
        _clickEvaluateCall(self.dataArray[sender.tag]);
    }
}

-(void)headerRequestWithData{
    if (self.requestBlock) {
        self.requestBlock();
    }
}
-(void)footerRequestWithData{
    if (self.requestBlock) {
        self.requestBlock();
    }
}
@end
