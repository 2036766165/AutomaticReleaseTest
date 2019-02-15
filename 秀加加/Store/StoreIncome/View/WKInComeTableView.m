//
//  WKInComeTableView.m
//  wdbo
//
//  Created by lin on 16/6/26.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import "WKInComeTableView.h"
#import "WKOrderNoticeTableViewCell.h"
#import "WKInComeDetailViewController.h"
#import "WKPaymentDetailsModel.h"

@interface WKInComeTableView()

@end

@implementation WKInComeTableView

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
    WKOrderNoticeTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
    {
        cell = [[WKOrderNoticeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.model1 = self.dataArray[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
