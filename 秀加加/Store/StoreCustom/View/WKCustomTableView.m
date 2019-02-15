//
//  WKCustomTableView.m
//  秀加加
//
//  Created by Chang_Mac on 16/10/9.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKCustomTableView.h"
#import "WKCustomTableViewCell.h"

@implementation WKCustomTableView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame])
    {
        self.isOpenHeaderRefresh = YES;
        self.isOpenFooterRefresh = YES;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.backgroundColor = [UIColor colorWithHexString:@"f3f6ff"];
        self.tableView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    }
    return self;
}
#pragma mark tableView Dategate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WKCustomTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (!cell) {
        cell = [[WKCustomTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    }
    cell.model = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomInnerList *model = self.dataArray[indexPath.row];
    if (self.customTableBlock) {
        self.customTableBlock(model.MemberNo);
    }
}
-(void)footerRequestWithData{
    self.requestBlock();
}
-(void)headerRequestWithData{
    self.requestBlock();
}
@end
