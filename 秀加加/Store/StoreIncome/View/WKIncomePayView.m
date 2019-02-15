//
//  WKIncomePayView.m
//  秀加加
//
//  Created by Chang_Mac on 17/2/17.
//  Copyright © 2017年 walkingtec. All rights reserved.
//

#import "WKIncomePayView.h"
#import "WKIncomePayCell.h"
@implementation WKIncomePayView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame])
    {
        self.isOpenHeaderRefresh = YES;
        self.isOpenFooterRefresh = YES;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.frame = CGRectMake(0, 5, frame.size.width, frame.size.height);
        self.backgroundColor = [UIColor colorWithHexString:@"f3f6ff"];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"cell";
    WKIncomePayCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
    {
        cell = [[WKIncomePayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.model = self.dataArray[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell.model.AccountLogType.integerValue != 6) {
        cell.money.textColor = [UIColor orangeColor];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WKPaymentDetailsModel *model = self.dataArray [indexPath.section];
    if ([model.AccountLogType integerValue]== 2 || [model.AccountLogType integerValue]== 4) {
        if (self.block) {
            self.block(indexPath.section);
        }
    }
}

#pragma mark -- refreshing
- (void)headerRequestWithData
{
    if (self.refreshBlock) {
        self.refreshBlock(1);
    }
}

- (void)footerRequestWithData
{
    if (self.refreshBlock) {
        self.refreshBlock(2);
    }
}

@end
