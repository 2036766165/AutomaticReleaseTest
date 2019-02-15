//
//  WKAddressTableView.m
//  秀加加
//
//  Created by lin on 16/9/5.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKAddressTableView.h"
#import "WKAddressTableViewCell.h"
#import "WKAddressModel.h"

@interface WKAddressTableView (){
    NSMutableArray *_selectedArr;
}
@end

@implementation WKAddressTableView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self =[super initWithFrame:frame])
    {
        _selectedArr = @[].mutableCopy;
        self.isOpenHeaderRefresh = YES;
        self.isOpenFooterRefresh = NO;
        self.tableView.showsVerticalScrollIndicator = NO;
//        [self.tableView initWithFrame:frame style:UITableViewStyleGrouped];
    }
    return self;
}


- (void)setIsEidt:(BOOL)isEidt{
    _isEidt = isEidt;
    
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//设置滑动时显示多个按钮
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    //添加一个删除按钮
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDestructive) title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        if ([_delegate respondsToSelector:@selector(operateGoods:obj:)]) {
            WKAddressListItem *item = self.dataArray[indexPath.row];
            [_delegate operateGoods:WKOperateTypeDelete obj:@[item.ID]];
        }
    }];
    
    //删除按钮颜色
    deleteAction.backgroundColor = [UIColor redColor];
    //添加一个置顶按钮
    UITableViewRowAction *topRowAction =[UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDestructive) title:@"编辑" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        if ([_delegate respondsToSelector:@selector(operateGoods:obj:)]) {
            WKAddressListItem *item = self.dataArray[indexPath.row];
            [_delegate operateGoods:WKOperateTypeEdit obj:item];
        }
    }];
    
    topRowAction.backgroundColor = [UIColor lightGrayColor];
    
    //将设置好的按钮方到数组中返回
    return @[deleteAction,topRowAction];
    // return @[deleteAction,topRowAction,collectRowAction];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = @"cell";
    WKAddressTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
    {
        cell = [[WKAddressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setItem:self.dataArray[indexPath.row] isEdit:self.isEidt];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WKAddressListItem *item = self.dataArray[indexPath.row];
    if (_isEidt) {
        // 编辑
        item.isSelected = !item.isSelected;
        WKAddressTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell setItem:item isEdit:_isEidt];
        
        if (item.isSelected) {
            [_selectedArr addObject:item.ID];
        }else{
            [_selectedArr removeObject:item.ID];
        }
        
    }else{
        // 查看详情
        if ([_delegate respondsToSelector:@selector(operateGoods:obj:)]) {
            [_delegate operateGoods:WKOperateTypeDetail obj:item];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}



//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete)
//    {
//        if ([_delegate respondsToSelector:@selector(operateGoods:obj:)]) {
//            WKAddressListItem *item = self.dataArray[indexPath.row];
//            [_delegate operateGoods:WKOperateTypeDelete obj:item];
//        }
//    }
//}

- (NSArray *)getSelectedArr{
    return _selectedArr;
}

- (void)headerRequestWithData{
//    self.pageNO = 1;
    if (self.requestBlock) {
        self.requestBlock();
    }
}

- (void)footerRequestWithData{
//    self.pageNO += 1;
//    self.pageSize = 10;
    if (self.requestBlock) {
        self.requestBlock();
    }
}



@end
