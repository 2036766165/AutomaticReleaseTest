//
//  WKAttentionTableView.m
//  秀加加
//
//  Created by lin on 16/9/6.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKAttentionTableView.h"

@implementation WKAttentionTableView

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
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return true;
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"取消关注"handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            if (self.selectClickType) {
                self.selectClickType(indexPath.row,ClickFocusNot);
                [self.dataArray removeObjectAtIndex:indexPath.row];
                [self.tableView reloadData];
            }
        //在block中实现相对应的事件
    }];
    UITableViewRowAction *action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"私信"handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            if (self.selectClickType) {
                self.selectClickType(indexPath.row,ClickMessage);
            }
    }];
    action2.backgroundColor = [UIColor orangeColor];
//    注意：1、当rowActionWithStyle的值为UITableViewRowActionStyleDestructive时，系统默认背景色为红色；当值为UITableViewRowActionStyleNormal时，背景色默认为淡灰色，可通过UITableViewRowAction的对象的.backgroundColor设置；
//    2、当左滑按钮执行的操作涉及数据源和页面的更新时，要先更新数据源，在更新视图，否则会出现无响应的情况
    //此处UITableViewRowAction对象放入的顺序决定了对应按钮在cell中的顺序
    return@[action2,action1];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"cell";
    WKFocusAndFansTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
    {
        cell = [[WKFocusAndFansTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
//    cell.shareAnFocus.image = [UIImage imageNamed:@"fenxiang"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell getItem:self.dataArray[indexPath.row] type:_type];
    cell.clickCallBack = ^(ClickType type)
    {
        _selectClickType(indexPath.row,type);
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_selectClickType)
    {
        _selectClickType(indexPath.row,ClickLive);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}


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
