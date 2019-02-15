//
//  WKBankTableView.m
//  wdbo
//
//  Created by Chang_Mac on 16/6/27.
//  Copyright © 2016年 Walkingtec. All rights reserved.
//

#import "WKSelectLogisticsTableView.h"
#import "WKSelectLogisticsTableViewCell.h"

@interface WKSelectLogisticsTableView ()
/**
 *  array
 */
@property (strong, nonatomic) NSMutableArray * array;
/**
 *  stirng
 */
@property (strong, nonatomic) __block NSString * string;

/**
 *  data
 */
@property (strong, nonatomic) NSArray * dataArr;

@end
@implementation WKSelectLogisticsTableView

-(instancetype)initWithFrame:(CGRect)frame andDataArr:(NSArray *)titleArr Block:(bankBlock)block
{
    if (self = [super initWithFrame:frame]) {
        self.block = block;
        self.dataArr = titleArr;
        self.array = [NSMutableArray new];
        self.tableView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.tableView.bounces = NO;
        self.tableView.showsVerticalScrollIndicator = NO;
    }
    return self;
}
#pragma mark tableView Dategate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WeakSelf(WKSelectLogisticsTableView);
    WKSelectLogisticsTableViewCell *cell = [[WKSelectLogisticsTableViewCell alloc]initWithNumber:indexPath.row and:^(NSString *backName,NSInteger index) {
        weakSelf.block(backName,0);
        self.string = backName;
            }];
    cell.label.text = self.dataArr[indexPath.row];
    [self.array addObject:cell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

@end
