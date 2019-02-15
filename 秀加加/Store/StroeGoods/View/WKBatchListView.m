//
//  WKBatchListView.m
//  秀加加
//
//  Created by sks on 2016/9/20.
//  Copyright © 2016年 walkingtec. All rights reserved.
//

#import "WKBatchListView.h"
#import "WKBatchTableViewCell.h"
#import "WKGoodsModel.h"

static NSString *cellId = @"cellId";

@interface WKBatchListView (){
    WKGoodsType _type;
}

@property (nonatomic,strong) NSMutableArray *selectedArr;

@end

@implementation WKBatchListView

- (instancetype)initWithFrame:(CGRect)frame with:(WKGoodsType)type{
    if (self = [super initWithFrame:frame]) {
        _type = type;
        self.isOpenHeaderRefresh = YES;
        self.isOpenFooterRefresh = YES;
        self.tableView.showsVerticalScrollIndicator = NO;
    }
    return self;
}

- (NSMutableArray *)selectedArr{
    if (!_selectedArr) {
        _selectedArr = @[].mutableCopy;
    }
    return _selectedArr;
}

#pragma mark - UITableView delegate/DataSouce
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WKBatchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[WKBatchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    WKGoodsListItem *item = self.dataArray[indexPath.row];
    if ([self.selectedArr containsObject:item.GoodsCode]) {
        item.isSelected = YES;
    }else{
        item.isSelected = NO;
    }
    
    [cell setModel:self.dataArray[indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WKGoodsListItem *item = self.dataArray[indexPath.row];
    item.isSelected = !item.isSelected;
    WKBatchTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setModel:item];
    
    if (item.isSelected) {
        [self.selectedArr addObject:item.GoodsCode];
    }else{
        [self.selectedArr removeObject:item.GoodsCode];
    }
}

- (NSArray *)getSelectedArr{
    return self.selectedArr;
}

- (void)resetSelectedArr{
    [self.selectedArr removeAllObjects];
}

- (void)headerRequestWithData{
    self.pageNO = 1;
    if (self.requestBlock) {
        self.requestBlock();
    }
}

- (void)footerRequestWithData{
    self.pageNO += 1;
    self.pageSize = 10;
    if (self.requestBlock) {
        self.requestBlock();
    }
}

-(void)promptViewShow:(NSString *)message{
    [WKPromptView showPromptView:message];
}

@end
